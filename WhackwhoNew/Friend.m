//
//  Friend.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-16.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize user_id, name, gender, isPlayer;

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
    copy.user_id = [NSString stringWithString:self.user_id];
    copy.name = [NSString stringWithString:self.name];
    copy.gender = [NSString stringWithString:self.gender];
    
    return copy;
}

@end
