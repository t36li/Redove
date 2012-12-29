//
//  HUDLayer.m
//  MoleIt
//
//  Created by Bob Li on 12-06-30.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HUDLayer.h"
#import "HelloWorldLayer.h"
#import "CocosViewController.h"
@implementation HUDLayer

//@synthesize gameOverDelegate;

/*
- (void) resumeTapped:(id)sender {
    
    // Reload the current scene
    //CCScene *scene = [HelloWorldLayer sceneWithDelegate:gameOverDelegate];
    [[CCDirector sharedDirector] resume];
    [self removeAllChildrenWithCleanup:YES];
    //[[Game sharedGame] resetGameState];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene]];
}


- (void)restartTapped:(id)sender {
    
//    // Reload the current scene    
//    CCScene *scene = [HelloWorldLayer sceneWithDelegate:gameOverDelegate];
//    [[Game sharedGame] resetGameState];
//    [[CCDirector sharedDirector] resume];
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene]];
}

- (void)mainMenuTapped:(id)sender {
    
    [[Game sharedGame] resetGameState];
    [gameOverDelegate returnToMenu];
}

//should be "Resume", "Restart", and "Main Menu" on the Pause Menu
- (void)showPauseMenu:(id<GameOverDelegate>)delegate {
    
    self.gameOverDelegate = delegate;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //self.isTouchEnabled = NO;
    baseScore = [[Game sharedGame] baseScore];
    multiplier = [[Game sharedGame] multiplier];
    coin = [[Game sharedGame] moneyEarned];
    
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 80)];
    //[colorLayer setOpacity:80];
    [self addChild:colorLayer z:20];
    
    
    CCSprite *highscoreLayer = [CCSprite spriteWithFile:@"score paper.png"];
    highscoreLayer.position = ccp(winSize.width/2, winSize.height/2);
    [colorLayer addChild:highscoreLayer z:10];
    
    CGSize s = [highscoreLayer contentSize]; //247 x 271
    
    //set up "score" label
    CCLabelTTF *scorelabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", baseScore]fontName:@"chalkduster" fontSize:20];
    //scorelabel.scale = 0.1;
    scorelabel.color = ccc3(235, 150, 20);
    scorelabel.position = ccp(s.width/2, s.height - 30);
    [highscoreLayer addChild:scorelabel z:10];
    //[scorelabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    CCLabelTTF *scorelabel2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Multiplier: %i", multiplier]fontName:@"chalkduster" fontSize:20];
    //scorelabel2.scale = 0.1;
    scorelabel2.color = ccc3(235, 150, 20);
    scorelabel2.position = ccp(s.width/2, s.height - 70);
    [highscoreLayer addChild:scorelabel2 z:10];
    //[scorelabel2 runAction:[CCScaleTo actionWithDuration:0.5 scale:0.8]];
    
    CCLabelTTF *scorelabel3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins: %i", coin]fontName:@"chalkduster" fontSize:20];
    scorelabel3.scale = 0.8;
    scorelabel3.color = ccc3(235, 150, 20);
    scorelabel3.position = ccp(s.width/2, s.height - 110);
    [highscoreLayer addChild:scorelabel3 z:10];
    //[scorelabel3 runAction:[CCScaleTo actionWithDuration:0.5 scale:0.8]];
    
    //set "restart" label
    CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:RestartButton selectedImage:RestartButton target:self selector:@selector(restartTapped:)];
    CCMenu *restartMenu = [CCMenu menuWithItems:image, nil];
    //restartMenu.scale = 0.1;
    restartMenu.position = ccp(s.width/2 - 70, s.height * 0.2);
    [highscoreLayer addChild:restartMenu z:10];
    //[restartMenu runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    //set "main menu" label
    CCMenuItemImage *image1 = [CCMenuItemImage itemWithNormalImage:MainMenuButton selectedImage:MainMenuButton target:self selector:@selector(mainMenuTapped:)];
    CCMenu *mainMenu = [CCMenu menuWithItems:image1, nil];
    //mainMenu.scale = 0.1;
    mainMenu.position = ccp(s.width/2 + 70, s.height * 0.2);
    [highscoreLayer addChild:mainMenu z:10];
    //[mainMenu runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    //set "Resume" label
    CCMenuItemImage *image2 = [CCMenuItemImage itemWithNormalImage:ResumeButton selectedImage:ResumeButton target:self selector:@selector(resumeTapped:)];
    CCMenu *resumeMenu = [CCMenu menuWithItems:image2, nil];
    resumeMenu.position = ccp(s.width/2, s.height * 0.2);
    [highscoreLayer addChild:resumeMenu z:10];

}
 */

-(void) setVariables {
    myTime = 45;
    hearts = [NSMutableArray array];
    lives = 3;
    self.isTouchEnabled = YES;
}

-(id) init {
    if ((self = [super init])) {
        [self setVariables];
        
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        //add timer label
        timeLabel = [CCLabelTTF labelWithString:@"0:0" fontName:@"chalkduster" fontSize:30];
        timeLabel.color = ccc3(255, 249, 0);
        timeLabel.anchorPoint = ccp(0,0);
        timeLabel.position = ccp(15, winSize.height - timeLabel.contentSize.height);
        [self addChild:timeLabel z:101];
        
        //add "pause" label
        CCMenuItemImage *pause = [CCMenuItemImage itemWithNormalImage:PauseButton selectedImage:PauseButton target:self selector:@selector(pauseGame)];
        pauseMenu = [CCMenu menuWithItems:pause, nil];
        pauseMenu.anchorPoint = ccp(0,0);
        pauseMenu.position = ccp(20,20);
        [self addChild:pauseMenu z:101];
        
        //add "life" sprites
        for (int i = 0; i < lives; i++) {
            CCSprite *life = [CCSprite spriteWithFile:heartSp];
            life.anchorPoint = ccp(0,0);
            life.position = ccp(winSize.width - (i + 1)*(life.contentSize.width+10), winSize.height - life.contentSize.height);
            [hearts addObject:life];
            [self addChild:life z:101];
        }
        
        //add "Scoreboard"
        scoreboard = [CCSprite spriteWithFile:scoreboardSp];
        scoreboard.anchorPoint = ccp(0, 0);
        scoreboard.position = ccp(winSize.width/2 - scoreboard.contentSize.width/2, 0);
        [self addChild:scoreboard z:101];
        
        //add "score" label
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"chalkduster" fontSize:50];
        scoreLabel.anchorPoint = ccp(0.5, 0.5);
        scoreLabel.color = ccc3(255, 200, 0);
        scoreLabel.position = ccp(scoreboard.contentSize.width/2, 40);
        [scoreboard addChild:scoreLabel z:101];
        
        
        //add "hits" label
        hitsLabel = [CCLabelTTF labelWithString:@"X" fontName:@"chalkduster" fontSize:35];
        hitsLabel.color = ccc3(255, 0, 0);
        hitsLabel.anchorPoint = ccp(0.5,1);
        hitsLabel.position = ccp(winSize.width/2, winSize.height - 10);
        //hitsLabel.scale = 0.1;
        [self addChild:hitsLabel z:101];
        hitsLabel.visible = FALSE;
        
        [self schedule:@selector(timerUpdate:) interval:0.5f];
    }
    return self;
}

-(void) pauseGame {
    [[HelloWorldScene gameOverDelegate] returnToMenu];
}


-(void) timerUpdate:(ccTime)deltt {
    myTime -= deltt;
    [timeLabel setString:[NSString stringWithFormat:@"%d:%02d", (int)myTime/60, (int)myTime%60]];
    
    if (myTime <= 0) {
        CCNode *scene = self.parent;
        HelloWorldScene *helloScene = (HelloWorldScene *)scene;
        [helloScene gameOver:YES];
        [self unschedule:@selector(timerUpdate)];
    }
    
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(pauseMenu.boundingBox, location)) {
        HelloWorldScene *scene = (HelloWorldScene *)self.parent;
        [[HelloWorldScene gameOverDelegate] returnToMenu];
        return YES;
    }
    
    return NO;
}

-(void)resetTimer {
    [self setVariables];
    [self unschedule:@selector(timerUpdate:)];
}


-(void)removeHeart {
    if ([hearts count] > 0) {
        [self removeChild:[hearts objectAtIndex:[hearts count] - 1] cleanup:YES];
        [hearts removeLastObject];
    }
}

-(void)updateScore:(NSInteger)score {
    [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
}

-(void)updateHits:(NSInteger)hits {
    [hitsLabel setString:[NSString stringWithFormat:@"%d", hits]];
}

-(void)showGameOverLabel:(NSString *)msg {
    CCLabelTTF *label = [CCLabelTTF labelWithString:msg fontName:@"chalkduster" fontSize:50];
    label.color = ccc3(255, 249, 0);
    label.position = ccp(150,200);
    [self addChild:label z:10];
}

/*
-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
}
*/
/*
- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
 */

@end
