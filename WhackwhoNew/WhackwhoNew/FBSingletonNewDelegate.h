//
//  FBSingletonNewDelegate.h
//  WhackwhoNew
//
//  Created by chun su on 2012-11-19.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol FBSingletonNewDelegate <NSObject>

@optional
-(void)FBUserProfileLoaded;
-(void)FBUserProfileLoadFailed:(NSError *)error;
-(void)FBLogOutSuccess;
-(void)populateUserDetailsCompleted;

@end
