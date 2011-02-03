




/** 認証状態 */
typedef enum {
	NBGameCenterAuthStateNot,		///< 非認証状態
	NBGameCenterAuthStateRequested,	///< 認証リクエスト
	NBGameCenterAuthStateOK,		///< 認証完了
} NBGameCenterAuthState;


// ゲームセンター
@interface NBGameCenter : NSObject {
	GKLocalPlayer* localplayer_;
	BOOL available_;
	NBGameCenterAuthState authstate_;
	NSArray* friends_;
}
@property (nonatomic, readonly) BOOL available;
@property (nonatomic, readonly) NBGameCenterAuthState authstate;
+ (BOOL)checkGameCenterSupport;


@end


