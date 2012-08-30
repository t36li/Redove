//
//  UserInfo.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserInfoDelegate.h"
/*
NSString *const UserLeftEyePosition = @"LeftEyePosition";
NSString *const UserRightEyePosition = @"RightEyePosition";
NSString *const UserMouthPosition = @"MouthPosition";
NSString *const UserLeftCheekPosition = @"LeftCheekPosition";
NSString *const UserRightCheekPosition = @"RightCheekPosition";
NSString *const UserNosePosition = @"NosePosition";
NSString *const UserChinPosition = @"ChinPosition";
*/


@interface UserInfo : NSObject {
    @public
    int currentLogInType;
    NSString *userName;
    NSString *userId;
    NSString *gender;
    
    
    
    // Avatar stuff
    int whackWhoId;
    int headId;
    
    //@private
    NSString *usrImgURL;
    UIImage *croppedImage;
    UIImage *usrImg;
    UIImage *gameImage;
    CGPoint leftEyePosition, rightEyePosition, mouthPosition;
    CGRect faceRect;
    
    id<UserInfoDelegate> delegate;
}

@property (nonatomic, retain) NSString *userId, *userName, *gender;
@property (nonatomic, readwrite) int currentLogInType,headId, whackWhoId;
@property (nonatomic, assign) CGPoint leftEyePosition, rightEyePosition, mouthPosition;;
@property (nonatomic, assign) CGRect faceRect;
@property (nonatomic) id<UserInfoDelegate> delegate;


+(id)sharedInstance;
-(void) clearUserInfo;
-(void) setUserPicture:(UIImage *)img delegate:(id)sender;
-(UIImage *)getCroppedImage;
-(void) setGameImage:(UIImage *)img;
+(UIImage *)getCroppedImage:(UIImage *)img inRect:(CGRect)rect;
-(UIImage *) exportImage;
-(CGPoint) getLeftEyePos;
-(CGPoint) getRightEyePos;
-(CGPoint) getMouthPos;
//-(UIImage *)getAvatarImage;

@end
