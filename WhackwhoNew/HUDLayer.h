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
    int baseScore, multiplier, coin;
    id<GameOverDelegate> gameOverDelegate;

}

- (void)showPauseMenu:(id<GameOverDelegate>)delegate;
@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;

@end
