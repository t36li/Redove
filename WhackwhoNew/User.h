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
    NSString *croppedImgURL;
    NSString *userImgURL;
    NSString *gameImgURL;
    
    NSString *leftEyePosition;
    NSString *rightEyePosition;
    NSString *mouthPosition;
    NSString *faceRect;
    NSDate *registeredDate;
}


@property (nonatomic, readwrite) int whackWhoId,mediaTypeId,headId;
@property (nonatomic, retain) NSString *mediaKey,*leftEyePosition,*rightEyePosition,*mouthPosition,*faceRect;
@property (nonatomic, retain) NSString *croppedImgURL, *userImgURL, *gameImgURL;
@property (nonatomic, retain) NSDate *registeredDate;

-(NSString *)croppedImgURL;
-(NSString *)gameImgURL;
-(NSString *)userImgURL;
-(void)setCroppedImgURL:(NSString *)croppedImgURL;
-(void)setGameImgURL:(NSString *)gameImgURL;
-(void)setUserImgURL:(NSString *)userImgURL;

-(void)copyToUserInfo;
-(void)getFromUserInfo;
@end
