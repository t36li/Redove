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

//define tags
#define head_Label 1
#define body_Label 2
#define leftHand_Label 3
#define rightHand_Label 4
#define face_label 5

@implementation StatusViewLayer

+(id) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	StatusViewLayer *layer = [StatusViewLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer z:0 tag:2];
	
	// return the scene
	return scene;
}

-(id) init {
    if ((self = [super init])) {
        
        glClearColor(255, 255, 255, 255);
        
        self.isTouchEnabled = YES;
        
        UIImage *face_DB = [[UserInfo sharedInstance] exportImage];
        
        CGSize s = CGSizeMake(190, 250); //this is the size of the screen
        
        //we will initialize all body part sprite here, then change the texture
        
        //init face with image from DB, if none exists, give it blank (use pause.png for now)
        if ([face_DB CGImage] != nil) {
            NSLog(@"Accessibility string: %@", [face_DB accessibilityIdentifier]);
            face = [CCSprite spriteWithCGImage:[face_DB CGImage] key:[face_DB accessibilityIdentifier]]; //320 x 426
        } else {
            face = [CCSprite spriteWithFile:PauseButton];
            [face setVisible:FALSE];
        }
        face.scale = 0.4;
        face.anchorPoint = ccp(0.5,1);
        
        //init helmet sprite, ADD face as child
        helmet = [CCSprite spriteWithFile:standard_blue_head];
        helmet.anchorPoint = ccp(0.5,1);
        helmet.position = ccp(s.width/2 - 10, s.height-20);
        helmet.scale = 0.8;
        [self addChild:helmet z:5 tag:head_Label];
        //ADD face as child
        face.position = ccp(helmet.boundingBox.size.width/2, helmet.boundingBox.size.height);
        [helmet addChild:face z:0 tag:face_label];

        //init body
        body = [CCSprite spriteWithFile:standard_blue_body];
        body.anchorPoint = ccp(0.5, 0.75);
        body.position = ccp(s.width/2 - 10, s.height*0.4);
        [self addChild:body z:0 tag:body_Label];
        
        //init left_hand
        left_hand = [CCSprite spriteWithFile:PauseButton];
        left_hand.anchorPoint = ccp(0, 0);
        left_hand.scale = 0.9;
        left_hand.position = ccp(s.width/2 + 20, s.height*0.4-10);
        [left_hand setVisible:FALSE];
        [self addChild:left_hand z:10 tag:leftHand_Label];
        
        //init right_hand
        right_hand = [CCSprite spriteWithFile:PauseButton];
        right_hand.anchorPoint = ccp(0.5, 0.5);
        //right_hand.scale = 0.9;
        [right_hand setVisible:FALSE];
        right_hand.position = ccp(s.width/2 - 45, s.height*0.4 - 10);
        [self addChild:right_hand z:10 tag:rightHand_Label];
        
        //animations
        CCMoveBy *moveHeadUp = [CCMoveBy actionWithDuration:2.5 position:ccp(0,10)];
        CCMoveBy *moveHeadDown = [CCMoveBy actionWithDuration:2.5 position:ccp(0,-10)];
        [helmet runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:moveHeadUp two:moveHeadDown]]];
    }
    return self;
}

-(void)updateCharacterWithImage: (UIImage *)img bodyPart: (int) pos {
    
    CCTexture2D *newTex = nil;
    
    if ([img CGImage] != nil) {
        newTex = [[CCTextureCache sharedTextureCache] addCGImage:[img CGImage] forKey:[img accessibilityLabel]];
    }
    
    switch (pos) {
        case head_Label:
            if (newTex == nil) 
                helmet.texture = [[CCTextureCache sharedTextureCache] addImage:standard_blue_head];
            else 
                helmet.texture = newTex;
            break;
        case body_Label:
            if (newTex == nil)
                body.texture = [[CCTextureCache sharedTextureCache] addImage:standard_blue_body];
            else
                body.texture = newTex;
            break;
        case leftHand_Label:
            if (newTex == nil) {
                [left_hand setVisible:FALSE];
            } else {
                left_hand.texture = newTex;
                [left_hand setVisible:TRUE];
            }
            break;
        case rightHand_Label:
            if (newTex == nil) {
                [right_hand setVisible:FALSE];
            } else {
                right_hand.texture = newTex;
                [right_hand setVisible:TRUE];
            }
            break;
        default:
            NSLog(@"invalid body part! Not recognized!");
            break;
    }
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end