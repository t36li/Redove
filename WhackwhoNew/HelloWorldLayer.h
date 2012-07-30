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
#import "Character.h"
#import "HUDLayer.h"
#import "Game.h"
#import "ChooseWhoLayer.h"
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
    //CCAnimation *laughAnim;
    CCLabelTTF *hitsLabel, *timeLabel, *scoreLabel, *comboLabel;
    ccTime totalTime;
    int myTime, lives;
    int consecHits, baseScore;
    //int numHitOccur, numBombOccur;
    float speed;
    BOOL gameOver, occupied, gamePaused;
    HUDLayer * _hud;
    id<GameOverDelegate> gameOverDelegate;
    NSArray *botLeft, *botRight, *midLeft, *midRight, *topLeft, *topMid, *topRight;
    //float body_height_now, body_bounding_width, body_bounding_height;
    //CCParticleExplosion *emitter;
}

@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene *) sceneWithDelegate:(id<GameOverDelegate>)delegate;
- (id)initWithHUD:(HUDLayer *)hud;


@end
