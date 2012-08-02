//
//  HelloWorldLayer.m
//  MoleIt
//
//  Created by Bob Li on 12-06-23.
//  Copyright Waterloo 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "CocosViewController.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize gameOverDelegate;
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    // 'hud' is the restart object
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud z:10];
    
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [[HelloWorldLayer alloc] initWithHUD:hud];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(CCScene *) sceneWithDelegate:(id<GameOverDelegate>)delegate
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    // 'hud' is the restart object
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud z:10];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [[HelloWorldLayer alloc] initWithHUD:hud];
    layer.gameOverDelegate = delegate;
    
	// add layer as a child to scene
	[scene addChild: layer z:0];
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithHUD:(HUDLayer *)hud
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        //init retard variables
        consecHits = 0;
        totalTime = 25;
        myTime = (int)totalTime;
        baseScore = 0;
        speed = 1.5;
        _hud = hud;
        self.isTouchEnabled = YES;
        gameOver = FALSE;
        gamePaused = FALSE;
        CGSize s = [[CCDirector sharedDirector] winSize];
        coins = [[NSMutableArray alloc] init];
        
        //CCSprite *test = [CCSprite spriteWithFile:@"hills_finalView.png"];
        //test.scale = 0.5;
        //test.anchorPoint = ccp(0.5,0.5);
        //test.position = ccp(s.width/2, s.height/2);
        //[self addChild:test];
        
        //testing: hard-code 5 points
        botLeft = [[NSArray alloc] initWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake(16, 146)],
                   [NSValue valueWithCGPoint:CGPointMake(63, 135.5)],
                   [NSValue valueWithCGPoint:CGPointMake(105.5, 111)],
                   [NSValue valueWithCGPoint:CGPointMake(135, 78.5)],
                   [NSValue valueWithCGPoint:CGPointMake(151.5, 44)],
                   nil];
        botRight = [[NSArray alloc] initWithObjects:
                    [NSValue valueWithCGPoint:CGPointMake(390/2, 320-479/2)],
                    [NSValue valueWithCGPoint:CGPointMake(504/2, 320-452/2)],
                    [NSValue valueWithCGPoint:CGPointMake(634/2, 320-434/2)],
                    [NSValue valueWithCGPoint:CGPointMake(763/2, 320-455/2)],
                    [NSValue valueWithCGPoint:CGPointMake(872/2, 320-491/2)],
                    nil];
        midLeft = [[NSArray alloc] initWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake(179/2, 320-326/2)],
                   [NSValue valueWithCGPoint:CGPointMake(321/2, 320-296/2)],
                   [NSValue valueWithCGPoint:CGPointMake(439/2, 320-345/2)],
                   nil];
        midRight = [[NSArray alloc] initWithObjects:
                    [NSValue valueWithCGPoint:CGPointMake(546/2, 320-334/2)],
                    //[NSValue valueWithCGPoint:CGPointMake(648/2, 320-274/2)],
                    [NSValue valueWithCGPoint:CGPointMake(772/2, 320-253/2)],
                    [NSValue valueWithCGPoint:CGPointMake(905/2, 320-273/2)],
                    nil];
        topMid = [[NSArray alloc] initWithObjects:
                  //[NSValue valueWithCGPoint:CGPointMake(316/2, 320-262/2)],
                  //[NSValue valueWithCGPoint:CGPointMake(357/2, 320-229/2)],
                  [NSValue valueWithCGPoint:CGPointMake(411/2, 320-195/2)],
                  [NSValue valueWithCGPoint:CGPointMake(466/2, 320-174/2)],
                  [NSValue valueWithCGPoint:CGPointMake(553/2, 320-164/2)],
                  [NSValue valueWithCGPoint:CGPointMake(609/2, 320-167/2)],
                  [NSValue valueWithCGPoint:CGPointMake(672/2, 320-184/2)],
                  //[NSValue valueWithCGPoint:CGPointMake(720/2, 320-202/2)],
                  //[NSValue valueWithCGPoint:CGPointMake(761/2, 320-224/2)],
                  nil];
        topLeft = [[NSArray alloc] initWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake(30/2, 320-153/2)],
                   [NSValue valueWithCGPoint:CGPointMake(85/2, 320-151/2)],
                   [NSValue valueWithCGPoint:CGPointMake(133/2, 320-166/2)],
                   //[NSValue valueWithCGPoint:CGPointMake(188/2, 320-189/2)],
                   //[NSValue valueWithCGPoint:CGPointMake(247/2, 320-233/2)],
                   nil];
        topRight = [[NSArray alloc] initWithObjects:
                   //[NSValue valueWithCGPoint:CGPointMake(804/2, 320-213/2)],
                   [NSValue valueWithCGPoint:CGPointMake(843/2, 320-196/2)],
                   [NSValue valueWithCGPoint:CGPointMake(897/2, 320-176/2)],
                   //[NSValue valueWithCGPoint:CGPointMake(938/2, 320-169/2)],
                   nil];
        
        //add background this is for retina display
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
        //set background color to white
        glClearColor(255, 255, 255, 255);
        
        CCSprite *bg1 = [CCSprite spriteWithFile:hills_l1];
        CCSprite *bg2 = [CCSprite spriteWithFile:hills_l2];
        CCSprite *bg3 = [CCSprite spriteWithFile:hills_l3];
        CCSprite *bg4 = [CCSprite spriteWithFile:hills_l4];
        CCSprite *bg5 = [CCSprite spriteWithFile:hills_l5];
        CCSprite *bg6 = [CCSprite spriteWithFile:hills_l6];
        CCSprite *bg7 = [CCSprite spriteWithFile:hills_l7];
        CCSprite *bg8 = [CCSprite spriteWithFile:hills_l8];
        CCSprite *bg9 = [CCSprite spriteWithFile:hills_l9];
        
        bg9.position = ccp(s.width/2, s.height/2);
        bg8.position = ccp(s.width/2, s.height/2);
        bg7.position = ccp(s.width/2, s.height/2);
        bg6.position = ccp(s.width/2, s.height/2);
        bg5.position = ccp(s.width/2, s.height/2);
        bg4.position = ccp(s.width/2, s.height/2);
        bg3.position = ccp(s.width/2, s.height/2);
        bg2.position = ccp(s.width/2, s.height/2);
        bg1.position = ccp(s.width/2, s.height/2);
        
        [self addChild:bg1 z:-30];
        [self addChild:bg2 z:-40];
        [self addChild:bg3 z:-50];
        [self addChild:bg4 z:-60];
        [self addChild:bg5 z:-70];
        [self addChild:bg6 z:-80];
        [self addChild:bg7 z:-90];
        [self addChild:bg8 z:-100];
        [self addChild:bg9 z:-110];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

       
        //add particle emitter
        //emitter = [[CCParticleExplosion alloc] init];
        //emitter.visible = FALSE;
        //[self addChild:emitter];
        
        //add timer label
        timeLabel = [CCLabelTTF labelWithString:@"0:0" fontName:@"chalkduster" fontSize:40];
        timeLabel.color = ccc3(255, 249, 0);
        timeLabel.anchorPoint = ccp(0,1);
        timeLabel.position = ccp(15, s.height);
        [self addChild:timeLabel z:10];
        
        //add "hits" label
        hitsLabel = [CCLabelTTF labelWithString:@"  HIT STREAK" fontName:@"chalkduster" fontSize:20];
        hitsLabel.color = ccc3(255, 249, 0);
        hitsLabel.anchorPoint = ccp(0.5,1);
        hitsLabel.position = ccp(s.width/2, s.height - 10);
        //hitsLabel.scale = 0.1;
        [self addChild:hitsLabel z:10];
        
        //add "combo" label
       // comboLabel = [CCLabelTTF labelWithString:@"  HIT COMBO" fontName:@"chalkduster" fontSize:20];
       // comboLabel.color = ccc3(255, 249, 0);
       // comboLabel.anchorPoint = ccp(0.5,1);
       // comboLabel.position = ccp(s.width/2, s.height - 30);
       // [self addChild:comboLabel z:10];
        
        //add "pause" label
        CCMenuItemImage *pause = [CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseGame)];
        CCMenu *pauseMenu = [CCMenu menuWithItems:pause, nil];
        pauseMenu.anchorPoint = ccp(0,0);
        pauseMenu.position = ccp(20,20);
        [self addChild:pauseMenu z:10];
        
        //add "life" sprites
        lives = 3;
        hearts = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < lives; i++) {
            CCSprite *life = [CCSprite spriteWithFile:@"heart.png"];
            life.anchorPoint = ccp(1,1);
            life.position = ccp(s.width - 5 - i*25, s.height - 5);
            [hearts addObject:life];
            [self addChild:life z:10];
        }
        
        /*//add "rainbows"
        rainbows = [[NSMutableArray alloc] init];
        CCSprite *rainbow = [CCSprite spriteWithFile:@"rainbow4.png"];
        rainbow.position = ccp(156, 192);
        rainbow.visible = FALSE;
        [rainbows addObject:rainbow];
        CCSprite *rainbow2 = [CCSprite spriteWithTexture:[rainbow texture]];
        rainbow2.position = ccp(14, 247);
        rainbow2.scale = 0.5;
        rainbow2.visible = FALSE;
        [rainbows addObject:rainbow2];
        CCSprite *rainbow3 = [CCSprite spriteWithTexture:[rainbow texture]];
        rainbow3.position = ccp(443, 214);
        rainbow3.scale = 0.8;
        rainbow3.visible = FALSE;
        [rainbows addObject:rainbow3];
        CCSprite *rainbow4 = [CCSprite spriteWithTexture:[rainbow texture]];
        rainbow4.position = ccp(305, 220);
        rainbow4.scale = 0.3;
        rainbow4.visible = FALSE;
        [rainbows addObject:rainbow4];
        [self addChild:rainbow4 z:-95];
        [self addChild:rainbow3 z:-95];
        [self addChild:rainbow2 z:-95];
        [self addChild:rainbow z:-95];*/
        
        //add "Scoreboard and flowers"
        CCSprite *scoreboard = [CCSprite spriteWithFile:@"scoreboard.png"];
        scoreboard.anchorPoint = ccp(0.5, 0);
        scoreboard.position = ccp(s.width/2 + 10, -10);
        scoreboard.scale = 0.8;
        [self addChild:scoreboard z:-36];
        
        //add "score" label
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"chalkduster" fontSize:50];
        scoreLabel.color = ccc3(255, 200, 0);
        scoreLabel.position = ccp(scoreboard.contentSize.width/2, scoreboard.contentSize.height/2);
        [scoreboard addChild:scoreLabel z:10];
        
        //2 arrays containing the @"ids"        
        heads = [[NSMutableArray alloc] init];
       // NSArray *bigList = [[Game sharedGame] friendList];
       // NSArray *selectedHeads = [[Game sharedGame] selectedHeads];
        
        //set all positions to not taken (i.e. = 0)
        //for (int i = 0; i < 17; i++) {
        //    pos[i] = 0;
        //}
        
        //testing UserInfo image taken from camera
        UserInfo *usr = [UserInfo sharedInstance];
        UIImage *bigHead = usr.exportImage; //640 x 852 : 64 x 85.2
        
        // Old big head contentSize: 73.5 x 76.5
        //UIImage *bigHead = [UIImage imageNamed:@"peter head c.png"];

        //the number of total heads to include in the heads array should be relative to the difficulty level chosen previously... max will be 10 ATM...this should be a loop that fast-enumerates through all the chosen names array from the previous view
        //for testing purposes, set to 7
        
        //testing the upper and lower body piece-together
        UIImage *lowerBody = [UIImage imageNamed:@"peter body.png"];
        int index = 1;
        for (int i = 0; i < 7; i++) {
            //get the friend portrait image...once database kicks in, we will grab the big head
            //belonging to each user... then piece-wise this to the lower body part...
            Character *head = [Character spriteWithCGImage:[bigHead CGImage] key:[NSString stringWithFormat:@"head_frame%i", index]];
            [head setTappable:FALSE];
            //head.sideWaysMove = FALSE;
            //body: 43 x 100
            head.anchorPoint = ccp(0,0);
            head.scale = 0.2;
            head.isSelectedHit = TRUE;
            head.visible = FALSE;
            head.position = ccp(0,0);
            
            CCSprite *body = [CCSprite spriteWithCGImage:[lowerBody CGImage] key:[NSString stringWithFormat:@"body_frame%i", index]];
                        
            //if ([selectedHeads containsObject:friend]) {
            //    head.isSelectedHit = FALSE;
            //} else {
            //    head.isSelectedHit = TRUE;
            //}
            
            [head addChild:body];
            body.anchorPoint = ccp(0.5, 0.75); //90 x 31 -> 182 x 120
            body.position = ccp(160,20);
            body.scale = 1.4;
            //body_height_now = body.contentSize.height * body.scaleY;
            //body_bounding_width = body.boundingBox.size.width;
            //body_bounding_height = body.boundingBox.size.height;
            
            //body.anchorPoint = ccp(0.5, 0.05); //88 x 35
            //body.position = ccp(44, 45);

            [self addChild:head];
            [heads addObject:head];
            index++;
        }

        [self schedule:@selector(tryPopheads) interval:1.5];
        [self schedule:@selector(checkGameState) interval:0.1];
        [self schedule:@selector(timerUpdate:) interval:0.001];
        
        //set laughAnimations variables
        //laughAnim = [self laughAnimation];
        //laughAnim = [self animationFromPlist:@"laughAnim" delay:0.5];
        //[[CCAnimationCache sharedAnimationCache] addAnimation:laughAnim name:@"laughAnim"];
	}
    
	return self;
}

-(void) pauseGame {
    if (self.isTouchEnabled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paused" message:@"Press the button to..." delegate:self cancelButtonTitle:@"Resume" otherButtonTitles:@"Back Home", nil];
        [alert show];
        gamePaused = TRUE;
        [[CCDirector sharedDirector] pause];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        gamePaused = FALSE;
        [[CCDirector sharedDirector] resume];
    } else if (buttonIndex == 1) {
        gameOver = TRUE;
        [[CCDirector sharedDirector] resume];
        //CCScene *scene = [ChooseWhoLayer scene];
        [[Game sharedGame] resetGameState];
        [gameOverDelegate returnToMenu];
        //[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
    }
    
}

-(void) timerUpdate: (ccTime) deltT {
    if (gameOver) return;
    
    totalTime -= deltT;
    myTime = (int)totalTime;
    [timeLabel setString:[NSString stringWithFormat:@"%d:%02d", myTime/60, myTime%60]];
}

-(void) checkGameState{
    if (gameOver) return;
    
    //update "score"
    [scoreLabel setString:[NSString stringWithFormat:@"%d", baseScore]];
    
    //update "hits"
    if (consecHits <= 1) {
        hitsLabel.visible = FALSE;
    } else {
        hitsLabel.visible = TRUE;
    }
    
    /*update "hp"
     [hpBar1 setString:[NSString stringWithFormat:@"hp 1: %d", hp1]];
     [hpBar2 setString:[NSString stringWithFormat:@"hp 2: %d", hp2]];
     [hpBar3 setString:[NSString stringWithFormat:@"hp 3: %d", hp3]];
     
     switch (tempDifficulty) {
     case 1:
     if (hp1 <= 0) {
     [[Game sharedGame] setBaseScore:baseScore];
     [[Game sharedGame] setMultiplier:multiplier];
     [[Game sharedGame] setTimeBonus: (myTime%60)];
     tempDifficulty += 1;
     [[Game sharedGame] setDifficulty:tempDifficulty];
     [self unscheduleAllSelectors];
     [_hud showRestartMenu:YES];
     
     
     // CCLabelTTF *gameCompleteLabel = [CCLabelTTF labelWithString:@"Success!" fontName:@"Arial" fontSize:40];
     
     gameOver = TRUE;
     return;
     }
     break;
     case 2:
     if (hp1 <= 0 && hp2 <= 0) {
     tempDifficulty += 1;
     [[Game sharedGame] setDifficulty:tempDifficulty];
     [self unscheduleAllSelectors];
     [_hud showRestartMenu:YES];
     
     
     // CCLabelTTF *gameCompleteLabel = [CCLabelTTF labelWithString:@"Success!" fontName:@"Arial" fontSize:40];
     
     gameOver = TRUE;
     return;
     }
     break;
     case 3:
     if (hp1 <= 0 && hp2 <= 0 && hp3 <= 0) {
     tempDifficulty += 1;
     [[Game sharedGame] setDifficulty:tempDifficulty];
     [self unscheduleAllSelectors];
     [_hud showRestartMenu:YES];
     
     
     // CCLabelTTF *gameCompleteLabel = [CCLabelTTF labelWithString:@"Success!" fontName:@"Arial" fontSize:40];
     
     gameOver = TRUE;
     return;
     }
     break;
     }*/
    //check is game is over
    if (myTime <= 0 || lives <= 0) {
        [self unscheduleAllSelectors];
        self.isTouchEnabled = NO;
        [[Game sharedGame] setBaseScore:baseScore];
        //[[Game sharedGame] setConsecHits:consecHits];
        //CocosViewController *vc = [[CocosViewController alloc] init];

        [_hud showRestartMenu:YES :gameOverDelegate];
        
        gameOver = TRUE;
        return;
    }
}

-(void) tryPopheads{
    
    if (gameOver) return;
    
    //[self performSelector:@selector(checkGameState)];
    
    //should remove the head from the array if head.hp == 0?
    //changed to 50% chance to pop for testing purposes
    for (Character *head in heads) {
        if (head.numberOfRunningActions == 0) {
            if (arc4random() % 100 < 33) {
                //pop the selected heads
                if (head.isSelectedHit == TRUE) {
                    //numHitOccur++;
                    [self popHead:head];
                }
            } else {
                //pop the "bomb"
                if (head.isSelectedHit == FALSE) {
                    //numBombOccur++;
                    [self popHead:head];
                }
            }
        }
    }
}

-(void) popHead: (Character *) head {
    
    //float width_now = head.contentSize.width * head.scaleX;
    float height_now = head.contentSize.height * head.scaleY; //76.5
    //float height = head.contentSize.height; //255
    //CCLOG(@"%f", height_now);
    //CCLOG(@"%f", height);
    /* random location code
     occupied = FALSE;
     int maxX = s.width - 40 - 100;
     int maxY = s.height * 0.5;
     int randX = arc4random() % maxX+40;
     int randY = arc4random() % maxY+40;
     //int haveBomb = arc4random() % 12;
     
     head.anchorPoint = ccp(0,0);
     head.position = ccp(randX, randY);
     CGRect box1 = CGRectMake(head.position.x, head.position.y, [head boundingBox].size.width, [head boundingBox].size.height);
     
     
     for (Character *tok in heads) {
     if (![[tok imageName] isEqualToString:[head imageName]]) {
     CGRect box2 = CGRectMake(tok.position.x, tok.position.y, [tok boundingBox].size.width, [tok boundingBox].size.height);
     if (CGRectIntersectsRect(box1, box2)) {
     CCLOG(@"intersected!");
     occupied = TRUE;
     break;
     }
     }
     }
     
     if (!occupied) {
     if (haveBomb == 0) {
     CCSprite *bomb = [CCSprite spriteWithFile:@"bob_resized.png"];
     bomb.scale = 0.5;
     //bomb.anchorPoint = ccp(0.5, 0);
     [head addChild:bomb z:10];
     bomb.position = ccp(head.contentSize.width/2,head.contentSize.height);
     }
     //Appear animations and tasks
     head.didMiss = TRUE;
     CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:0];
     CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
     CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
     CCCallFuncN *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
     CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
     //CCAnimate *laugh = [CCAnimate actionWithAnimation:laughAnim];
     CCDelayTime *delay = [CCDelayTime actionWithDuration:0.1];
     
     //to fix "bug" put unsetTappble infront of fadeout
     [head runAction:[CCSequence actions:setTappable, fadeIn, delay, fadeOut, unsetTappable, delay, checkCombo, nil]];
     
     }*/
    //testing CGRectIntersection
    /*Character *tempHead1 = (Character *) [heads objectAtIndex:0];
    Character *tempHead2 = (Character *) [heads objectAtIndex:1];
    tempHead1.visible = TRUE;
    tempHead2.visible = TRUE;
    
    CGRect absrect1 = CGRectMake(tempHead1.position.x, tempHead1.position.y, [tempHead1 boundingBox].size.width, [tempHead1 boundingBox].size.height);
    CGRect absrect2 = CGRectMake(tempHead2.position.x, tempHead2.position.y, [tempHead2 boundingBox].size.width, [tempHead2 boundingBox].size.height);
    
    if (CGRectIntersectsRect(absrect1, absrect2)) {
        CCLOG(@"intersected!");
    }*/
    
    // algorithm: random the hill that it will pop up, then need to random the rotation... either left or right
    int randHill = arc4random() % 7;
    // Hill numberings:
    //  0: botLeft:-35: 5 possible
    //  1: botRight:-45: 5 possible
    //  2: midLeft:-55: 3 possible
    //  3: midRight:-65: 4 possible
    //  4: topMid:-75:  9 possible
    //  5: topLeft:-85: 5 possible
    //  6: topRight:-95: 4 possible

    NSArray *temp;    
    switch (randHill) {
        case 0:
            temp = botLeft;
            //adjust scale accordingly
            //head.scale *= 0.9;
            [head setZOrder:-35];
            break;
        case 1:
            temp = botRight;
            [head setZOrder:-45];
            break;
        case 2:
            temp = midLeft;
            [head setZOrder:-55];
            break;
        case 3:
            temp = midRight;
            [head setZOrder:-65];
            break;
        case 4:
            temp = topMid;
            [head setZOrder:-75];
            break;
        case 5  :
            temp = topLeft;
            [head setZOrder:-85];
            break;
        case 6:
            temp = topRight;
            [head setZOrder:-95];
            break;
    }
    
    int randTurn;
    int max = [temp count];
    int randPos = arc4random() % max;
    
    //  if the rand pos generated is the endpoint, then only 1 possible rotation turn
    if (randPos == 0) {
        randTurn = 1;
    } else if (randPos == (max - 1)) {
        randTurn = 0;
    } else {
        randTurn = arc4random() % 2;
    }
    
    if (randTurn == 0) {
        randTurn = -1;
    }
    
    CGPoint myPos = [[temp objectAtIndex:randPos] CGPointValue];
    CGPoint myPosTwo = [[temp objectAtIndex:(randPos + randTurn)] CGPointValue];
    
    head.position = myPos;
    //check if collides with all other heads ... problem is dunno which index this head is in...
    //int index = (int) [heads indexOfObject:head];
    CGRect absrect1, absrect2;
    absrect1 = CGRectMake(head.position.x, head.position.y, [head boundingBox].size.width, [head boundingBox].size.height);
    for (Character *head2 in heads) {
        //if this is itself, then skip it
        if ([head2 isEqual:head]) {
            continue;
        } else {
            //check for collision (i.e. overlap)
            absrect2 = CGRectMake(head2.position.x, head2.position.y, [head2 boundingBox].size.width, [head2 boundingBox].size.height);
            if (CGRectIntersectsRect(absrect1, absrect2)) {
                CCLOG(@"intersected!");
                head.position = ccp(0,0);
                head.scale = 0.2;
                head.visible = FALSE;
                [head stopAllActions];
                return;
            }
        }
    }
    
    //now, this gets executed if no collission is detected....
    
    //obtain rotation angle.... from method
    //angel is in radians already
    float rotationAngle = [self getAngleWithPts:myPos andPointTwo:myPosTwo];
    
    //head.rotation is always in degrees
    head.rotation = CC_RADIANS_TO_DEGREES(rotationAngle);
    head.didMiss = TRUE;
    
    //offset head by y = h * cos(theta), x = h*sin(theta)
    head.position = ccp(head.position.x - height_now * sin(rotationAngle), head.position.y - height_now * cos(rotationAngle));
    head.visible = TRUE;
    
    //init all the actions
    //add the height of the body * 0.3 to the move: 59.5 * 0.3
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp((height_now+5) * sin(rotationAngle), (height_now+5) * cos(rotationAngle))];
    CCMoveBy *easeMoveUp = [CCEaseIn actionWithAction:moveUp rate:3.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFuncN *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
    CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:3.0];
    //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];

    [head runAction:[CCSequence actions: setTappable, easeMoveUp, delay, easeMoveDown,unsetTappable, checkCombo, nil]];

    //CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:0];
    //CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
    //CCAnimate *laugh = [CCAnimate actionWithAnimation:laughAnim];
}

-(float) getAngleWithPts: (CGPoint) pt1 andPointTwo: (CGPoint) pt2 {
    float rise = pt2.y - pt1.y;
    float run = pt2.x - pt1.x;
    float angle = atanf(rise/run) * -1;
    CCLOG(@"%f", angle);
    return angle;
}

//-(void) setOccupied: (id) sender {
//}

-(void) setTappable: (id) sender {
    Character *head = (Character *) sender;
    [head setTappable:TRUE];
}

-(void) unSetTappable: (id) sender {
    Character *head = (Character *) sender;
    [head setTappable:FALSE];
}

-(void) checkCombo: (id) sender {
    Character *head = (Character *) sender;
    //int position = head.posOccupied;
    //pos[position] = 0;
    head.rotation = 0;
    //head.sideWaysMove = FALSE;
    head.position = ccp(0,0);
    head.scale = 0.2;
    head.visible = FALSE;
    //[head removeAllChildrenWithCleanup:YES];
    //[head removeChildByTag:2 cleanup:YES];
    //[head removeChildByTag:3 cleanup:YES];
    if (head.didMiss && head.isSelectedHit) {
        //play add score animation
        baseScore += consecHits;
        consecHits = 0;
    }
    
    //display rainbows according to hit streaks
    if (consecHits == 0) {
        //consecHits = 0;
        //set all rainbows to not visible
        //for (CCSprite *temp in rainbows) {
        //    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1.5];
        //    [temp runAction:fadeOut];
        //    temp.visible = FALSE;
        //}
        speed = 1.5;
        [self unschedule:@selector(tryPopheads)];
        [self schedule:@selector(tryPopheads) interval:speed];
    } else if (consecHits % 5 == 0){
        //show rainbows every 5 hit combos
        //BOOL runLoop = FALSE;
        //check if all rainbows showing, if yes don't run next loop
        /*       for (CCSprite *temp in rainbows) {
         if (!temp.visible) {
         runLoop = TRUE;
         break;
         }
         }
         
         while (runLoop) {
         int randRainbow = arc4random() % 4;
         CCSprite *temp = [rainbows objectAtIndex:randRainbow];
         if (!temp.visible) {
         temp.visible = TRUE;
         CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:80];
         CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
         CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actionOne:fadeOut two:fadeIn]];
         [temp runAction:repeat];
         break;
         }
         } */
        
        //update speed accordingly with combo times
        speed *= 0.5;
        [self unschedule:@selector(tryPopheads)];
        [self schedule:@selector(tryPopheads) interval:speed];
    }
}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (gamePaused) return; 
    
    //remove simultaneous touch element of gamemode
    //add various other animations (e.g. fall out from sky, throw bomb, etc..)
    
    //simultaneous touch code
    /* treat 2 separate touches that are 0.2 seconds apart as simultaneous
    // if (true simultaneous touch)
    // else two really short touches - add combo count
    // else normal
    
    if ([[touches allObjects] count] >= 2) {
        //true simultaneous touch
        
        comboHits = 0;
        CCLOG(@"simultaneous touch!");
        for (UITouch *touch in [touches allObjects]) {
            CGPoint location = [touch locationInView:[touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            [self doShit:location];
        }
        baseScore += comboHits;
        //update combo hits label and add combo points to basescore
        //...
    } else {
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        diff = touch.timestamp - ts;
        
        //this is essentially all calling the doShit method
        //as if diff > 0.2, meaning not simultaneous, we reset the combohits count
        [self doShit:location];
        if (diff > 0.2) comboHits = 0;
        baseScore += comboHits;
        
        ts = touch.timestamp;
    }*/
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];

    for (CCSprite *coin in coins) {
        if (coin.tag == 1) {
            continue;
        }
        if (CGRectContainsPoint(coin.boundingBox, location)) {
            coin.tag = 1;
            [coin stopAllActions];
            //CCLOG(@"got coin!");
            baseScore += 100;
            CCScaleBy *scaleCoinUp = [CCScaleBy actionWithDuration:0.2 scale:2];
            CCAction *scaleCoinDown = [scaleCoinUp reverse];
            CCCallFuncN *removeCoin = [CCCallFuncN actionWithTarget:self selector:@selector(removeCoin:)];
            [coin runAction:[CCSequence actions:scaleCoinUp, scaleCoinDown, removeCoin, nil]];
            break;
            //[self removeChild:coin cleanup:YES];
            //[coins removeObject:coin];
        }
    }
    
    for (Character *head in heads) {
        if (head.tappable == FALSE) {
            continue;
        }
        
        //CGRect temp = CGRectMake(head.position.x, head.position.y, head.boundingBox.size.width+body_bounding_width, head.boundingBox.size.height+body_bounding_height);
        if (CGRectContainsPoint(head.boundingBox, location)) {
            
            [head stopAllActions];
            head.didMiss = FALSE;
            head.tappable = FALSE;
            
            //need to remove hiteffect sprite just like the coins
            CCSprite *hitEffect = [CCSprite spriteWithFile:@"hit effect.png"];
            hitEffect.scale = 0.01;
            hitEffect.position = ccp(head.position.x + head.contentSize.width * head.scaleX/2, head.position.y);
            [self addChild:hitEffect];
            CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:0.1 scale:1.0];
            CCScaleTo *scaleDown = [CCScaleTo actionWithDuration:0.1 scale:0.01];
            CCCallFuncN *removeHitEffect = [CCCallFuncN actionWithTarget:self selector:@selector(removeHitEffect:)];
            [hitEffect runAction:[CCSequence actions:scaleUp, scaleDown, removeHitEffect, nil]];
            
            //10% chance for a coin to popup
            if (arc4random() % 100 < 10) {
                CCSprite *testObj = [CCSprite spriteWithFile:@"coin front.png"];
                testObj.position = ccp(head.position.x + head.contentSize.width * head.scaleX/2, head.position.y);
                testObj.scale = 0.4;
                testObj.tag = 0;
                [self addChild:testObj];
                [coins addObject:testObj];
                //id bounceDown = [CCMoveBy actionWithDuration:0.5 position:ccp(0,-30)];
                //id actionDown = [CCEaseBounceOut actionWithAction:bounceDown];
                //id actionUp = [actionDown reverse];
                //CCMoveBy *popUpCoin = [CCMoveBy actionWithDuration:0.1 position:ccp(0,50)];
                //CCMoveBy *easePopUpcoin = [CCEaseIn actionWithAction:popUpCoin rate:3.0];
                //CCMoveBy *dropCoin = [CCMoveTo actionWithDuration:1.9 position:ccp(160,0)];
                //CCMoveBy *easeDropCoin = [CCEaseIn actionWithAction:dropCoin rate:1.5];
                CCRotateBy *rotateCoin = [CCRotateBy actionWithDuration:1.9 angle:(360*7)];
                CCCallFuncN *removeCoin = [CCCallFuncN actionWithTarget:self selector:@selector(removeCoin:)];
                // [testObj runAction:[CCSequence actions:actionDown, actionUp, actionDown, actionUp, removeCoin, nil]];
                [testObj runAction:[CCSequence actions: rotateCoin, removeCoin, nil]];

            }
            
            if (head.isSelectedHit) {
                //head.hp -= 10;
                //comboHits++;
                consecHits++;
                //emitter.position = location;
                //update hit streak label
                if (consecHits > 1) {
                    [hitsLabel setString:[NSString stringWithFormat:@"%d HIT STREAK!", consecHits]];
                    //CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:0.5 scale:2.5];
                    //CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:0.5 scale:0.001];
                    //[hitsLabel runAction:[CCSequence actions:scaleUp, scaleBack, nil]];
                }
                baseScore += 10;
            } else {
                lives -= 1;
                //play score adding animation
                baseScore += consecHits;
                consecHits = 0;
                //update lives
                if ([hearts count] > 0) {
                    [self removeChild:[hearts objectAtIndex:[hearts count] - 1] cleanup:YES];
                    [hearts removeLastObject];
                }
            }
            
            //int width_now = head.contentSize.width * head.scaleX;
            float height_now = head.contentSize.height * head.scaleY;
            
            float rotation = CC_DEGREES_TO_RADIANS(head.rotation);
            CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.5 position:ccp(-(5+height_now) * sin(rotation), -(height_now+5) * cos(rotation))];
            CCMoveBy *easeMoveDown = [CCEaseOut actionWithAction:moveDown rate:3.0];
            CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
            //CCCallFuncN *addMouthEffect = [CCCallFuncN actionWithTarget:self selector:@selector(applyMouthEffect:)];
            //[head runAction:addMouthEffect];
            
            [head runAction:[CCSequence actions: easeMoveDown, checkCombo, nil]];
        }
    } //end heads loop
}

-(void) applyMouthEffect: (id) sender {
    Character *head = (Character *)sender;
    //in the future, must random these effects
    CCSprite *mouthEffect = [CCSprite spriteWithFile:mouthEffectOne];
    
    UserInfo *usr = [UserInfo sharedInstance];
    CGPoint mouthCenter = usr.mouthPosition;
    
    [head addChild:mouthEffect];
    mouthEffect.scale = 1/0.2;
    mouthEffect.anchorPoint = ccp(0.5,0.5);
    mouthEffect.position = ccp(mouthCenter.x/2, mouthCenter.y/2);
}

-(void) removeHitEffect: (id) sender {
    CCSprite *hitEffect = (CCSprite *) sender;
    [self removeChild:hitEffect cleanup:YES];
}

-(void) removeCoin: (id) sender {
    CCSprite *coin = (CCSprite *) sender;
    
    /*NSArray *coinsCopy = [coins copy];
    for (CCSprite *coin2 in coinsCopy) {
        if ([coin2 isEqual:coin]) {
            [coins removeObject:coin];
            break;
        }
    }*/
    [coins removeObject:coin];
    [self removeChild:coin cleanup:YES];
}

// on "dealloc" you need to release all your retained objects

@end
