//
//  Items.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-09-18.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "Items.h"

@implementation Items

@synthesize headID, body, helmet, hammerArm, shieldArm;

-(id)init {
    self = [super init];
    if (self) {
        headID = nil;
        body = nil;
        helmet = nil;
        hammerArm = nil;
        shieldArm = nil;
    }
    return self;
}


@end
