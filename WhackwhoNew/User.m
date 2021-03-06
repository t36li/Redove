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
@synthesize mediaTypeId,whackWhoId,headId,mediaKey,leftEyePosition,rightEyePosition,mouthPosition,faceRect,registeredDate, userImgURL, currentEquip, storageInv,popularity;
@synthesize nosePosition,leftEarPosition,rightEarPosition;

-(void)copyToUserInfo{
    UserInfo *usrInfo = [UserInfo sharedInstance];
    //[usrInfo setCurrentLogInType: mediaTypeId];
    //[usrInfo setUserId:mediaKey];
    [usrInfo setWhackWhoId:whackWhoId];
    [usrInfo setHeadId:headId];
    [usrInfo setLeftEyePosition:CGPointFromString(leftEyePosition)];
    [usrInfo setRightEyePosition:CGPointFromString(rightEyePosition)];
    [usrInfo setMouthPosition:CGPointFromString(mouthPosition)];
    [usrInfo setNosePosition:CGPointFromString(nosePosition)];
    [usrInfo setRightEarPosition:CGPointFromString(rightEarPosition)];
    [usrInfo setLeftEarPosition:CGPointFromString(leftEarPosition)];
    [usrInfo setFaceRect:CGRectFromString(faceRect)];
    
    /*   Current Equip and Storage NEEDED IN THE FUTURE!!! NO DELETE!
     
    [usrInfo setCurrentEquip:[currentEquip currentEquipInFileNames]];
    [usrInfo setStorageInv:[storageInv setStorageArrayInFileNames]];
     
     */
    [usrInfo setPopularity:popularity];
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
    popularity = usrInfo.popularity;
    leftEyePosition = NSStringFromCGPoint(usrInfo.leftEyePosition);
    rightEyePosition = NSStringFromCGPoint(usrInfo.rightEyePosition);
    mouthPosition = NSStringFromCGPoint(usrInfo.mouthPosition);
    nosePosition = NSStringFromCGPoint(usrInfo.nosePosition);
    leftEarPosition = NSStringFromCGPoint(usrInfo.leftEarPosition);
    rightEarPosition = NSStringFromCGPoint(usrInfo.rightEarPosition);
    faceRect = NSStringFromCGRect(usrInfo.faceRect);
    
    /*     Current Equip and Storage NEEDED IN THE FUTURE!!! NO DELETE!
     
    currentEquip = [usrInfo.currentEquip currentEquipInIDs];
    storageInv = [usrInfo.storageInv setStorageStringInIDs];
     */
    
    userImgURL = usrInfo->usrImgURL;
    
}

+(void)objectMappingLoader{
    /*    Current Equip and Storage NEEDED IN THE FUTURE!!! NO DELETE!
     
    //currentEquip mapping:
    RKObjectMapping *curEquipMapping = [RKObjectMapping mappingForClass:[CurrentEquip class]];
    [curEquipMapping mapKeyPath:@"helmet" toAttribute:@"helmet"];
    [curEquipMapping mapKeyPath:@"body" toAttribute:@"body"];
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
    */
    
    //head Mapping:
    RKObjectMapping *headMapping = [RKObjectMapping mappingForClass:[Head class]];
    [headMapping mapKeyPath:@"head_id" toAttribute:@"headId"];
    [headMapping mapKeyPath:@"leftEyePosition" toAttribute:@"leftEyePosition"];
    [headMapping mapKeyPath:@"rightEyePosition" toAttribute:@"rightEyePosition"];
    [headMapping mapKeyPath:@"mouthPosition" toAttribute:@"mouthPosition"];
    [headMapping mapKeyPath:@"faceRect" toAttribute:@"faceRect"];
    [headMapping mapKeyPath:@"nosePosition" toAttribute:@"nosePosition"];
    [headMapping mapKeyPath:@"leftEarPosition" toAttribute:@"leftEarPosition"];
    [headMapping mapKeyPath:@"rightEarPosition" toAttribute:@"rightEarPosition"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:headMapping forKeyPath:@"head"];
    
    //friend mapping:
    RKObjectMapping *friendInfoMapping = [RKObjectMapping mappingForClass:[Friend class]];
    [friendInfoMapping mapKeyPath:@"mediatype_id" toAttribute:@"mediaType_id"];
    [friendInfoMapping mapKeyPath:@"whackwho_id" toAttribute:@"whackwho_id"];
    [friendInfoMapping mapKeyPath:@"media_key" toAttribute:@"user_id"];
    [friendInfoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [friendInfoMapping mapKeyPath:@"isPlayer" toAttribute:@"isPlayer"];
    [friendInfoMapping mapKeyPath:@"head_id" toAttribute:@"head_id"];
    [friendInfoMapping mapKeyPath:@"gender" toAttribute:@"gender"];
    [friendInfoMapping mapKeyPath:@"hits" toAttribute:@"popularity"];
    [friendInfoMapping mapKeyPath:@"head" toRelationship:@"head" withMapping:headMapping];
    /*    Current Equip and Storage NEEDED IN THE FUTURE!!! NO DELETE!
     
    [friendInfoMapping mapKeyPath:@"currentEquip" toRelationship:@"currentEquip" withMapping:curEquipMapping];
     */
    [[RKObjectManager sharedManager].mappingProvider setMapping:friendInfoMapping forKeyPath:@"friend"];
    
    //friend array mapping:
    RKObjectMapping *friendArrayMapping = [RKObjectMapping mappingForClass:[FriendArray class]];
    [friendArrayMapping mapKeyPath:@"friends" toRelationship:@"friends" withMapping:friendInfoMapping];
    [friendArrayMapping mapKeyPath:@"strangers" toRelationship:@"strangers" withMapping:friendInfoMapping];
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
    [userInfoMapping mapKeyPath:@"nosePosition" toAttribute:@"nosePosition"];
    [userInfoMapping mapKeyPath:@"leftEarPosition" toAttribute:@"leftEarPosition"];
    [userInfoMapping mapKeyPath:@"rightEarPosition" toAttribute:@"rightEarPosition"];
    [userInfoMapping mapKeyPath:@"faceRect" toAttribute:@"faceRect"];
    [userInfoMapping mapKeyPath:@"userImgURL" toAttribute:@"userImgURL"];
    [userInfoMapping mapKeyPath:@"hits" toAttribute:@"popularity"];
    /*   Current Equip and Storage NEEDED IN THE FUTURE!!! NO DELETE!
     
    [userInfoMapping mapKeyPath:@"currentEquip" toRelationship:@"currentEquip" withMapping:curEquipMapping];
    [userInfoMapping mapKeyPath:@"storageInv" toRelationship:@"storageInv" withMapping:storageInvMapping];
     */    
    [[RKObjectManager sharedManager].mappingProvider setMapping:userInfoMapping forKeyPath:@"user"];
    //[RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userInfoMapping inverseMapping] forClass:[User class]];
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/user/:mediaTypeId/:mediaKey"];
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/user/status/save" forMethod:RKRequestMethodPUT];
}




@end
