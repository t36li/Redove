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

@synthesize gameOverDelegate;

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

@end
