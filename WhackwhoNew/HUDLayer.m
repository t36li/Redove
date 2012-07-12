//
//  HUDLayer.m
//  MoleIt
//
//  Created by Bob Li on 12-06-30.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HUDLayer.h"
#import "ChooseWhoLayer.h"

@implementation HUDLayer

- (void)restartTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [ChooseWhoLayer scene];
    [[Game sharedGame] resetGameState];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
}

- (void)mainMenuTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [ChooseWhoLayer scene];
    [[Game sharedGame] resetGameState];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
}

- (void)showRestartMenu:(BOOL)won {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //testing
    //tempDifficulty = 4;
    
    //self.isTouchEnabled = NO;
    baseScore = [[Game sharedGame] baseScore];
    consecHits = [[Game sharedGame] consecHits];
    
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 80)];
    //[colorLayer setOpacity:80];
    [self addChild:colorLayer z:20];
    
    CCLayerColor *highscoreLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255) width:winSize.width*0.8 height:winSize.height*0.8];
    [self addChild:highscoreLayer z:30];
    //CCLOG(@"(%i, %i)", (int)winSize.width, (int)winSize.height);
    highscoreLayer.position = ccp(50, 50);
    
    CGSize s = [highscoreLayer contentSize];
    
    //set up "score" label
    CCLabelTTF *scorelabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Base Score: %i", baseScore]fontName:@"chalkduster" fontSize:20];
    scorelabel.scale = 0.1;
    scorelabel.color = ccc3(235, 150, 20);
    scorelabel.position = ccp(s.width/2, s.height - 10);
    [highscoreLayer addChild:scorelabel z:10];
    [scorelabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    CCLabelTTF *scorelabel2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Combo Hits: %i", consecHits]fontName:@"chalkduster" fontSize:20];
    scorelabel2.scale = 0.1;
    scorelabel2.color = ccc3(235, 150, 20);
    scorelabel2.position = ccp(s.width/2, s.height/2);
    [highscoreLayer addChild:scorelabel2 z:10];
    [scorelabel2 runAction:[CCScaleTo actionWithDuration:0.5 scale:0.8]];
    
    CCLabelTTF *scorelabel3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total Score: %i", baseScore + consecHits * 10]fontName:@"chalkduster" fontSize:30];
    scorelabel3.scale = 0.1;
    scorelabel3.color = ccc3(235, 150, 20);
    scorelabel3.position = ccp(s.width/2, 10);
    [highscoreLayer addChild:scorelabel3 z:10];
    [scorelabel3 runAction:[CCScaleTo actionWithDuration:0.5 scale:0.8]];
    
    //set "restart" label
    CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(restartTapped:)];
    CCMenu *restartMenu = [CCMenu menuWithItems:image, nil];
    restartMenu.scale = 0.1;
    restartMenu.position = ccp(s.width, 10);
    [highscoreLayer addChild:restartMenu z:10];
    [restartMenu runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    //set "main menu" label
    CCMenuItemImage *image1 = [CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(mainMenuTapped:)];
    CCMenu *mainMenu = [CCMenu menuWithItems:image1, nil];
    mainMenu.scale = 0.1;
    mainMenu.position = ccp(10, 10);
    [highscoreLayer addChild:mainMenu z:10];
    [mainMenu runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
}

@end
