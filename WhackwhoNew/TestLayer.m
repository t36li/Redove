//
//  TestLayer.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "TestLayer.h"

@implementation TestLayer

+(id) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	TestLayer *layer = [[TestLayer alloc] init];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if( (self=[super init]) ) {
        
        CGSize s = CGSizeMake(190, 250);
        
        CCSprite *test = [CCSprite spriteWithFile:@"Default.png"];
        test.scale = 0.5;
        test.anchorPoint = ccp(0.5,0.5);
        test.position = ccp(s.width/2, s.height/2);
        [self addChild:test];
    }
    return self;
}

@end
