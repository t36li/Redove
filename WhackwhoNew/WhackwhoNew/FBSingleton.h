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
#import "Friend.h"

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


@interface FBSingleton : NSObject<FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, NSURLConnectionDelegate> {
@public
    
    int currentAPICall;
    Facebook* _facebook;
    NSArray* _permissions;
    BOOL isLogIn;
    NSArray *savedAPIResult;
    id<FBSingletonDelegate> delegate;
    NSMutableData *responseData;
    NSMutableDictionary *friendsDictionary;
    // Internal state
    int score;
}
@property (readonly) Facebook *facebook;
@property (nonatomic, retain) id<FBSingletonDelegate> delegate;
@property (nonatomic, assign) BOOL isLogIn;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableDictionary *friendsDictionary;

+ (FBSingleton *) sharedInstance;


#pragma mark - Public Methods
-(void) postToWallWithDialogNewHighscore:(int)highscore;
-(void) RequestMe;
-(void) RequestProfilePic:(NSString *)profileID;
-(void) RequestFriendList;
-(void) logout;
-(void) login;
-(void) RequestFriendsNotUsing;

@end 
