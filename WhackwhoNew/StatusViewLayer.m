//
//  StatusViewLayer.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusViewLayer.h"
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
        
        //UIImage *face = [[UserInfo sharedInstance] exportImage];
        
        CCSprite *head = [CCSprite spriteWithFile:standard_blue_head];
        
      /*  if (face == nil) {
            head = [CCSprite spriteWithFile:standard_blue_head];
        } else {
            head = [CCSprite spriteWithCGImage:[[[UserInfo sharedInstance] exportImage]CGImage] key:@"hahaha"];
        }*/
        
        head.scale = 0.8;
        head.anchorPoint = ccp(0.5,1);
        head.position = ccp(s.width/2, s.height-50);

        CCSprite *body = [CCSprite spriteWithFile:standard_blue_body];
        body.anchorPoint = ccp(0.5, 0.75);
        body.position = ccp(head.contentSize.width/2, 5);
        [head addChild:body];
    
        [self addChild:head];
        
        //animations
        CCMoveBy *moveHeadUp = [CCMoveBy actionWithDuration:2.5 position:ccp(0,10)];
        CCMoveBy *moveHeadDown = [CCMoveBy actionWithDuration:2.5 position:ccp(0,-10)];
        [head runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:moveHeadUp two:moveHeadDown]]];
    }
    return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CCLOG(@"x: %f", location.x);
    CCLOG(@"y: %f", location.y);
}

@end
