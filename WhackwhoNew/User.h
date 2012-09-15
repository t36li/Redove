//
//  User.h
//  WhackwhoNew
//
//  Created by Zach Su on 2012-08-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface User : NSObject{
@public
    int whackWhoId;
    int mediaTypeId;
    int headId;
    NSString *mediaKey;
    NSString *userImgURL;
    
    
    NSString *leftEyePosition;
    NSString *rightEyePosition;
    NSString *mouthPosition;
    NSString *faceRect;
    NSDate *registeredDate;
    
    NSString *helmet;
    NSString *hammerArm;
    NSString *shieldArm;
    NSString *body;
}


@property (nonatomic, readwrite) int whackWhoId,mediaTypeId,headId;
@property (nonatomic, retain) NSString *mediaKey,*leftEyePosition,*rightEyePosition,*mouthPosition,*faceRect;
@property (nonatomic, retain) NSString *userImgURL;
@property (nonatomic, retain) NSDate *registeredDate;
@property (nonatomic, retain) NSString *helmet, *hammerArm, *shieldArm, *body;

-(void)copyToUserInfo;
-(void)getFromUserInfo;
+(void)objectMappingLoader;
@end
