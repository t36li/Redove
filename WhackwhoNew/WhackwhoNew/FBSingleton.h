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
    kAPIGraphMeLogIn,
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
@public
    
    int currentAPICall;
    Facebook* _facebook;
    NSArray* _permissions;
    BOOL isLogIn;
    NSArray *savedAPIResult;
    id<FBSingletonDelegate> delegate;
    // Internal state
    int score;
}
@property (readonly) Facebook *facebook;
@property (nonatomic, retain) id<FBSingletonDelegate> delegate;
@property (nonatomic, assign) BOOL isLogIn;

+ (FBSingleton *) sharedInstance;


#pragma mark - Public Methods
-(void) postToWallWithDialogNewHighscore:(int)highscore;
-(void) RequestMe;
-(void) RequestFriendList;
-(void) logout;
-(void) login;
-(void) RequestFriendsNotUsing;

@end 
