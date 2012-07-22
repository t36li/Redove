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

        comboHits = 0;
        consecHits = 0;
        totalTime = 1;
        myTime = (int)totalTime;
        baseScore = 0;
        speed = 1.5;
        ts = 0;
        diff = 0;
        
        //testing: hard-code 5 points
        myCGPts = [[NSArray alloc] initWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake(32/2, 320 - 348/2)],
                   [NSValue valueWithCGPoint:CGPointMake(126/2, 320 - 369/2)],
                   [NSValue valueWithCGPoint:CGPointMake(211/2, 320 - 418/2)],
                   [NSValue valueWithCGPoint:CGPointMake(270/2, 320 - 483/2)],
                   [NSValue valueWithCGPoint:CGPointMake(303/2, 320 - 552/2)],
                   nil];
        
        _hud = hud;
        self.isTouchEnabled = YES;
        gameOver = FALSE;
        gamePaused = FALSE;
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        //add background this is for retina display
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
        //set background color to white
        glClearColor(255, 255, 255, 255);
        
        CCSprite *bg1 = [CCSprite spriteWithFile:hills_l1];
        CCSprite *bg2 = [CCSprite spriteWithFile:@"hills_L2.png"];
        CCSprite *bg3 = [CCSprite spriteWithFile:@"hills_L3.png"];
        CCSprite *bg4 = [CCSprite spriteWithFile:@"hills_L4.png"];
        CCSprite *bg5 = [CCSprite spriteWithFile:@"hills_L5.png"];
        CCSprite *bg6 = [CCSprite spriteWithFile:@"hills_L6.png"];
        CCSprite *bg7 = [CCSprite spriteWithFile:@"hills_L7.png"];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        CCSprite *bg8 = [CCSprite spriteWithFile:@"hills_L8_new.png"];
        CCSprite *bg9 = [CCSprite spriteWithFile:@"cloud background.png"];
        
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
        
        //add "rainbows"
        /*  rainbows = [[NSMutableArray alloc] init];
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
        [self addChild:scoreboard z:10];
        
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
        //UserInfo *usr = [UserInfo sharedInstance];
        //UIImage *helmetImage = usr.bigHeadImg;
        
        //Character *head = [Character spriteWithCGImage:[tempImage CGImage] key:@"test"];
        //head.position = ccp(50, 50);
        //[self addChild:head z:100];
        
        //the number of total heads to include in the heads array should be relative to the difficulty level chosen previously... max will be 10 ATM...this should be a loop that fast-enumerates through all the chosen names array from the previous view
        //for testing purposes, set to 7
        
        //testing the upper and lower body piece-together
        UIImage *lowerBody = [UIImage imageNamed:@"peter body.png"];
        UIImage *bigHead = [UIImage imageNamed:@"peter head c.png"];
        int index = 1;
        for (int i = 0; i < 7; i++) {
            //get the friend portrait image...once database kicks in, we will grab the big head
            //belonging to each user... then piece-wise this to the lower body part...
            Character *head = [Character spriteWithCGImage:[bigHead CGImage] key:[NSString stringWithFormat:@"body_frame%i", index]];
            [head setTappable:FALSE];
            //head.sideWaysMove = FALSE;
            head.anchorPoint = ccp(0,0);
            head.scale = 0.3;
            head.isSelectedHit = TRUE;
            head.visible = FALSE;
            
            head.position = ccp(0,0);
            //int width = head.contentSize.width;
            //int height = head.contentSize.height;
            
            //CCSprite *helmet = [CCSprite spriteWithCGImage:[helmetImage CGImage] key:[NSString stringWithFormat:@"helmet_frame%i", index]];
            //CCSprite *body = [CCSprite spriteWithCGImage:[lowerBody CGImage] key:[NSString stringWithFormat:@"head_frame%i", index]];
            
            //[head setImageName:friend];
            
            //if ([selectedHeads containsObject:friend]) {
            //    head.isSelectedHit = FALSE;
            //} else {
            //    head.isSelectedHit = TRUE;
            //}
            //[head addChild:body z:-10];
            //body.anchorPoint = ccp(0.5, 0.8);
            //body.position = ccp(125, 10);
            //body.scale = 1;
            
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paused" message:@"Press the button to..." delegate:self cancelButtonTitle:@"Resume" otherButtonTitles:@"Restart", nil];
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
        [_hud showRestartMenu:NO];
        
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
    
    //end game if time is up
    //if (myTime <= 0 || lives <= 0) {
    //    return;
    // }
    
    //CCCallFuncN *setOccupied = [CCCallFuncN actionWithTarget:self selector:@selector(setOccupied:)];
    //[head runAction:[CCSequence actions:setOccupied, nil]];
    //Character *head = (Character *) sender;
    
    //CGSize s = [[CCDirector sharedDirector] winSize];
    //int width_now = head.contentSize.width * head.scaleX;
    float height_now = head.contentSize.height * head.scaleY;
    CCLOG(@"%f", sinf(90));
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
    
    //testing with 5 hard-coded cgpoints -> 5 pts = only 4 possible locations
    int randPos = arc4random() % 4;
    //return if it's the last point in the array
    if (randPos == 4) {
        return;
    }
    
    //get a random location
    CGPoint myPos = [[myCGPts objectAtIndex:randPos] CGPointValue];
    CGPoint myPosTwo = [[myCGPts objectAtIndex:randPos + 1] CGPointValue];
    head.position = myPos;
    head.visible = TRUE;
    //check if collides with all other heads ... problem is dunno which index this head is in...
    //int index = (int) [heads indexOfObject:head];
    CGRect absrect1, absrect2;
    absrect1 = CGRectMake(head.position.x, head.position.y, [head boundingBox].size.width*head.scaleX, [head boundingBox].size.height*head.scaleY);
    for (Character *head2 in heads) {
        //if this is itself, then skip it
        if (head.position.x == head2.position.x && head.position.y == head2.position.y ) {
            continue;
        } else {
            //check for collision (i.e. overlap)
            //Character *head2 = [heads objectAtIndex:i];
            
            absrect2 = CGRectMake(head2.position.x, head2.position.y, [head2 boundingBox].size.width*head2.scaleX, [head2 boundingBox].size.height*head2.scaleY);
            if (CGRectIntersectsRect(absrect1, absrect2)) {
                CCLOG(@"intersected!");
                [head stopAllActions];
                return;
            }
        }
    }
    
    //now, this gets executed if no collission is detected....
    
    //if (pos[randPos] == 1) {
    //    [head stopAllActions];
    //    return;
    //} else {
    //    head.posOccupied = randPos;
    //    pos[randPos] = 1;
    
    //obtain rotation angle.... from method
    
    float rotationAngle = [self getAngleWithPts:myPos andPointTwo:myPosTwo];
    
    //trig in objective-c uses radians
    // radian = degree * pi/180
    
    float rotationAngleRad = rotationAngle * M_PI / 180;

    head.rotation = rotationAngle;
    head.position = ccp(head.position.x - height_now * sin(rotationAngleRad), head.position.y - height_now * cos(rotationAngleRad));
    [head setZOrder:-35];
    head.didMiss = TRUE;
    //offset head by y = h * cos(theta), x = h*sin(theta)
    
    //init all the actions
    //CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.5 position:ccp(height_now * sin(rotationAngle), height_now * cos(rotationAngle))];
    //CCEaseInOut *easeMoveDown = [CCEaseInOut actionWithAction:moveDown rate:3.5f];
    //CCAction *easeMoveUp = [easeMoveDown reverse];
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:1.0 position:ccp(0,height_now)];
    CCEaseInOut *easeMoveUp = [CCEaseInOut actionWithAction:moveUp rate:4.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    
    CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFuncN *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
    CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:4.0];
    
    //first move down the head and set to visible
    //[head runAction:easeMoveDown];
    head.visible = TRUE;

    [head runAction:[CCSequence actions: setTappable, easeMoveUp, delay, easeMoveDown,unsetTappable, checkCombo, nil]];


      //  switch (randPos) {
      //      default:
      //          head.visible = FALSE;
      //          break;
      //  }
        
        //Appear animations and tasks
        
        //CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp(0,height_now)];
        //CCEaseInOut *easeMoveUp = [CCEaseInOut actionWithAction:moveUp rate:4.0];
        //CCAction *easeMoveDown = [easeMoveUp reverse];
        //CCMoveBy *moveRight = [CCMoveBy actionWithDuration:0.5 position:ccp(width_now/2, height_now/2)];
        //CCEaseInOut *easeMoveRight = [CCEaseInOut actionWithAction:moveRight rate:4.0];
        //CCAction *easeMoveLeft = [easeMoveRight reverse];
        //CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:0];
        //CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
        //CCAnimate *laugh = [CCAnimate actionWithAnimation:laughAnim];
        
        //to fix "bug" put unsetTappble infront of fadeout
        //[head runAction:[CCSequence actions:setTappable, fadeIn, delay, fadeOut, unsetTappable, delay, checkCombo, nil]];
        //if (head.sideWaysMove) {
        //    [head runAction:[CCSequence actions:setTappable, easeMoveRight, delay, easeMoveLeft,unsetTappable, checkCombo, nil]];
        //} else {
        //    [head runAction:[CCSequence actions:setTappable, easeMoveUp, delay, easeMoveDown,unsetTappable, checkCombo, nil]];
        //}
    //} 
}

-(float) getAngleWithPts: (CGPoint) pt1 andPointTwo: (CGPoint) pt2 {
    return 10 * atanf(fabs(pt2.y - pt1.y)/fabs(pt2.x - pt1.x));
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
    head.scale = 0.3;
    head.visible = FALSE;
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
    // treat 2 separate touches that are 0.2 seconds apart as simultaneous
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
        
    }
}


-(void) doShit: (CGPoint)location {
    //return if paused
    
    //CCLOG(@"x: %i, y: %i", (int)location.x, (int)location.y);
    //NSArray *selectedHeads = [[Game sharedGame] selectedHeads];
    
    //location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (Character *head in heads) {
        if (head.tappable == FALSE) {
            continue;
        }
        if (CGRectContainsPoint(head.boundingBox, location)) {
            head.didMiss = FALSE;
            if (head.isSelectedHit) {
                //head.hp -= 10;
                //comboHits++;
                consecHits++;
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
            
            int width_now = head.contentSize.width * head.scaleX;
            int height_now = head.contentSize.height * head.scaleY;
            //play go down animation
            head.tappable = FALSE;
            //CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.3 opacity:0];
            CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
            CCMoveBy *movedown = [CCMoveBy actionWithDuration:0.5 position:ccp(0,-height_now)];
            CCEaseInOut *easeMoveDown = [CCEaseInOut actionWithAction:movedown rate:4.0];
            //CCMoveBy *moveLeft = [CCMoveBy actionWithDuration:0.5 position:ccp(-width_now/2, -height_now)];
            //CCEaseInOut *easeMoveLeft = [CCEaseInOut actionWithAction:moveLeft rate:4.0];
            
            [head stopAllActions];
            // keep the tapping "bug" for testing purposes
            //[head runAction:[CCSequence actions: fadeOut, checkCombo, nil]];
            //if (head.sideWaysMove) {
                [head runAction:[CCSequence actions: easeMoveDown, checkCombo, nil]];
            //} else {
            //    [head runAction:[CCSequence actions: easeMoveDown, checkCombo, nil]];
            //}
        }
    } //end heads loop
    
    //where to update the combo hits...
    //update how many combo hits
   // [comboLabel setString:[NSString stringWithFormat:@"%d HIT COMBO", comboHits]];
    //CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
    //CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:0];
    //[comboLabel runAction:[CCSequence actions:fadeIn, fadeOut, nil]];
    //comboHits = 0;
}

// on "dealloc" you need to release all your retained objects

@end
