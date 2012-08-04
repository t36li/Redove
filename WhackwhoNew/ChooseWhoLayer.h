//
//  ChooseWhoScene.h
//  MoleIt
//
//  Created by Bob Li on 12-06-25.
//  Copyright 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "CCRobot.h"
#import "GameOverDelegate.h"

@interface ChooseWhoLayer : CCLayer {
    //CCRobot *robot;
    CCRobot *baby;
    id<GameOverDelegate> gameOverDelegate;
}

@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;
+(CCScene *) sceneWithDelegate:(id<GameOverDelegate>)delegate;
+(CCScene *) scene;
@end
