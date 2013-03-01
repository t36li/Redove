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

-(void) setVariables {
    myTime = 1450;
    hearts = [NSMutableArray array];
    lives = 3;
    self.isTouchEnabled = YES;
}

-(id) init {
    if ((self = [super init])) {
        [self setVariables];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *clock = [CCSprite spriteWithFile:clockSp];
        clock.anchorPoint = ccp(0,0);
        clock.position = ccp(15, winSize.height - clock.contentSize.height - 10);
        [self addChild:clock z:100];
        
        //add timer label
        timeLabel = [CCLabelTTF labelWithString:@"0:0" fontName:@"chalkduster" fontSize:20];
        timeLabel.color = ccc3(90, 178, 143);
        timeLabel.anchorPoint = ccp(0,0);
        timeLabel.position = ccp(15 + clock.contentSize.width, winSize.height - clock.contentSize.height - 10);
        //timeLabel.string = nil;
        [self addChild:timeLabel z:100];
        
        //add "pause" label
        CCMenuItemImage *pause = [CCMenuItemImage itemWithNormalImage:PauseButton selectedImage:PauseButton target:self selector:@selector(pauseGame)];
        pauseMenu = [CCMenu menuWithItems:pause, nil];
        pauseMenu.anchorPoint = ccp(0,0);
        pauseMenu.position = ccp(20,20);
        [self addChild:pauseMenu z:100];
        
        //add "life" sprites
        for (int i = 0; i < lives; i++) {
            CCSprite *life = [CCSprite spriteWithFile:heartSp];
            life.anchorPoint = ccp(0,0);
            life.position = ccp(winSize.width - (i + 1)*(life.contentSize.width+5), winSize.height - life.contentSize.height - 10);
            [hearts addObject:life];
            [self addChild:life z:100];
        }
        
        //add "score" label
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"chalkduster" fontSize:30];
        scoreLabel.anchorPoint = ccp(0.5, 0.5);
        scoreLabel.color = ccc3(240, 150, 55);
        scoreLabel.position = ccp(245, 20);
        //scoreLabel.string = nil;
        [self addChild:scoreLabel z:100];
        
        gameOverLabel = [CCLabelTTF labelWithString:@"0" fontName:@"chalkduster" fontSize:50];
        gameOverLabel.anchorPoint = ccp(0.5, 0.5);
        gameOverLabel.color = ccc3(240, 150, 55);
        gameOverLabel.position = ccp(winSize.width/2, winSize.height/2);
        gameOverLabel.visible = FALSE;
        [self addChild:gameOverLabel z:100];
    }
    return self;
}

-(void)onEnterTransitionDidFinish {
    [self schedule:@selector(timerUpdate:) interval:0.5f];

    [timeLabel setString:[NSString stringWithFormat:@"%d:%02d", (int)myTime/60, (int)myTime%60]];
    [scoreLabel setString:[NSString stringWithFormat:@"%d", 0]];
}

-(void) resetCloud: (id) sender {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *temp_cloud = (CCSprite *) sender;
    temp_cloud.position = ccp(0, winSize.height - 10);
}

-(void) quitTapped: (id) sender  {
    [[CCDirector sharedDirector] resume];
    [[Game sharedGame] resetGameState];
    
    [((HelloWorldScene *)self.parent) finalCleanup];
    [[HelloWorldScene gameOverDelegate] returnToMenu];
}

- (void) resumeTapped:(id)sender {
    [self removeChildByTag:20 cleanup:YES];
    [[CCDirector sharedDirector] resume];
    [Game sharedGame].isPaused = NO;
}

-(void) pauseGame {
    [[CCDirector sharedDirector] pause];
    [Game sharedGame].isPaused = YES;
    //show modal view controller
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 80)];
    //[colorLayer setOpacity:80];
    [self addChild:colorLayer z:100 tag:20];
    
    CCLabelTTF *paused = [CCLabelTTF labelWithString:@"Paused!" fontName:@"chalkduster" fontSize:30];
    paused.position = ccp(winSize.width/2, winSize.height/2 + 100);
    [colorLayer addChild:paused];
    
    //temporary!!!!!
    //set "resume" label
    CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:ResumeButton selectedImage:ResumeButton target:self selector:@selector(resumeTapped:)];
    CCMenu *resumeMenu = [CCMenu menuWithItems:image, nil];
    resumeMenu.position = ccp(winSize.width/2, winSize.height/2 + 25);
    [colorLayer addChild:resumeMenu];
    
    //set "Main Page" label
    CCMenuItemImage *image2 = [CCMenuItemImage itemWithNormalImage:MainMenuButton selectedImage:MainMenuButton target:self selector:@selector(quitTapped:)];
    CCMenu *quit = [CCMenu menuWithItems:image2, nil];
    quit.position = ccp(winSize.width/2, winSize.height/2 - 25);
    [colorLayer addChild:quit];
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

//-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  //  CGPoint location = [touch locationInView:[touch view]];
    //location = [[CCDirector sharedDirector] convertToGL:location];
    
    //if (CGRectContainsPoint(pauseMenu.boundingBox, location)) {
      //  [[HelloWorldScene gameOverDelegate] returnToMenu];
        //return YES;
    //}
    
   // return NO;
//}

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
    gameOverLabel.visible = TRUE;
    [gameOverLabel setString:[NSString stringWithFormat:@"%@", msg]];
}

-(void)finalCleanup {
    hearts = nil;
    hud_spritesheet = nil;
    
    [self removeAllChildrenWithCleanup:YES];
    [self unscheduleAllSelectors];
}
@end
