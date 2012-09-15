//
//  User.m
//  WhackwhoNew
//
//  Created by Zach Su on 2012-08-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "User.h"
#import "UserInfo.h"

@implementation User
@synthesize mediaTypeId,whackWhoId,headId,mediaKey,leftEyePosition,rightEyePosition,mouthPosition,faceRect,registeredDate, userImgURL;



-(void)copyToUserInfo{
    UserInfo *usrInfo = [UserInfo sharedInstance];
    //[usrInfo setCurrentLogInType: mediaTypeId];
    //[usrInfo setUserId:mediaKey];
    [usrInfo setWhackWhoId:whackWhoId];
    [usrInfo setHeadId:headId];
    [usrInfo setLeftEyePosition:CGPointFromString(leftEyePosition)];
    [usrInfo setRightEyePosition:CGPointFromString(rightEyePosition)];
    [usrInfo setMouthPosition:CGPointFromString(mouthPosition)];
    [usrInfo setFaceRect:CGRectFromString(faceRect)];
    usrInfo->usrImgURL = userImgURL;
    
    int (^loadUserImage)() = ^int(){
        if (userImgURL != nil){
            [usrInfo setUsrImg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImgURL]]]];
            return 1;
        }
        return 0;
    };
    
    if (loadUserImage() == 1){
        usrInfo.croppedImage = [UserInfo getCroppedImage:usrInfo.usrImg inRect:[usrInfo faceRect]];
        NSLog(@"Game Image Loaded.");
    } else {
        NSLog(@"Game Image failed to load.");
    }
     
}

-(void)getFromUserInfo{
    UserInfo *usrInfo = [UserInfo sharedInstance];
    mediaTypeId = usrInfo.currentLogInType;
    whackWhoId = usrInfo.whackWhoId;
    headId = usrInfo.headId;
    mediaKey = usrInfo.userId;
    leftEyePosition = NSStringFromCGPoint(usrInfo.leftEyePosition);
    rightEyePosition = NSStringFromCGPoint(usrInfo.rightEyePosition);
    mouthPosition = NSStringFromCGPoint(usrInfo.mouthPosition);
    faceRect = NSStringFromCGRect(usrInfo.faceRect);
    userImgURL = usrInfo->usrImgURL;
    
}

+(void)objectMappingLoader{
    RKObjectMapping *userInfoMapping = [RKObjectMapping mappingForClass:[User class]];
    [userInfoMapping mapKeyPath:@"whackwho_id" toAttribute:@"whackWhoId"];
    [userInfoMapping mapKeyPath:@"media_key" toAttribute:@"mediaKey"];
    [userInfoMapping mapKeyPath:@"mediatype_id" toAttribute:@"mediaTypeId"];
    [userInfoMapping mapKeyPath:@"gen_date" toAttribute:@"registeredDate"];
    [userInfoMapping mapKeyPath:@"head_id" toAttribute:@"headId"];
    [userInfoMapping mapKeyPath:@"leftEyePosition" toAttribute:@"leftEyePosition"];
    [userInfoMapping mapKeyPath:@"rightEyePosition" toAttribute:@"rightEyePosition"];
    [userInfoMapping mapKeyPath:@"mouthPosition" toAttribute:@"mouthPosition"];
    [userInfoMapping mapKeyPath:@"faceRect" toAttribute:@"faceRect"];
    [userInfoMapping mapKeyPath:@"userImgURL" toAttribute:@"userImgURL"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:userInfoMapping forKeyPath:@"user"];
    //[[RKObjectManager sharedManager].mappingProvider registerMapping:userInfoMapping withRootKeyPath:@""];
    //[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[User class]];
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[User class]];
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/user" forMethod:RKRequestMethodPOST];
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/user" forMethod:RKRequestMethodPUT];
}




@end
