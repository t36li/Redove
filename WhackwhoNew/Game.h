//
//  Game.h
//  MoleIt
//
//  Created by Bob Li on 12-06-30.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Game : NSObject {
    BOOL isGameOver;
    BOOL isEnabledBackgroundMusic;
    BOOL isEnabledSoundFX;
    int difficulty;
    int multiplier, timeBonus, consecHits, baseScore;
    NSMutableArray *friendList, *selectedHeads;
    UIImage *head;
}

@property (nonatomic, readwrite) BOOL isGameOver;
@property (nonatomic, readwrite) BOOL isEnabledBackgroundMusic;
@property (nonatomic, readwrite) BOOL isEnabledSoundFX;
@property (nonatomic, readwrite) int difficulty;
@property (nonatomic, readwrite) int multiplier;
@property (nonatomic, readwrite) int timeBonus;
@property (nonatomic, readwrite) int consecHits;
@property (nonatomic, readwrite) int baseScore;
@property (nonatomic) NSMutableArray *friendList;
@property (nonatomic) NSMutableArray *selectedHeads;
@property (nonatomic) UIImage *head;


+ (Game *) sharedGame;
- (void) resetGameState;
@end
