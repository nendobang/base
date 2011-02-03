#import "NBkit.h"
#import "NBGameCenter.h"

/**
 * ゲームセンター
 */
@implementation NBGameCenter
//
@synthesize available=available_;
@synthesize authstate=authstate_;

static NBGameCenter* defaultGameCenter = nil;
///
+ (NBGameCenter*)instance {
	NB_ASSERT(defaultGameCenter != nil);
	return defaultGameCenter;
}
///
+ (void)setup {
	NB_ASSERT(defaultGameCenter == nil);
	if (defaultGameCenter == nil) {
		defaultGameCenter = [[NBGameCenter alloc] init];
	}
}
///
+ (void)cleanup {
	NB_ASSERT(defaultGameCenter != nil);
	NB_RELEASE(defaultGameCenter);
}


/// コンストラクタ
- (id)init {
	NB_ASSERT(defaultGameCenter == nil);
	if (self = [super init]) {
		defaultGameCenter = self;
		authstate_ = NBGameCenterAuthStateNot;
		available_ = [NBGameCenter checkGameCenterSupport];
		if (available_) {
			localplayer_ = [GKLocalPlayer localPlayer];
			[[NSNotificationCenter defaultCenter]
				addObserver:self
				   selector:@selector(authenticationChanged)
					   name:GKPlayerAuthenticationDidChangeNotificationName
					 object:nil];
		}
	}
	return self;
}
/// @internal デストラクタ
- (void)dealloc {
	[[NSNotificationCenter defaultCenter]
		removeObserver:self
				  name:GKPlayerAuthenticationDidChangeNotificationName
				object:nil];
	[super dealloc];
}
/// @internal デバイスがゲームセンターをサポートしているか
+ (BOOL)checkGameCenterSupport {
	Class gcclass = NSClassFromString(@"GKLocalPlayer");
	NSString* reqsysver = @"4.1";
	NSString* cursysver = [[UIDevice currentDevice] systemVersion];
	BOOL osversupp = ([cursysver compare:reqsysver options:NSNumericSearch] != NSOrderedAscending);
	return (gcclass && osversupp);
}
/// ローカルプレイヤの認証を開始する
- (void)authenticate {
	if (authstate_ != NBGameCenterAuthStateNot) {
		return;
	}
	authstate_ = NBGameCenterAuthStateRequested;
	[localplayer_ authenticateWithCompletionHandler:^(NSError* err) {
		if (err == nil) {
			NB_LOG(@"SUCCEED");
			NB_LOG(@"alias: %@", localplayer_.alias);
			NB_LOG(@"playerID: %@", localplayer_.playerID);
		} else {
			NB_LOG(@"FAILED");
			authstate_ = NBGameCenterAuthStateNot; // キャンセルされた（他に原因あるか？）
		}
	}];
}
///
- (void)authenticationChanged {
	NB_RELEASE(friends_); // どっちにしろフレンド情報は破棄する
	if ([GKLocalPlayer localPlayer].isAuthenticated) {
		NB_LOG(@"AUTHENTICATED");
		authstate_ = NBGameCenterAuthStateOK; // 認証完了
	} else {
		NB_LOG(@"NOT AUTHENTICATED");
		authstate_ = NBGameCenterAuthStateRequested; // 一旦リクエスト状態に戻る
	}
}
/// 友達リスト取得
- (void)retrieveFriends {
	if (localplayer_.authenticated) {
		[localplayer_ loadFriendsWithCompletionHandler:^(NSArray* friends, NSError* err) {
			if (err == nil) {
				[self loadPlayerData:friends];
				NB_LOG(@"FRI: %d", friends.count);
			} else {
				NB_LOG(@"FAIL");
			}
		}];
	}
}
/// @internal フレンドのIDからプレイヤデータを取得する
- (void)loadPlayerData:(NSArray*)ids {
	[GKPlayer loadPlayersForIdentifiers:ids withCompletionHandler:^(NSArray* players, NSError* err) {
		if (err == nil) {
			NB_LOG(@"PLAYERS: %d", [players retainCount]);
			NB_RELEASE(friends_);
			friends_ = [players retain];
		} else {
		}
	}];
}
/// デフォルトのリーダーボードを表示する
- (void)showDefaultLeaderboard:(UIViewController*)parent {
	[self showDefaultLeaderboard:parent
					withCategory:leaderboardcategory_
					andTimeScope:leaderboardtimescope_];
}
/// カテゴリとタイムスコープを指定してデフォルトのリーダーボードを表示する
- (void)showDefaultLeaderboard:(UIViewController*)parent withCategory:(NSString*)category andTimeScope:(GKLeaderboardTimeScope)timescope {
	GKLeaderboardViewController* lvc =
		[[GKLeaderboardViewController alloc] init];
	if (lvc != nil) {
		leaderboardparent_ = NB_RETAIN(parent);
		lvc.category = category;
		lvc.timeScope = timescope;
		lvc.leaderboardDelegate = self;
		[parent presentModalViewController:lvc animated:YES];
	}
}
/// @internal リーダーボード表示終了時に呼ばれる
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)lvc {
	[leaderboardparent_ dismissModalViewControllerAnimated:YES];
	// 最後にユーザが指定したであろう設定を保存しておく
	NB_RELEASE(leaderboardcategory_);
	leaderboardcategory_ = NB_RETAIN(lvc.category);
	leaderboardtimescope_ = lvc.timeScope;
	NB_RELEASE(leaderboardparent_);
	NB_RELEASE(lvc);
	NB_LOG(@"FINISHED");
}




@end

