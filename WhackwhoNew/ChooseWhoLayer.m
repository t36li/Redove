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

@synthesize gameOverDelegate;
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
+(CCScene *) sceneWithDelegate:(id<GameOverDelegate>)delegate
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseWhoLayer *layer = [ChooseWhoLayer node];
    layer.gameOverDelegate = delegate;
    
	// add layer as a child to scene
	[scene addChild: layer z:0];
    
	// return the scene
	return scene;
}

-(id) init {
    
    if ((self = [super init])) {
        
        baby = [[CCRobot alloc] init];
        baby.position = ccp(100,100);
        [self addChild:baby];
        
        [baby playAnimation:@"start" loop:YES wait:NO];
        /*      //tempDifficulty = [[Game sharedGame] difficulty];
        CGSize s = [[CCDirector sharedDirector] winSize];
        //popups = 2*tempDifficulty + 1;
        
        //testing
        tempDifficulty = 1;
        popups = 3;
        self.isTouchEnabled = YES;
        
        //finalFriendList = [[NSMutableArray alloc] init];
        //selectedHeads = [[NSMutableArray alloc] init];
        NSMutableArray *finalFriendList = [[Game sharedGame] friendList];
        NSMutableArray *selectedHeads = [[Game sharedGame] selectedHeads];
        [finalFriendList removeAllObjects];
        [selectedHeads removeAllObjects];
        
        //set background color to white
        CCSprite *bg1 = [CCSprite spriteWithFile:FriendList_bg];
        bg1.position = ccp(s.width/2, s.height/2);
        [self addChild:bg1];
        
        //set an instruction label
        CCLabelTTF *instruction = [CCLabelTTF labelWithString:@"Choose the Evil MOLE!" fontName:@"chalkduster" fontSize:40];
        instruction.color = ccc3(0, 0, 0);
        instruction.scale = 0.1;
        instruction.position = ccp(s.width/2, s.height - 50);
        [instruction runAction:[CCScaleTo actionWithDuration:0.5 scale:0.8]];
        [self addChild:instruction z:100];
        
        //set list of all facebook friends to select
        NSArray *friendList = [NSArray arrayWithObjects:@"baby.png", @"olaf.png", @"vlad.png", @"mice.png", @"pinky.png", @"monk.png", @"blue.png",nil];
        
        int randFriend;
        int listLength = [friendList count];
        
        //num of paddings = numofpopups + 1
        int hpad = (s.width - popups * 100) / (popups + 1); //(480 - 300)/4
        int vpad = 100;
        if ((s.width - popups*100) <= 0) {
            hpad = 25;
        }
        
        int i = 0;
        int index = 0;
        do {
            randFriend = arc4random() % listLength;
            NSString *friend = [friendList objectAtIndex:randFriend];
            // check to avoid duplicating heads
            if (![finalFriendList containsObject:friend]) {
                
                CCMenuItemImage *who = [CCMenuItemImage itemWithNormalImage:friend selectedImage:friend target:self selector:@selector(nextScene:)];
                who.tag = index;
                
                CCMenu *menu = [CCMenu menuWithItems:who, nil];
                if ((hpad*(i+1) + i*100) > 400) {
                    i = 0;
                    vpad = 200;
                }
                menu.anchorPoint = ccp(0,0);
                menu.position = ccp(hpad*(i+1) + i*100,vpad);
                //CCLOG(@"position: (%i, %i)", (int)menu.position.x, (int)menu.position.y);
                [self addChild:menu];
                
                i++;
                index++;
                popups -= 1;
                [finalFriendList addObject:friend];
            }
        } while (popups > 0);*/
        
        //glClearColor(255, 255, 255, 255);
        
        /*//crude animations testing
        CCSprite *body = [CCSprite spriteWithFile:@"pen body.png"];
        CCSprite *head = [CCSprite spriteWithFile:@"pen head.png"];
        CCSprite *left_arm = [CCSprite spriteWithFile:@"left arm.png"];
        CCSprite *right_arm = [CCSprite spriteWithFile:@"right arm.png"];
        CCSprite *zach = [CCSprite spriteWithFile:@"zach_resized.png"];
        
        //position body in center
        body.position = ccp(80, 100);
        head.position = ccp(46, 33);
        left_arm.position = ccp(46, 33);
        right_arm.position = ccp(46, 33);
        zach.position = ccp(head.contentSize.width/2, head.contentSize.height/2);
        
        //add child
        [self addChild:body z:0];
        [body addChild:head z:10];
        [body addChild:left_arm z:15];
        [body addChild:right_arm z:20];
        [head addChild:zach];
        
        body.anchorPoint = ccp(0.471, 0.245);
        head.anchorPoint = ccp(0.467, 0.286);
        left_arm.anchorPoint = ccp(0.344, 0.256);
        right_arm.anchorPoint = ccp(0.595, 0.256);
        
        CCRotateBy *upSwing = [CCRotateBy actionWithDuration:1.5 angle:45];
        CCRotateBy *downSwing = [CCRotateBy actionWithDuration:1.5 angle:-45];
        CCMoveBy *moveUp = [CCMoveBy actionWithDuration:1.5 position:ccp(0,10)];
        CCMoveBy *moveDown = [CCMoveBy actionWithDuration:1.5 position:ccp(0,-10)];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actionOne:upSwing two:downSwing]];
        CCRepeatForever *repeat2 = [CCRepeatForever actionWithAction:[CCSequence actionOne:moveDown two:moveUp]];
        //CCRepeatForever *repeat3 = [CCRepeatForever actionWithAction:[CCSequence actionOne:downSwing two:upSwing]];
        
        [head runAction:repeat2];
        [left_arm runAction:repeat];*/
        
        //sample robot animations
        /* robot = [[CCRobot alloc] init];
        [robot setPosition:ccp(250, 50)];
        [self addChild:robot];
        
        NSArray *arr =  [[robot animationEventsTable] allKeys];
        CCMenu *starMenu = [CCMenu menuWithItems: nil];        
        [starMenu setPosition:ccp(10, 200)];
        
        CCMenuItemLabel *gotoBut = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"FRAME 5 ANIM MOVING" fontName:@"Verdana" fontSize:12] target:self selector:@selector(gotoFrame)];
        [gotoBut setAnchorPoint:ccp(0, 0.5f)];
        [starMenu addChild:gotoBut];
        
        CCMenuItemLabel *pauseBut = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"PAUSE" fontName:@"Verdana" fontSize:12] target:self selector:@selector(pause)];
        [pauseBut setAnchorPoint:ccp(0, 0.5f)];
        [starMenu addChild:pauseBut];
        
        
        
        CCMenuItemLabel *resumeBut = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"RESUME" fontName:@"Verdana" fontSize:12] target:self selector:@selector(resume)];
        [resumeBut setAnchorPoint:ccp(0, 0.5f)];
        [starMenu addChild:resumeBut];
        
        
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CCMenuItemLabel *labelBut = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:obj fontName:@"Verdana" fontSize:12] target:self selector:@selector(doPlay:)];
            labelBut.tag = idx;
            [labelBut setAnchorPoint:ccp(0, 0.5f)];
            [starMenu addChild:labelBut];
        }];
        
        CCMenuItemLabel *mainMenuBut = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Main Menu" fontName:@"Verdana" fontSize:12] target:self selector:@selector(mainMenu)];
        [mainMenuBut setAnchorPoint:ccp(0, 0.5f)];
        [starMenu addChild:mainMenuBut];
        
        [starMenu alignItemsVertically];
        [self addChild:starMenu];*/
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
