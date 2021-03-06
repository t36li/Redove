//
//  UserInfo.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "FBSingletonNew.h"
#import "UserInfoDelegate.h"
#import "CurrentEquip.h"
#import "StorageInv.h"
#import "Friend.h"
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
    NSInteger currentLogInType;
    NSString *userName;
    NSString *userId;
    NSString *gender;
    //FBProfilePictureView *profileImageView;
    
    // Avatar stuff
    NSInteger whackWhoId;
    NSInteger headId;
    NSInteger popularity;
    
    //@private
    NSString *usrImgURL;
    UIImage *croppedImage;
    UIImage *usrImg;
    //UIImage *gameImage;
    CGPoint leftEyePosition, rightEyePosition, mouthPosition;
    CGPoint nosePosition, leftEarPosition, rightEarPosition;
    CGRect faceRect;
    
    CurrentEquip *currentEquip;
    StorageInv *storageInv;
    NSDictionary *myFriendPlayers;
    FriendArray *friendArray;
    
//    id<UserInfoDelegate> delegate;
}

@property (nonatomic, strong) NSString *userId, *userName, *gender;
@property (nonatomic) CGPoint leftEyePosition, rightEyePosition, mouthPosition;
@property (nonatomic) CGPoint nosePosition, leftEarPosition, rightEarPosition;

@property (nonatomic) CGRect faceRect;
//@property (nonatomic) id<UserInfoDelegate> delegate;
@property (nonatomic) NSInteger currentLogInType, whackWhoId, headId,popularity;

@property (nonatomic, strong) UIImage *croppedImage, *usrImg;
@property (nonatomic, retain) CurrentEquip *currentEquip;
@property (nonatomic, retain) StorageInv *storageInv;
@property (nonatomic, retain) FriendArray *friendArray;
@property (nonatomic, retain) NSDictionary *myFriendPlayers;
//@property (nonatomic, retain) FBProfilePictureView *profileImageView;

//-(void)markFaces:(UIImage *)img withDelegate:(id<UserInfoDelegate>)delegate;
+(id)sharedInstance;
-(void) clearUserInfo;
//-(void) setUserPicture:(UIImage *)img delegate:(id)sender;
+(UIImage *)getCroppedImage:(UIImage *)img inRect:(CGRect)rect;
+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize;
-(void)LogInTypeChanged:(LogInType) type;
-(void)closeInstance;
-(void)clearUserFacialFeaturePositions;
@end
