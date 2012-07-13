//
//  HelloWorldLayer.m
//  MoleIt
//
//  Created by Bob Li on 12-06-23.
//  Copyright Waterloo 2012. All rights reserved.
//


// Import the interfaces
#import "LevelOneLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import <Foundation/Foundation.h>


#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    // 'hud' is the restart object
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud z:10];
    
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [[[HelloWorldLayer alloc] initWithHUD:hud] autorelease];;
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithHUD:(HUDLayer *)hud
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        //hp1 = 100;
        //hp2 = 100;
        //hp3 = 100;
        comboHits = 0;
        consecHits = 0;
        totalTime = 30;
        myTime = (int)totalTime;
        baseScore = 0;
        speed = 1.5;
        ts = 0;
        diff = 0;
        
        //testing to see if random works
        //numHitOccur = 0;
        //numBombOccur = 0;
        
        _hud = hud;
        self.isTouchEnabled = YES;
        gameOver = FALSE;
        gamePaused = FALSE;
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        //totalScore = [[Game sharedGame] score];
        
        /*tempDifficulty = [[Game sharedGame] difficulty];
         //determine base score
         switch (tempDifficulty) {
         case 1:
         multiplier = 1;
         break;
         case 2:
         multiplier = 1.5;
         break;
         case 3:
         multiplier = 2;
         break;
         }*/
        //tempDifficulty = [[Game sharedGame] difficulty];
        //popups = 7;
        
        //CCSprite *spContainer = [(CCSprite*)[CCSprite alloc] init];
        //spContainer.position = ccp(s.width/2, s.height/2);
        
        //add background this is for retina display
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
        CCSprite *bg1 = [CCSprite spriteWithFile:@"hills_L1.png"];
        CCSprite *bg2 = [CCSprite spriteWithFile:@"hills_L2.png"];
        CCSprite *bg3 = [CCSprite spriteWithFile:@"hills_L3.png"];
        CCSprite *bg4 = [CCSprite spriteWithFile:@"hills_L4.png"];
        CCSprite *bg5 = [CCSprite spriteWithFile:@"hills_L5.png"];
        CCSprite *bg6 = [CCSprite spriteWithFile:@"hills_L6.png"];
        CCSprite *bg7 = [CCSprite spriteWithFile:@"hills_L7.png"];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        CCSprite *bg8 = [CCSprite spriteWithFile:@"hills_L8_new.png"];
        CCSprite *bg9 = [CCSprite spriteWithFile:@"hills_L9_new.png"];
        
        
        bg9.position = ccp(s.width/2, s.height/2);
        bg8.position = ccp(s.width/2, s.height/2);
        bg7.position = ccp(s.width/2, s.height/2);
        bg6.position = ccp(s.width/2, s.height/2);
        bg5.position = ccp(s.width/2, s.height/2);
        bg4.position = ccp(s.width/2, s.height/2);
        bg3.position = ccp(s.width/2, s.height/2);
        bg2.position = ccp(s.width/2, s.height/2);
        bg1.position = ccp(s.width/2, s.height/2);
        
        // [spContainer addChild:bg1 z:-30];
        // [spContainer addChild:bg2 z:-40];
        // [spContainer addChild:bg3 z:-50];
        // [spContainer addChild:bg4 z:-60];
        // [spContainer addChild:bg5 z:-70];
        //[spContainer addChild:bg6 z:-80];
        //[spContainer addChild:bg7 z:-90];
        //[spContainer addChild:bg8 z:-100];
        //[spContainer addChild:bg9 z:-110];
        
        [self addChild:bg1 z:-30];
        [self addChild:bg2 z:-40];
        [self addChild:bg3 z:-50];
        [self addChild:bg4 z:-60];
        [self addChild:bg5 z:-70];
        [self addChild:bg6 z:-80];
        [self addChild:bg7 z:-90];
        [self addChild:bg8 z:-100];
        [self addChild:bg9 z:-110];
        //[self addChild:spContainer];
        
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
        comboLabel = [CCLabelTTF labelWithString:@"  HIT COMBO" fontName:@"chalkduster" fontSize:20];
        comboLabel.color = ccc3(255, 249, 0);
        comboLabel.anchorPoint = ccp(0.5,1);
        comboLabel.position = ccp(s.width/2, s.height - 30);
        [self addChild:comboLabel z:10];
        
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
        
        //add "hp" labels
        /*hpBar1 = [CCLabelTTF labelWithString:@"Hp 1: 0" fontName:@"Arial" fontSize:20];
         hpBar1.color = ccc3(0,0,0);
         hpBar1.anchorPoint = ccp(1,1);
         hpBar1.position = ccp(s.width - margin, s.height - lifeLabel.contentSize.height);
         [self addChild:hpBar1 z:10];
         
         hpBar2 = [CCLabelTTF labelWithString:@"Hp 2: 0" fontName:@"Arial" fontSize:20];
         hpBar2.color = ccc3(0,0,0);
         hpBar2.anchorPoint = ccp(1,1);
         hpBar2.position = ccp(s.width - margin, s.height - 2*lifeLabel.contentSize.height);
         [self addChild:hpBar2 z:10];
         
         hpBar3 = [CCLabelTTF labelWithString:@"Hp 3: 0" fontName:@"Arial" fontSize:20];
         hpBar3.color = ccc3(0,0,0);
         hpBar3.anchorPoint = ccp(1,1);
         hpBar3.position = ccp(s.width - margin, s.height - 3*lifeLabel.contentSize.height);
         [self addChild:hpBar3 z:10];*/
        
        //add "rainbows"
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
        [self addChild:rainbow z:-95];
        
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
        
        //place heads on the screen        
        heads = [[NSMutableArray alloc] init];
        NSArray *bigList = [[Game sharedGame] friendList];
        NSArray *selectedHeads = [[Game sharedGame] selectedHeads];
        
        //set all positions to not taken (i.e. = 0)
        for (int i = 0; i < 17; i++) {
            pos[i] = 0;
        }
        
        for (NSString *friend in bigList) {
            Character *head = [Character spriteWithFile:friend];
            [head setTappable:FALSE];
            //[head setImageName:friend];
            head.sideWaysMove = FALSE;
            head.anchorPoint = ccp(0,0);
            head.scale = 1;
            if ([selectedHeads containsObject:friend]) {
                head.isSelectedHit = FALSE;
            } else {
                head.isSelectedHit = TRUE;
            }
            head.visible = FALSE;
            [self addChild:head];
            [heads addObject:head];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paused" message:@"Press the button to..." delegate:self cancelButtonTitle:@"Resume" otherButtonTitles:@"Restart", nil];
    [alert show];
    gamePaused = TRUE;
    [[CCDirector sharedDirector] pause];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [[CCDirector sharedDirector] resume];
    } else if (buttonIndex == 1) {
        gameOver = TRUE;
        [[CCDirector sharedDirector] resume];
        CCScene *scene = [ChooseWhoLayer scene];
        [[Game sharedGame] resetGameState];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
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
        //CCLOG(@"numHitOccur: %d", numHitOccur);
        //CCLOG(@"numBombOccur: %d", numBombOccur);
        [[Game sharedGame] setBaseScore:baseScore];
        [[Game sharedGame] setConsecHits:consecHits];
        //[[Game sharedGame] setTimeBonus: (myTime%60)];
        //[[Game sharedGame] resetGameState];
        [_hud showRestartMenu:NO];
        
        //CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:@"GAME OVER!" fontName:@"Arial" fontSize:40];
        
        gameOver = TRUE;
        return;
    }
}

-(void) tryPopheads{
    
    if (gameOver) return;
    
    //[self performSelector:@selector(checkGameState)];
    
    //should remove the head from the array if head.hp == 0?
    //arc4random() % 3 randomly pops 0,1,2
    
    for (Character *head in heads) {
        if (head.numberOfRunningActions == 0) {
            if (arc4random() % 100 < 90) {
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
    
    CCCallFuncN *setOccupied = [CCCallFuncN actionWithTarget:self selector:@selector(setOccupied:)];
    [head runAction:[CCSequence actions:setOccupied, nil]];
    
}

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
    int position = head.posOccupied;
    pos[position] = 0;
    head.rotation = 0;
    head.sideWaysMove = FALSE;
    head.scale = 1;
    head.visible = FALSE;
    if (head.didMiss && head.isSelectedHit) {
        consecHits = 0;
    }
    
    //display rainbows according to hit streaks
    if (consecHits == 0) {
        //consecHits = 0;
        //set all rainbows to not visible
        /*      for (CCSprite *temp in rainbows) {
         CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1.5];
         [temp runAction:fadeOut];
         temp.visible = FALSE;
         }*/
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

-(void) setOccupied: (id) sender {
    Character *head = (Character *) sender;
    //CGSize s = [[CCDirector sharedDirector] winSize];
    
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
    
    //appear randomly in 1 of the 7 spots, if the position is taken (i.e. == 1) 
    //then, do nothing
    //else, set that position to be occupied
    int randPos = arc4random() % 17;
    if (pos[randPos] == 1) {
        [head stopAllActions];
        return;
    } else {
        head.posOccupied = randPos;
        pos[randPos] = 1;
        head.didMiss = TRUE;
        head.visible = TRUE;
        switch (randPos) {
            case 0:
                head.position = ccp(15, 140-50);
                head.rotation = 20;
                [head setZOrder:-35];
                break;
            case 1:
                head.position = ccp(90-25, 116-25); //sideways move
                //reset the rotation at unsetOccupied
                head.sideWaysMove = TRUE;
                head.rotation = 45;
                [head setZOrder:-35];
                break;
            case 2:
                head.position = ccp(135-25, 35-25); //sideways move
                head.sideWaysMove = TRUE;
                head.rotation = 55;
                [head setZOrder:-35];
                break;
            case 3:
                head.position = ccp(165, 57-50); //up nd down
                head.rotation = -20;
                head.scale *= 0.9;
                [head setZOrder:-45];
                break;
            case 4:
                head.position = ccp(258, 88-50); //up nd down
                head.scale *= 0.9;
                [head setZOrder:-45];
                break;
            case 5:
                head.position = ccp(407, 75-50); //up nd down
                head.rotation = 20;
                head.scale *= 0.9;
                [head setZOrder:-45];
                break;
            case 6:
                head.position = ccp(100, 153-50); //up nd down
                head.rotation = -20;
                head.scale *= 0.8;
                [head setZOrder:-55];
                break;
            case 7:
                head.position = ccp(200, 153-50); //up nd down
                head.rotation = 40;
                head.scale *= 0.8;
                [head setZOrder:-55];
                break;
            case 8:
                head.position = ccp(276, 154-50); //up nd down
                head.rotation = -20;
                head.scale *= 0.7;
                [head setZOrder:-65];
                break;
            case 9:
                head.position = ccp(355, 186-50); //up nd down
                head.scale *= 0.7;
                [head setZOrder:-65];
                break;
            case 10:
                head.position = ccp(428, 185-50); //up nd down
                head.scale *= 0.7;
                head.rotation = 20;
                [head setZOrder:-65];
                break;
            case 11:
                head.position = ccp(170, 197-50);
                head.rotation = -30;
                //needs to rescale to normal after
                head.scale *= 0.6;
                [head setZOrder:-75];
                break;
            case 12:
                head.position = ccp(273, 233-50);
                head.scale *= 0.6;
                [head setZOrder:-75];
                break;
            case 13:
                head.position = ccp(335, 225-50);
                head.rotation = 30;
                head.scale *= 0.6;
                [head setZOrder:-75];
                break;
            case 14:
                head.position = ccp(21, 236-50);
                //head.rotation = 30;
                head.scale *= 0.6;
                [head setZOrder:-85];
                break;
            case 15:
                head.position = ccp(116, 198-50);
                head.rotation = 40;
                head.scale *= 0.6;
                [head setZOrder:-85];
                break;
            case 16:
                head.position = ccp(452, 230-50);
                //head.rotation = 30;
                head.scale *= 0.6;
                [head setZOrder:-95];
                break;
        }
        
        //Appear animations and tasks
        
        CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp(0,head.contentSize.height)];
        CCEaseInOut *easeMoveUp = [CCEaseInOut actionWithAction:moveUp rate:3.0];
        CCAction *easeMoveDown = [easeMoveUp reverse];
        CCMoveBy *moveRight = [CCMoveBy actionWithDuration:0.5 position:ccp(head.contentSize.width/2, head.contentSize.height/2)];
        CCEaseInOut *easeMoveRight = [CCEaseInOut actionWithAction:moveRight rate:3.0];
        CCAction *easeMoveLeft = [easeMoveRight reverse];
        //CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:0];
        //CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
        CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
        CCCallFuncN *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
        CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
        //CCAnimate *laugh = [CCAnimate actionWithAnimation:laughAnim];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:2.0];
        
        //to fix "bug" put unsetTappble infront of fadeout
        //[head runAction:[CCSequence actions:setTappable, fadeIn, delay, fadeOut, unsetTappable, delay, checkCombo, nil]];
        if (head.sideWaysMove) {
            [head runAction:[CCSequence actions:setTappable, easeMoveRight, delay, easeMoveLeft,unsetTappable, checkCombo, nil]];
        } else {
            [head runAction:[CCSequence actions:setTappable, easeMoveUp, delay, easeMoveDown,unsetTappable, checkCombo, nil]];
        }
    }
}

/*-(CCAnimation *) laughAnimation {
 
 NSString *plistPath = [[NSBundle mainBundle] pathForResource:animPlist ofType:@"plist"];
 NSArray *animImages = [NSArray arrayWithContentsOfFile:plistPath];
 NSMutableArray *animFrames = [NSMutableArray array];
 for (NSString *animImage in animImages) {
 [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animImage]];
 }
 
 NSMutableArray *animImages =[[NSMutableArray alloc] init];
 [animImages addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mole_1.png"]];
 [animImages addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mole_laugh1.png"]];
 [animImages addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mole_laugh2.png"]];
 [animImages addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mole_laugh3.png"]];
 [animImages addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mole_laugh2.png"]];
 [animImages addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mole_laugh1.png"]];
 
 //laugh animations
 CCAnimation *a = [CCAnimation animationWithSpriteFrames:animImages delay:1.0f/6.0f];
 //CCAnimate* animate = [CCAnimate actionWithAnimation:a];
 //CCRepeatForever *laugh = [CCRepeatForever actionWithAction: animate];
 return a;
 //return [CCAnimation animationWithSpriteFrames:animImages delay:delay];
 }
 
 -(void) registerWithTouchDispatcher {
 [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority swallowsTouches:NO];
 }*/

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (gamePaused) return; 
    
    
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
                comboHits++;
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
                consecHits = 0;
                //update lives
                if ([hearts count] > 0) {
                    [self removeChild:[hearts objectAtIndex:[hearts count] - 1] cleanup:YES];
                    [hearts removeLastObject];
                }
            }
            
            //play go down animation
            head.tappable = FALSE;
            //CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.3 opacity:0];
            CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
            CCMoveBy *movedown = [CCMoveBy actionWithDuration:0.5 position:ccp(0,-head.contentSize.height)];
            CCEaseInOut *easeMoveDown = [CCEaseInOut actionWithAction:movedown rate:2.0];
            CCMoveBy *moveLeft = [CCMoveBy actionWithDuration:0.5 position:ccp(-head.contentSize.width/2, -head.contentSize.height/2)];
            CCEaseInOut *easeMoveLeft = [CCEaseInOut actionWithAction:moveLeft rate:3.0];
            
            [head stopAllActions];
            // keep the tapping "bug" for testing purposes
            //[head runAction:[CCSequence actions: fadeOut, checkCombo, nil]];
            if (head.sideWaysMove) {
                [head runAction:[CCSequence actions: checkCombo, easeMoveLeft, nil]];
            } else {
                [head runAction:[CCSequence actions: checkCombo, easeMoveDown, nil]];
            }
        }
    } //end heads loop
    
    //where to update the combo hits...
    //update how many combo hits
    [comboLabel setString:[NSString stringWithFormat:@"%d HIT COMBO", comboHits]];
    //CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
    //CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:0];
    //[comboLabel runAction:[CCSequence actions:fadeIn, fadeOut, nil]];
    //comboHits = 0;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [heads release];
    [hearts release];
    [rainbows release];
    //[selectedHeads release];
    //[bigList release];
	[super dealloc];
}

@end
