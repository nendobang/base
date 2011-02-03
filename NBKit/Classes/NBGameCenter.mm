#import "NBGameCenter.h"

/**
 * ゲームセンター
 */
@implementation NBGameCenter
@synthesize available=available_;
@synthesize authstate=authstate_;

/// コンストラクタ
- (id)init {
	if (self = [super init]) {
		localplayer_ = nil;
		authstate_ = NBGameCenterAuthStateNot;
		available_ = [NBGameCenter checkGameCenterSupport];
		if (available_) {
			localplayer_ = [GKLocalPlayer localPlayer];
			[self registerForAuthenticationNotification];
		}
	}
	return self;
}
/// デバイスがゲームセンターをサポートしているか
+ (BOOL)checkGameCenterSupport {
	Class gcclass = NSClassFromString(@"GKLocalPlayer");
	NSString* reqsysver = @"4.1";
	NSString* cursysver = [[UIDevice currentDevice] systemVersion];
	BOOL osversupp = ([cursysver compare:reqsysver options:NSNumericSearch] != NSOrderedAscending);
	return (gcclass && osversupp);
}
///
- (void)authenticateLocalPlayer {
	if (authstate_ != NBGameCenterAuthStateNot) {
		return;
	}
	[localplayer_ authenticateWithCompletionHandler:^(NSError* err) {
		if (err == nil) {
			NS_LOG(@"SUCCEED");
			NS_LOG(@"alias: %@", localplayer_.alias);
			NS_LOG(@"playerID: %@", localplayer_.playerID);
		} else {
			NS_LOG(@"FAILED");
		}
	}];
}
///@internal
- (void)registerForAuthenticationNotification {
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		   selector:@selector(authenticationChanged)
			   name:GKPlayerAuthenticationDidChangeNotificationName
			 object:nil];
}
///
- (void)authenticationChanged {
	if ([GKLocalPlayer localPlayer].isAuthenticated) {
		NS_LOG(@"AUTHENTICATED");
		authstate_ = NBGameCenterAuthStateOK;
		[self retrieveFriends];
	} else {
		NS_LOG(@"NOT AUTHENTICATED");
		authstate_ = NBGameCenterAuthStateNot;
	}
}
/// 友達リスト取得
- (void)retrieveFriends {
	if (localplayer_.authenticated) {
		[localplayer_ loadFriendsWithCompletionHandler:^(NSArray* friends, NSError* err) {
			if (err == nil) {
				[self loadPlayerData:friends];
				NS_LOG(@"FRI: %d", friends.count);
			
			
			
			
			} else {
				NS_LOG(@"FAIL");
			}
		}];
	}
}
///
- (void)loadPlayerData:(NSArray*)ids {
	[GKPlayer loadPlayersForIdentifiers:ids withCompletionHandler:^(NSArray* players, NSError* err) {
		if (err == nil) {
			NS_LOG(@"PLAYERS: %d", [players retainCount]);
			[friends_ release];
			
			
			friends_ = [players retain];
		} else {
		}
	}];
}



@end

