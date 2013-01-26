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
    myTime = 145;
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
        timeLabel.color = ccc3(137, 244, 148);
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
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"chalkduster" fontSize:30];
        scoreLabel.anchorPoint = ccp(0.5, 0.5);
        scoreLabel.color = ccc3(240, 150, 55);
        scoreLabel.position = ccp(scoreboard.contentSize.width/2, 28);
        [scoreLabel setString:[NSString stringWithFormat:@"%d", 0]];
        [scoreboard addChild:scoreLabel z:101];
        
        //add "hits" label
        hitsLabel = [CCLabelTTF labelWithString:@"X" fontName:@"chalkduster" fontSize:35];
        hitsLabel.color = ccc3(255, 0, 0);
        hitsLabel.anchorPoint = ccp(0.5,1);
        hitsLabel.position = ccp(winSize.width/2, winSize.height - 10);
        //hitsLabel.scale = 0.1;
        [self addChild:hitsLabel z:101];
        hitsLabel.visible = FALSE;
        
        //set cloud drifting animation
        /*cloud = [CCSprite spriteWithFile:@"hill_cloud1.png"];
        cloud.anchorPoint = ccp(0,1);
        cloud.position = ccp(winSize.width - 50, winSize.height - 10);
        [self addChild:cloud z:90];
        CCMoveBy *driftRight = [CCMoveBy actionWithDuration:5.0 position:ccp(15,0)];
        //CCMoveTo *easeDrift = [CCEaseInOut actionWithAction:driftRight rate:1.5];
        //CCCallFuncN *resetCloud = [CCCallFuncN actionWithTarget:self selector:@selector(resetCloud:)];
        CCAction *driftLeft = [driftRight reverse];
        CCSequence *cloudSequence = [CCSequence actions:driftRight, driftLeft, nil];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:cloudSequence];
        [cloud runAction:repeat];*/
        
        gameOverLabel = [CCLabelTTF labelWithString:@"0" fontName:@"chalkduster" fontSize:50];
        gameOverLabel.anchorPoint = ccp(0.5, 0.5);
        gameOverLabel.color = ccc3(240, 150, 55);
        gameOverLabel.position = ccp(winSize.width/2, winSize.height/2);
        gameOverLabel.visible = FALSE;
        [self addChild:gameOverLabel z:10];
        
        [self schedule:@selector(timerUpdate:) interval:0.5f];
    }
    return self;
}

-(void) resetCloud: (id) sender {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *temp_cloud = (CCSprite *) sender;
    temp_cloud.position = ccp(0, winSize.height - 10);
}

-(void) quitTapped: (id) sender  {
    [[CCDirector sharedDirector] resume];
    [[Game sharedGame] resetGameState];
    [[HelloWorldScene gameOverDelegate] returnToMenu];
}

- (void) resumeTapped:(id)sender {
    [self removeChildByTag:20 cleanup:YES];
    [[CCDirector sharedDirector] resume];
}

-(void) pauseGame {
    [[CCDirector sharedDirector] pause];
    //show modal view controller
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 80)];
    //[colorLayer setOpacity:80];
    [self addChild:colorLayer z:100 tag:20];
    
    CCLabelTTF *paused = [CCLabelTTF labelWithString:@"Paused!" fontName:@"chalkduster" fontSize:30];
    paused.position = ccp(winSize.width/2, winSize.height/2 + 100);
    [colorLayer addChild:paused z:10];
    
    //temporary!!!!!
    //set "resume" label
    CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(resumeTapped:)];
    CCMenu *resumeMenu = [CCMenu menuWithItems:image, nil];
    resumeMenu.position = ccp(winSize.width/2, winSize.height/2 + 25);
    [colorLayer addChild:resumeMenu z:10];
    
    //set "Main Page" label
    CCMenuItemImage *image2 = [CCMenuItemImage itemWithNormalImage:@"main menu.png" selectedImage:@"main menu.png" target:self selector:@selector(quitTapped:)];
    CCMenu *quit = [CCMenu menuWithItems:image2, nil];
    quit.position = ccp(winSize.width/2, winSize.height/2 - 25);
    [colorLayer addChild:quit z:10];
}


-(void) timerUpdate:(ccTime)deltt {
    myTime -= deltt;
    [timeLabel setString:[NSString stringWithFormat:@"%d:%02d", (int)myTime/60, (int)myTime%60]];
    
    if (myTime <= 0) {
        CCNode *scene = self.parent;
        HelloWorldScene *helloScene = (HelloWorldScene *)scene;
        [helloScene gameOver:YES];
        [self unschedule:@selector(timerUpdate)];
    } else if (myTime <= 2) {
        CCNode *scene = self.parent;
        HelloWorldScene *helloScene = (HelloWorldScene *)scene;
        [helloScene animationCoolDown];
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //if (CGRectContainsPoint(pauseMenu.boundingBox, location)) {
      //  [[HelloWorldScene gameOverDelegate] returnToMenu];
        //return YES;
    //}
    
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
    gameOverLabel.visible = TRUE;
    [gameOverLabel setString:[NSString stringWithFormat:@"%@", msg]];
}

@end
