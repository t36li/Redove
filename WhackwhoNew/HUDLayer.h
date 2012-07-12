//
//  HUDLayer.h
//  MoleIt
//
//  Created by Bob Li on 12-06-30.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    int baseScore, multiplier, consecHits, timeBonus, totalScore;
}

- (void)showRestartMenu:(BOOL)won;

@end
