//
//  FBSingletonNew.h
//  WhackwhoNew
//
//  Created by chun su on 2012-11-19.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import <FBSingletonNewDelegate.h>
#import "UserInfo.h"

@interface FBSingletonNew : NSObject<FBDialogDelegate>{
    FBProfilePictureView *profileImageView;
    id<FBSingletonNewDelegate> delegate;
}



@property (nonatomic,retain) FBProfilePictureView *profileImageView;
@property (nonatomic) id<FBSingletonNewDelegate> delegate;
@property (strong, nonatomic) Facebook *facebook;
@property (nonatomic, retain) NSURL *openedURL;


+ (FBSingletonNew *) sharedInstance;


-(BOOL)isLogin;
-(void)performLogin;
-(void)performLogout;
-(void)populateUserDetails;
-(void)RequestAllFriends;
-(void)requestFriendsUsing;
-(void)openSession;
-(void)sendRequest;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
- (void) sendRequest;
- (void)sendRequestToiOSFriends;
- (NSDictionary*)parseURLParams:(NSString *)query;
- (void) checkIncomingNotification;

@end
