//
//  FBSingletonDelegate.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-03.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBSingletonDelegate <NSObject>

@optional
-(void)FBProfilePictureLoaded:(UIImage *)img;
-(void)FbMeLoaded:(NSString *)userId :(NSString *)userName : (NSString *)gender;
-(void)FBSingletonDidLogout;
-(void)FBSingletonDidLogin:(NSString *)userId: (NSString *) userName : (NSString *)gender;
-(void)FBSIngletonUserFriendsDidLoaded:(NSMutableArray *) friends;

@end
