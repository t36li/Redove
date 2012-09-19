//
//  ChooseWhoLayer.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-09-18.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "ChooseWhoLayer.h"
#import "UserInfo.h" //testing

@implementation ChooseWhoLayer

+(id) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	ChooseWhoLayer *layer = [ChooseWhoLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer z:0];
	
	// return the scene
	return scene;
}

-(id) init {
    if ((self = [super init])) {
        //CCSprite *test = [CCSprite spriteWithFile:@"hammer.png"];
        //[self addChild:test];
        //test.position = ccp(100,100);
    }
    return self;
}


@end
