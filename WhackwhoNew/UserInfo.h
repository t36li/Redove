//
//  UserInfo.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoDelegate.h"

@interface UserInfo : NSObject {
    @public
    int currentLogInType;
    NSString *userName;
    NSString *userId;
    NSString *gender;
    UIImage *croppedImage;
    UIImage *usrImg;
    id<UserInfoDelegate> delegate;
}

@property (nonatomic, retain) UIImage *usrImg, *croppedImage;
@property (nonatomic, retain) NSString *userId, *userName, *gender;
@property (nonatomic, readwrite) int currentLogInType;
@property(nonatomic, retain) id<UserInfoDelegate> delegate;

+(id)sharedInstance;

-(void) clearUserInfo;

@end
