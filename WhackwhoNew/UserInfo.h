//
//  UserInfo.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NSString *const UserLeftEyePosition = @"LeftEyePosition";
NSString *const UserRightEyePosition = @"RightEyePosition";
NSString *const UserMouthPosition = @"MouthPosition";
NSString *const UserLeftCheekPosition = @"LeftCheekPosition";
NSString *const UserRightCheekPosition = @"RightCheekPosition";
NSString *const UserNosePosition = @"NosePosition";
NSString *const UserChinPosition = @"ChinPosition";



@interface UserInfo : NSObject {
    @public
    int currentLogInType;
    NSString *userName;
    NSString *userId;
    NSString *gender;
    
    
    // Avatar stuff
    
    
    @private
    UIImage *croppedImage;
    UIImage *usrImg;
    
    CGPoint leftEyePosition, rightEyePosition, mouthPosition;
    CGRect faceRect;
}

@property (nonatomic, retain) NSString *userId, *userName, *gender;
@property (nonatomic, readwrite) int currentLogInType;
@property (nonatomic, assign) CGPoint leftEyePosition, rightEyePosition, mouthPosition;;
@property (nonatomic, assign) CGRect faceRect;


+(id)sharedInstance;
-(void) clearUserInfo;
-(void) setUserPicture:(UIImage *)img;
-(UIImage *)getCroppedImage;

@end
