//
//  User.h
//  WhackwhoNew
//
//  Created by Zach Su on 2012-08-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CurrentEquip.h"
#import "StorageInv.h"

@interface User : NSObject{
@public
    int whackWhoId;
    int mediaTypeId;
    int headId;
    NSString *mediaKey;
    NSString *userImgURL;
    NSInteger popularity;
    
    
    NSString *leftEyePosition;
    NSString *rightEyePosition;
    NSString *mouthPosition;
    NSString *faceRect;
    NSString *nosePosition, *leftEarPosition, *rightEarPosition;
    NSDate *registeredDate;
    CurrentEquip *currentEquip;//only id (redesign string as image filename when copying to userInfo
    StorageInv *storageInv;
    
}


@property (nonatomic, readwrite) int whackWhoId,mediaTypeId,headId;
@property (nonatomic, retain) NSString *mediaKey,*leftEyePosition,*rightEyePosition,*mouthPosition,*faceRect;
@property (nonatomic, retain) NSString *userImgURL;
@property (nonatomic, retain) NSDate *registeredDate;
@property (nonatomic, retain) CurrentEquip *currentEquip;
@property (nonatomic, retain) StorageInv *storageInv;
@property (nonatomic) NSInteger popularity;
@property (nonatomic) NSString *nosePosition, *leftEarPosition, *rightEarPosition;


-(void)copyToUserInfo;
-(void)getFromUserInfo;
+(void)objectMappingLoader;
@end
