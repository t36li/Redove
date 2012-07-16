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

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    NSMutableArray *heads;
    NSMutableArray *hearts;
    NSMutableArray *rainbows;
    NSInteger pos[17];
    //Character *head1, *head2, *head3;
    //CCAnimation *laughAnim;
    CCLabelTTF *hitsLabel, *timeLabel, *scoreLabel, *comboLabel;
    int myTime, lives;
    int comboHits, consecHits, baseScore;
    //int numHitOccur, numBombOccur;
    float speed;
    double ts;
    double diff;
    //int hp1, hp2, hp3;
    //int popups;
    //int tempDifficulty;
    ccTime totalTime;
    BOOL gameOver, occupied, gamePaused;
    HUDLayer * _hud;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (id)initWithHUD:(HUDLayer *)hud;


@end
