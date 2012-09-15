//
//  Friend.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-16.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize user_id, name, gender, isPlayer,whackwho_id,head_id;

-(id)init {
    self = [super init];
    if (self) {
        isPlayer = NO;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    Friend *copy = [super copy];
    
    copy->user_id = nil;
    copy->name = nil;
    copy->gender = nil;
    copy->whackwho_id = nil;
    copy->head_id = nil;
    copy.user_id = [NSString stringWithString:self.user_id];
    copy.name = [NSString stringWithString:self.name];
    copy.gender = [NSString stringWithString:self.gender];
    copy.whackwho_id = [NSString stringWithString:self.whackwho_id];
    copy.user_id = [NSString stringWithString:self.user_id];
    
    return copy;
}

+(void)objectMappingLoader{
    RKObjectMapping *friendInfoMapping = [RKObjectMapping mappingForClass:[Friend class]];
    [friendInfoMapping mapKeyPath:@"whackwho_id" toAttribute:@"whackwho_id"];
    [friendInfoMapping mapKeyPath:@"media_key" toAttribute:@"user_id"];
    [friendInfoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [friendInfoMapping mapKeyPath:@"isPlayer" toAttribute:@"isPlayer"];
    [friendInfoMapping mapKeyPath:@"head_id" toAttribute:@"head_id"];
    [friendInfoMapping mapKeyPath:@"gender" toAttribute:@"gender"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:friendInfoMapping forKeyPath:@"myFriends"];
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[friendInfoMapping inverseMapping] forClass:[Friend class]];
}

/*
+(NSDictionary *)elementToPropertyMappings{
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"whackwho_id",@"whackwho_id",
            @"media_key",@"user_id",
            @"name",@"name",
            @"head_id",@"head_id",
            @"gender",@"gender",
            @"isPlayer",@"isPlayer"
            @"friendArray.@distinctUnionOfObjects.", nil]
}
*/
@end


@implementation FriendArray

@synthesize friends = _friends;

+(void)objectMappingLoader{
    RKObjectMapping *friendInfoMapping = [RKObjectMapping mappingForClass:[Friend class]];
    [friendInfoMapping mapKeyPath:@"whackwho_id" toAttribute:@"whackwho_id"];
    [friendInfoMapping mapKeyPath:@"media_key" toAttribute:@"user_id"];
    [friendInfoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [friendInfoMapping mapKeyPath:@"isPlayer" toAttribute:@"isPlayer"];
    [friendInfoMapping mapKeyPath:@"head_id" toAttribute:@"head_id"];
    [friendInfoMapping mapKeyPath:@"gender" toAttribute:@"gender"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:friendInfoMapping forKeyPath:@"friend"];
    
    RKObjectMapping *friendArrayMapping = [RKObjectMapping mappingForClass:[FriendArray class]];
    [friendArrayMapping mapKeyPath:@"friends" toRelationship:@"friends" withMapping:friendInfoMapping];
    [[RKObjectManager sharedManager].mappingProvider setMapping:friendArrayMapping forKeyPath:@"myFriends"];
    
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[friendArrayMapping inverseMapping] forClass:[FriendArray class]];
    [[RKObjectManager sharedManager].router routeClass:[FriendArray class] toResourcePath:@"/getFriendUsingApp"];
    [[RKObjectManager sharedManager].router routeClass:[FriendArray class] toResourcePath:@"/getFriendUsingApp" forMethod:RKRequestMethodPOST];
}


@end