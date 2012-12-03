//
//  FBSingletonNew.h
//  WhackwhoNew
//
//  Created by chun su on 2012-11-19.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FBSingletonNewDelegate.h>
#import "UserInfo.h"

@interface FBSingletonNew : NSObject{
    FBProfilePictureView *profileImageView;
    id<FBSingletonNewDelegate> delegate;
}

@property (nonatomic,retain) FBProfilePictureView *profileImageView;
@property (nonatomic) id<FBSingletonNewDelegate> delegate;


+ (FBSingletonNew *) sharedInstance;


-(BOOL)isLogin;
-(void)performLogin;
-(void)performLogout;
-(void)populateUserDetails;
-(void)RequestFriendsAll;
-(void)openSession;

@end
