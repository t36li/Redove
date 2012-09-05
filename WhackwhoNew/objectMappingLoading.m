//
//  objectMappingLoading.m
//  WhackwhoNew
//
//  Created by Zach Su on 2012-08-06.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "objectMappingLoading.h"
#import "User.h"

@implementation objectMappingLoading

-(void)userObjectMappingLoading{
    //set up object mapping:
    RKObjectMapping *userInfoMapping = [RKObjectMapping mappingForClass:[User class]];
    [userInfoMapping mapKeyPath:@"whackwho_id" toAttribute:@"whackWhoId"];
    [userInfoMapping mapKeyPath:@"media_key" toAttribute:@"mediaKey"];
    [userInfoMapping mapKeyPath:@"mediatype_id" toAttribute:@"mediaTypeId"];
    [userInfoMapping mapKeyPath:@"gen_date" toAttribute:@"registeredDate"];
    [userInfoMapping mapKeyPath:@"head_id" toAttribute:@"headId"];
    //[userInfoMapping mapKeyPath:@"croppedImgURL" toAttribute:@"croppedImgURL"];
    //[userInfoMapping mapKeyPath:@"userImgURL" toAttribute:@"userImgURL"];
    //[userInfoMapping mapKeyPath:@"gameImgURL" toAttribute:@"gameImgURL"];
    [userInfoMapping mapKeyPath:@"leftEyePosition" toAttribute:@"leftEyePosition"];
    [userInfoMapping mapKeyPath:@"rightEyePosition" toAttribute:@"rightEyePosition"];
    [userInfoMapping mapKeyPath:@"mouthPosition" toAttribute:@"mouthPosition"];
    [userInfoMapping mapKeyPath:@"faceRect" toAttribute:@"faceRect"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:userInfoMapping forKeyPath:@""];
    //[[RKObjectManager sharedManager].mappingProvider registerMapping:userInfoMapping withRootKeyPath:@""];
    //[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[User class]];
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[User class]];
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/user" forMethod:RKRequestMethodPOST];

}

@end
