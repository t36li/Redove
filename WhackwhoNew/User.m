//
//  User.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-08-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "User.h"
#import "UserInfo.h"

@implementation User
@synthesize mediaTypeId,whackWhoId,headId,mediaKey,croppedImgURL,gameImgURL,userImgURL,leftEyePosition,rightEyePosition,mouthPosition,faceRect,registeredDate;

static User *sharedInstance = nil;

+(User *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            
            //set up object mapping:
            RKObjectMapping *userInfoMapping = [RKObjectMapping mappingForClass:[sharedInstance class]];
            [userInfoMapping mapKeyPath:@"whackwho_id" toAttribute:@"whackWhoId"];
            [userInfoMapping mapKeyPath:@"media_key" toAttribute:@"mediaKey"];
            [userInfoMapping mapKeyPath:@"mediatype_id" toAttribute:@"mediaTypeId"];
            [userInfoMapping mapKeyPath:@"gen_date" toAttribute:@"registeredDate"];
            [userInfoMapping mapKeyPath:@"head_id" toAttribute:@"headId"];
            [userInfoMapping mapKeyPath:@"croppedImgURL" toAttribute:@"croppedImgURL"];
            [userInfoMapping mapKeyPath:@"userImgURL" toAttribute:@"userImgURL"];
            [userInfoMapping mapKeyPath:@"gameImgURL" toAttribute:@"gameImgURL"];
            [userInfoMapping mapKeyPath:@"leftEyePosition" toAttribute:@"leftEyePosition"];
            [userInfoMapping mapKeyPath:@"rightEyePosition" toAttribute:@"rightEyePosition"];
            [userInfoMapping mapKeyPath:@"mouthPosition" toAttribute:@"mouthPosition"];
            [userInfoMapping mapKeyPath:@"faceRect" toAttribute:@"faceRect"];
            
            [[RKObjectManager sharedManager].mappingProvider setMapping:userInfoMapping forKeyPath:@""];
            //[[RKObjectManager sharedManager].mappingProvider registerMapping:userInfoMapping withRootKeyPath:@""];
            //[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[User class]];
            [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
            [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[sharedInstance class]];
            [[RKObjectManager sharedManager].router routeClass:[sharedInstance class] toResourcePath:@"/user" forMethod:RKRequestMethodPOST];
            
        }
    }
    return sharedInstance;
}

-(void)CopyToUserInfo{
    UserInfo *usrInfo = [UserInfo sharedInstance];
    [usrInfo setCurrentLogInType: mediaTypeId];
    [usrInfo setUserId:mediaKey];
    [usrInfo setLeftEyePosition:CGPointFromString(leftEyePosition)];
    [usrInfo setRightEyePosition:CGPointFromString(rightEyePosition)];
    [usrInfo setMouthPosition:CGPointFromString(mouthPosition)];
    [usrInfo setFaceRect:CGRectFromString(faceRect)];
    usrInfo->croppedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:croppedImgURL]]];
    usrInfo->usrImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImgURL]]];
    usrInfo->gameImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:gameImgURL]]];
    
    /*
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:formatting] success:^(UIImage *image) {
        [cell.spinner removeSpinner];
    }failure:^(NSError *error) {
        [cell.spinner removeSpinner];
    }];
    
    
    */
}


@end
