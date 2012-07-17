//
//  UserInfo.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize usrImg, croppedImage, userName, userId, currentLogInType, gender, bigHeadImg;

static UserInfo *sharedInstance = nil;

+(UserInfo *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

-(void) clearUserInfo{
    [self setCurrentLogInType:NotLogIn];
    [self setUserId:nil];
    [self setUserName:nil];
    [self setUsrImg:nil];
    [self setCroppedImage:nil];
    [self setGender:nil];
}

@end
