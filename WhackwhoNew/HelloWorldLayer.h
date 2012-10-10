//
//  HelloWorldLayer.h
//  MoleIt
//
//  Created by Bob Li on 12-06-23.
//  Copyright Waterloo 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HUDLayer.h"
#import "Game.h"
#import "Character.h"
//#import "ChooseWhoLayer.h"
#import "GlobalMethods.h"
#import "UserInfo.h"
#import "GameOverDelegate.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    NSMutableArray *heads;
    NSMutableArray *hearts;
    NSMutableArray *rainbows;
    NSMutableArray *coins;
    NSMutableArray *bomb;

    CCLabelTTF *hitsLabel, *timeLabel, *scoreLabel, *ctLabel;
    ccTime totalTime;
    
    int myTime, lives;
    int consecHits, baseScore, moneyEarned;
    float speed;
    
    BOOL gameOver, shake_once, has_bomb;//, gamePaused;
    HUDLayer * _hud;
    id<GameOverDelegate> gameOverDelegate;
    NSArray *botLeft, *botRight, *midLeft, *midRight, *topLeft, *topMid, *topRight;
    //float body_height_now, body_bounding_width, body_bounding_height;
    //CCParticleExplosion *emitter;
}

@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;

// returns a CCScene that contains the HelloWorldLayer as the only child
//+(CCScene *) scene;
+(CCScene *) sceneWithDelegate:(id<GameOverDelegate>)delegate;
- (id)initWithHUD:(HUDLayer *)hud;


@end
