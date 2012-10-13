//
//  Friend.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-16.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "Friend.h"
#import "Head.h"
#import "UserInfo.h"


@implementation Friend

@synthesize user_id, name, gender, isPlayer,whackwho_id,mediaType_id, head_id;
@synthesize currentEquip, head;

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

@end


@implementation FriendArray

@synthesize friends, strangers;

-(void)copyToUserInfo{
    NSMutableArray *Rfriends = [[NSMutableArray alloc] init];
    NSMutableArray *Rstrangers = [[NSMutableArray alloc] init];
    for (Friend *f in self.friends){
        f.currentEquip = [f.currentEquip currentEquipInFileNames];
        [Rfriends addObject:f];
    }
    for (Friend *s in self.strangers){
        s.currentEquip = [s.currentEquip currentEquipInFileNames];
        [Rstrangers addObject:s];
    }
    
    FriendArray *fa = [[FriendArray alloc]init];
    fa.friends = Rfriends;
    fa.strangers = Rstrangers;
    [[UserInfo sharedInstance] setFriendArray:fa];
}

-(void)getFromUserInfo{
    NSMutableArray *Rfriends = [[NSMutableArray alloc] init];
    NSMutableArray *Rstrangers = [[NSMutableArray alloc] init];
    
    for (Friend *f in [[[UserInfo sharedInstance] friendArray] friends]){
        f.currentEquip = [f.currentEquip currentEquipInIDs];
        [Rfriends addObject:f];
    }
    for (Friend *s in [[[UserInfo sharedInstance] friendArray] strangers]){
        s.currentEquip = [s.currentEquip currentEquipInIDs];
        [Rstrangers addObject:s];
    }
    self.friends = nil;
    self.strangers = nil;
    self.friends = Rfriends;
    self.strangers = Rstrangers;
}
@end