//
//  HUDLayer.h
//  MoleIt
//
//  Created by Bob Li on 12-06-30.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "cocos2d.h"
#import "GameOverDelegate.h"

@interface HUDLayer : CCLayer {
    int baseScore, multiplier, consecHits, timeBonus, totalScore;
    id<GameOverDelegate> gameOverDelegate;

}

- (void)showRestartMenu:(BOOL)won:(id<GameOverDelegate>)delegate;
@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;

@end
