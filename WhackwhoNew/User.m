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
@synthesize mediaTypeId,whackWhoId,headId,mediaKey,leftEyePosition,rightEyePosition,mouthPosition,faceRect,registeredDate;


-(NSString *)croppedImgURL{
    return croppedImgURL;
}
-(NSString *)gameImgURL{
    return gameImgURL;
}
-(NSString *)userImgURL{
    return userImgURL;
}
-(void)setCroppedImgURL{
    croppedImgURL = [NSString stringWithFormat:@"%@%@%d%@",ImageURL,@"/croppedImage/",headId,@".png"];
}
-(void)setGameImgURL{
    gameImgURL = [NSString stringWithFormat:@"%@%@%d%@",ImageURL,@"/gameImage/",headId,@".png"];
}

-(void)setUserImgURL{
    userImgURL = [NSString stringWithFormat:@"%@%@%d%@",ImageURL,@"/userImage/",headId,@".png"];
}

-(void)copyToUserInfo{
    UserInfo *usrInfo = [UserInfo sharedInstance];
    [usrInfo setCurrentLogInType: mediaTypeId];
    [usrInfo setUserId:mediaKey];
    [usrInfo setLeftEyePosition:CGPointFromString(leftEyePosition)];
    [usrInfo setRightEyePosition:CGPointFromString(rightEyePosition)];
    [usrInfo setMouthPosition:CGPointFromString(mouthPosition)];
    [usrInfo setFaceRect:CGRectFromString(faceRect)];
    if (croppedImgURL != nil && userImgURL !=nil && & gameImgURL !=nil) {
        
        usrInfo->croppedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:croppedImgURL]]];
        usrInfo->usrImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImgURL]]];
        usrInfo->gameImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:gameImgURL]]];
    }
    /*
     [cell.profileImageView setImageWithURL:[NSURL URLWithString:formatting] success:^(UIImage *image) {
     [cell.spinner removeSpinner];
     }failure:^(NSError *error) {
     [cell.spinner removeSpinner];
     }];
     
     
     */
}

-(void)getFromUserInfo{
    UserInfo *usrInfo = [UserInfo sharedInstance];
    mediaTypeId = usrInfo.currentLogInType;
    mediaKey = usrInfo.userId;
    leftEyePosition = NSStringFromCGPoint(usrInfo.leftEyePosition);
    rightEyePosition = NSStringFromCGPoint(usrInfo.rightEyePosition);
    mouthPosition = NSStringFromCGPoint(usrInfo.mouthPosition);
    faceRect = NSStringFromCGRect(usrInfo.faceRect);
    
}


@end
