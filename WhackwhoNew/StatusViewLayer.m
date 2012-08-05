//
//  StatusViewLayer.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusViewLayer.h"
#import "HelloWorldLayer.h"
#import "UserInfo.h"

@implementation StatusViewLayer

+(id) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	StatusViewLayer *layer = [[StatusViewLayer alloc] init];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if ((self = [super init])) {
        
        glClearColor(255, 255, 255, 255);
        
        self.isTouchEnabled = YES;
        
        CGSize s = CGSizeMake(190, 250); //this is the size of the screen
        
        UIImage *face = [[UserInfo sharedInstance] exportImage];
        
        CCSprite *head;// = [CCSprite spriteWithFile:standard_blue_head];
        
        if ([face CGImage] != nil) {
            head = [CCSprite spriteWithCGImage:[face CGImage] key:@"hahaha"]; //320 x 426
            head.scale = 0.4;
        } else {
            head = [CCSprite spriteWithFile:standard_blue_head];
            head.scale = 0.8;
        }
        
        head.anchorPoint = ccp(0.5,1);
        head.position = ccp(s.width/2, s.height-50);

        CCSprite *body = [CCSprite spriteWithFile:standard_blue_body];
        body.anchorPoint = ccp(0.5, 0.75);
        body.position = ccp(s.width/2, s.height/2);
        [self addChild:body];
    
        [self addChild:head];
        
        //animations
        CCMoveBy *moveHeadUp = [CCMoveBy actionWithDuration:2.5 position:ccp(0,10)];
        CCMoveBy *moveHeadDown = [CCMoveBy actionWithDuration:2.5 position:ccp(0,-10)];
        [head runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:moveHeadUp two:moveHeadDown]]];
    }
    return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[[CCDirector sharedDirector].view setFrame:CGRectMake(0, 0, 480, 320)];
    //[[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    
    /*UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CCLOG(@"x: %f", location.x);
    CCLOG(@"y: %f", location.y);*/
}

@end
