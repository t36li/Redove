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
    int moneyEarned, multiplier, baseScore;
    
    int selectHeadCount;
    NSMutableArray *arrayOfAllPopups;
    NSArray *arrayOfHits;
    UIImage *head;
}

@property (nonatomic, readwrite) BOOL isGameOver;
@property (nonatomic, readwrite) BOOL isEnabledBackgroundMusic;
@property (nonatomic, readwrite) BOOL isEnabledSoundFX;
@property (nonatomic, readwrite) int difficulty;
@property (nonatomic, readwrite) int moneyEarned;
@property (nonatomic, readwrite) int multiplier;
@property (nonatomic, readwrite) int baseScore;

@property (nonatomic, readwrite) int selectHeadCount;
//@property (nonatomic, copy) NSMutableArray *allHeads;
//@property (nonatomic, copy) NSMutableArray *selectedHeads;
@property (nonatomic, strong) NSMutableArray *arrayOfAllPopups;
@property (nonatomic, strong) NSArray *arrayOfHits;
@property (nonatomic) UIImage *head;

+ (Game *) sharedGame;
- (void) resetGameState;
@end
