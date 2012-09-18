//
//  ChooseWhoScene.h
//  MoleIt
//
//  Created by Bob Li on 12-06-25.
//  Copyright 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ChooseWhoLayer : CCLayer {
    CCSprite *face;
    CCSprite *helmet;
    CCSprite *body;
    CCSprite *hammerHand;
    CCSprite *shieldHand;
}

//@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;
//+(CCScene *) sceneWithDelegate:(id<GameOverDelegate>)delegate;
+(id) scene;
@end
