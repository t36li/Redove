//
//  FBSingleton.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-03.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FBSingletonDelegate.h"

typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;

@interface FBSingleton : NSObject<FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
    int currentAPICall;
    Facebook* _facebook;
    NSArray* _permissions;
    id<FBSingletonDelegate> delegate;
    // Internal state
    int score;
}
@property(readonly) Facebook *facebook;
@property(nonatomic, retain) id<FBSingletonDelegate> delegate;

+ (FBSingleton *) sharedInstance;

#pragma mark - Public Methods
-(void) postToWallWithDialogNewHighscore:(int)highscore;
-(void) RequestMeProfileImage;
-(void) logout;
-(void) login;
-(BOOL) isLogin;

@end
