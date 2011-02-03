#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

/** 認証状態 */
typedef enum {
	NBGameCenterAuthStateNot,				///< 非認証状態
	NBGameCenterAuthStateRequested,			///< 認証リクエスト
	NBGameCenterAuthStateOK,				///< 認証完了
} NBGameCenterAuthState;

//typedef enum {
//	NBGameCenterAuthStateRetrieveFriedns,	///< フレンドリストを取得中
//	NBGameCenterAuthStateComplete,			///< フレンドリストの取得完了
//} NBGameCenter;

// ゲームセンター
@interface NBGameCenter : NSObject <GKLeaderboardViewControllerDelegate> {
	GKLocalPlayer* localplayer_;
	BOOL available_;
	NBGameCenterAuthState authstate_;
	NSArray* friends_;					///< フレンドのGKPlayer*の配列

	NSString* leaderboardcategory_;
	GKLeaderboardTimeScope leaderboardtimescope_;
	UIViewController* leaderboardparent_;
}
@property (nonatomic, readonly) BOOL available;
@property (nonatomic, readonly) NBGameCenterAuthState authstate;
+ (NBGameCenter*)instance;
+ (void)setup;
+ (void)cleanup;
- (void)authenticate;
- (void)retrieveFriends;
- (void)showDefaultLeaderboard:(UIViewController*)parent;
- (void)showDefaultLeaderboard:(UIViewController*)parent withCategory:(NSString*)category andTimeScope:(GKLeaderboardTimeScope)timescope;





+ (BOOL)checkGameCenterSupport;
- (void)authenticationChanged;
- (void)loadPlayerData:(NSArray*)ids;





@end


