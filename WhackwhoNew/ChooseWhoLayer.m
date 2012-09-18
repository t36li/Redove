//
//  ChooseWhoScene.m
//  MoleIt
//
//  Created by Bob Li on 12-06-25.
//  Copyright 2012 Waterloo. All rights reserved.
//

#import "ChooseWhoLayer.h"
#import "HelloWorldLayer.h"
#import "TBXML.h"
#import "StatusBarController.h"

@implementation ChooseWhoLayer

//@synthesize gameOverDelegate;
+(CCScene *) scene {
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
        
        //glClearColor(255, 255, 255, 255);
                
        //NSString *formatting = [NSString stringWithFormat:@"http://www.whackwho.com/userImages/%d.png", [[UserInfo sharedInstance] headId]];
        //UIImage *face_DB = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:formatting]]];
        
        CGSize s = CGSizeMake(190, 250); //this is the size of the screen
        
        //we will initialize all body part sprite here, then change the texture
        
        //init face with image from DB, if none exists, give it blank (use pause.png for now)
        face = [CCSprite spriteWithFile:PauseButton];
        face.scale = 0.4;
        face.anchorPoint = ccp(0.5,1);
        
        //init body
        body = [CCSprite spriteWithFile:standard_blue_body];
        body.anchorPoint = ccp(0.5, 0.75);
        body.position = ccp(s.width/2 - 10, s.height*0.4);
        [self addChild:body z:0];
        
        //init hammerHand
        hammerHand = [CCSprite spriteWithFile:PauseButton];
        hammerHand.anchorPoint = ccp(0, 0);
        hammerHand.scale = 0.9;
        hammerHand.position = ccp(s.width/2 + 20, s.height*0.4-10);
        [hammerHand setVisible:FALSE];
        [self addChild:hammerHand z:10];
        
        //init shieldHand
        shieldHand = [CCSprite spriteWithFile:PauseButton];
        shieldHand.anchorPoint = ccp(0.5, 0.5);
        //shieldHand.scale = 0.9;
        [shieldHand setVisible:FALSE];
        shieldHand.position = ccp(s.width/2 - 45, s.height*0.4 - 10);
        [self addChild:shieldHand z:10];
        
        
        //init helmet sprite, ADD face as child
        helmet = [CCSprite spriteWithFile:standard_blue_head];
        helmet.anchorPoint = ccp(0.5,1);
        helmet.position = ccp(s.width/2 - 10, s.height-20);
        helmet.scale = 0.8;
        [self addChild:helmet z:5];
        //ADD face as child
        face.position = ccp(helmet.boundingBox.size.width/2, helmet.boundingBox.size.height/2);
        [helmet addChild:face z:-10];
        
        //animations
        //CCMoveBy *moveHeadUp = [CCMoveBy actionWithDuration:2.5 position:ccp(0,10)];
        //CCMoveBy *moveHeadDown = [CCMoveBy actionWithDuration:2.5 position:ccp(0,-10)];
        //[helmet runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:moveHeadUp two:moveHeadDown]]];
        
    }
    return self;
}




/*-(void) mainMenu {
    [gameOverDelegate returnToMenu];
}

-(void) gotoFrame
{
    [robot playFrame:4 fromAnimation:@"moving"];
}

-(void) pause
{
    [robot pauseAnimation];
}

-(void) resume
{
    [robot resumeAnimation];
}

-(void) doPlay:(CCMenuItemLabel *)item
{
    NSArray *arr = [[robot animationEventsTable] allKeys];
    
    NSString *animationStr = [arr objectAtIndex:item.tag];
    
    // to determine if the animation should loop we check if it ends in "ing"
    BOOL doesLoop = [animationStr hasSuffix:@"ing"];    
    
    [robot playAnimation:[arr objectAtIndex:item.tag] loop:doesLoop wait:NO];
}


-(void) nextScene: (id) sender {
    CCMenuItem *itm = (CCMenuItem *) sender;
    
    int index = itm.tag;
    
    //if already selected, then cant select anymore
    
    NSMutableArray *finalFriendList = [[Game sharedGame] friendList];
    NSMutableArray *selectedHeads = [[Game sharedGame] selectedHeads];
    NSString *friend = [finalFriendList objectAtIndex:index];
    
    if (![selectedHeads containsObject:friend]) {
        CCLOG(@"index: %d", index);
        CCLOG([finalFriendList objectAtIndex:index]);
        [selectedHeads addObject:[finalFriendList objectAtIndex:index]];
        tempDifficulty -= 1;
        
        if (tempDifficulty == 0) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
        }
    } else {
        CCLOG(@"already selected!");
    }
}*/


@end
