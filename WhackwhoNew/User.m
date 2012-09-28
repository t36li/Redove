//
//  User.m
//  WhackwhoNew
//
//  Created by Zach Su on 2012-08-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "User.h"
#import "UserInfo.h"
#import "Friend.h"

@implementation User
@synthesize mediaTypeId,whackWhoId,headId,mediaKey,leftEyePosition,rightEyePosition,mouthPosition,faceRect,registeredDate, userImgURL, currentEquip, storageInv;

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
    [usrInfo setCurrentEquip:[currentEquip currentEquipInFileNames]];
    [usrInfo setStorageInv:[storageInv setStorageArrayInFileNames]];
    usrInfo->usrImgURL = userImgURL;
    
    NSURL *url = [NSURL URLWithString:userImgURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    if (img != nil) {
        usrInfo.usrImg = img;
        usrInfo.croppedImage = img;
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
    currentEquip = [usrInfo.currentEquip currentEquipInIDs];
    storageInv = [usrInfo.storageInv setStorageStringInIDs];
    userImgURL = usrInfo->usrImgURL;
    
}

+(void)objectMappingLoader{
    //currentEquip mapping:
    RKObjectMapping *curEquipMapping = [RKObjectMapping mappingForClass:[CurrentEquip class]];
    [curEquipMapping mapKeyPath:@"Helmet" toAttribute:@"helmet"];
    [curEquipMapping mapKeyPath:@"Body" toAttribute:@"body"];
    [curEquipMapping mapKeyPath:@"hammerArm" toAttribute:@"hammerArm"];
    [curEquipMapping mapKeyPath:@"shieldArm" toAttribute:@"shieldArm"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:curEquipMapping forKeyPath:@"currentEquip"];
    
    //storage Mapping:
    RKObjectMapping *storageInvMapping = [RKObjectMapping mappingForClass:[StorageInv class]];
    [storageInvMapping mapKeyPath:@"HeadIDs" toAttribute:@"headIds"];
    [storageInvMapping mapKeyPath:@"Helmets" toAttribute:@"helmets"];
    [storageInvMapping mapKeyPath:@"Bodies" toAttribute:@"bodies"];
    [storageInvMapping mapKeyPath:@"HammerArms" toAttribute:@"hammerArms"];
    [storageInvMapping mapKeyPath:@"ShieldArms" toAttribute:@"shieldArms"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:storageInvMapping forKeyPath:@"storageInv"];
    
    //head Mapping:
    RKObjectMapping *headMapping = [RKObjectMapping mappingForClass:[Head class]];
    [headMapping mapKeyPath:@"head_id" toAttribute:@"headId"];
    [headMapping mapKeyPath:@"leftEyePosition" toAttribute:@"leftEyePosition"];
    [headMapping mapKeyPath:@"rightEyePosition" toAttribute:@"rightEyePosition"];
    [headMapping mapKeyPath:@"mouthPosition" toAttribute:@"mouthPosition"];
    [headMapping mapKeyPath:@"faceRect" toAttribute:@"faceRect"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:headMapping forKeyPath:@"head"];
    
    //friend mapping:
    RKObjectMapping *friendInfoMapping = [RKObjectMapping mappingForClass:[Friend class]];
    [friendInfoMapping mapKeyPath:@"mediatype_id" toAttribute:@"mediatype_id"];
    [friendInfoMapping mapKeyPath:@"whackwho_id" toAttribute:@"whackwho_id"];
    [friendInfoMapping mapKeyPath:@"media_key" toAttribute:@"user_id"];
    [friendInfoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [friendInfoMapping mapKeyPath:@"isPlayer" toAttribute:@"isPlayer"];
    [friendInfoMapping mapKeyPath:@"head_id" toAttribute:@"head_id"];
    [friendInfoMapping mapKeyPath:@"gender" toAttribute:@"gender"];
    [friendInfoMapping mapKeyPath:@"head" toRelationship:@"head" withMapping:headMapping];
    [friendInfoMapping mapKeyPath:@"currentEquip" toRelationship:@"currentEquip" withMapping:curEquipMapping];
    [[RKObjectManager sharedManager].mappingProvider setMapping:friendInfoMapping forKeyPath:@"friend"];
    
    //friend array mapping:
    RKObjectMapping *friendArrayMapping = [RKObjectMapping mappingForClass:[FriendArray class]];
    [friendArrayMapping mapKeyPath:@"friends" toRelationship:@"friends" withMapping:friendInfoMapping];
    [[RKObjectManager sharedManager].mappingProvider setMapping:friendArrayMapping forKeyPath:@"friendsInApp"];
    
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[friendArrayMapping inverseMapping] forClass:[FriendArray class]];
    [[RKObjectManager sharedManager].router routeClass:[FriendArray class] toResourcePath:@"/friends/inapp"];
    [[RKObjectManager sharedManager].router routeClass:[FriendArray class] toResourcePath:@"/friends/inapp" forMethod:RKRequestMethodPUT];
    /*
    [[RKObjectManager sharedManager].router routeClass:[FriendArray class] toResourcePath:@"/getFriendUsingApp" forMethod:RKRequestMethodPOST];
    */
    
    //user mapping:
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
    [userInfoMapping mapKeyPath:@"currentEquip" toRelationship:@"currentEquip" withMapping:curEquipMapping];
    [userInfoMapping mapKeyPath:@"storageInv" toRelationship:@"storageInv" withMapping:storageInvMapping];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:userInfoMapping forKeyPath:@"user"];
    //[RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[User class]];
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/user/:mediaTypeId/:mediaKey"];
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/user/status/save" forMethod:RKRequestMethodPUT];
}




@end
