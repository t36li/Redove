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
   // BOOL isGameOver;
   // BOOL isEnabledBackgroundMusic;
   // BOOL isEnabledSoundFX;
    
    BOOL readyToStart;
    BOOL unlocked_new_bg, unlocked_new_hammer;
    BOOL isPaused;
    int bgs_to_random, hammers_to_random;
    int baseScore;
    int randomed_body;
    int max_combo;
    
    int selectHeadCount;
    NSMutableArray *arrayOfAllPopups;
    NSArray *arrayOfHits;
    //UIImage *head;
    
    UIViewController *gameView;
    
    NSArray *friendArray;
}

//@property (nonatomic, readwrite) BOOL isGameOver;
//@property (nonatomic, readwrite) BOOL isEnabledBackgroundMusic;
//@property (nonatomic, readwrite) BOOL isEnabledSoundFX;
@property (nonatomic, readwrite) BOOL unlocked_new_bg;
@property (nonatomic, readwrite) BOOL unlocked_new_hammer;
@property (nonatomic, readwrite) BOOL isPaused;
@property (nonatomic, readwrite) int bgs_to_random;
@property (nonatomic, readwrite) int hammers_to_random;
@property (nonatomic, readwrite) int baseScore;
@property (nonatomic, readwrite) int randomed_body;
@property (nonatomic, readwrite) int max_combo;

@property (nonatomic, readwrite) BOOL readyToStart;

@property (nonatomic, readwrite) int selectHeadCount;
@property (nonatomic, strong) NSMutableArray *arrayOfAllPopups;
@property (nonatomic, strong) NSArray *arrayOfHits;
@property (nonatomic, strong) UIViewController *gameView;
@property (nonatomic) NSArray *friendArray;

+ (Game *) sharedGame;
- (void) resetGameState;
@end
