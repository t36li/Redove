//
//  Game.h
//  MoleIt
//
//  Created by Bob Li on 12-06-30.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"
@class CocosViewController;

@interface Game : NSObject {
    BOOL isGameOver;
    BOOL isEnabledBackgroundMusic;
    BOOL isEnabledSoundFX;
    
    BOOL readyToStart;
    BOOL unlocked_new_bg;
    int bgs_to_random; //levelsunlocked used as bool
    int moneyEarned, baseScore;
    
    int selectHeadCount;
    NSMutableArray *arrayOfAllPopups;
    NSArray *arrayOfHits;
    UIImage *head;
    
    UIViewController *gameView;
    
    NSArray *friendArray;
}

@property (nonatomic, readwrite) BOOL isGameOver;
@property (nonatomic, readwrite) BOOL isEnabledBackgroundMusic;
@property (nonatomic, readwrite) BOOL isEnabledSoundFX;
@property (nonatomic, readwrite) BOOL unlocked_new_bg;
@property (nonatomic, readwrite) int bgs_to_random;
@property (nonatomic, readwrite) int moneyEarned;
@property (nonatomic, readwrite) int multiplier;
@property (nonatomic, readwrite) int baseScore;
@property (nonatomic, readwrite) BOOL readyToStart;

@property (nonatomic, readwrite) int selectHeadCount;
//@property (nonatomic, copy) NSMutableArray *allHeads;
//@property (nonatomic, copy) NSMutableArray *selectedHeads;
@property (nonatomic, strong) NSMutableArray *arrayOfAllPopups;
@property (nonatomic, strong) NSArray *arrayOfHits;
@property (nonatomic) UIImage *head;
@property (nonatomic, strong) UIViewController *gameView;
@property (nonatomic) NSArray *friendArray;

+ (Game *) sharedGame;
- (void) resetGameState;
@end
