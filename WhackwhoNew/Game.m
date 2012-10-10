//
//  Game.m
//  MoleIt
//
//  Created by Bob Li on 12-06-30.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "Game.h"

static Game *sharedGame = nil;

@implementation Game

@synthesize isGameOver;
@synthesize isEnabledBackgroundMusic;
@synthesize isEnabledSoundFX;
@synthesize difficulty;
@synthesize moneyEarned, consecHits, baseScore;
//@synthesize allHeads;

@synthesize selectHeadCount;
//@synthesize selectedHeads;
@synthesize arrayOfAllPopups;
@synthesize head;

#pragma mark -
/////////////////////
#pragma mark Override

- (id)init {
    self = [super init];
    if (self != nil) {
        self.isGameOver = NO;
        self.isEnabledBackgroundMusic = YES;
        self.isEnabledSoundFX = YES;
        self.difficulty = 1;
        self.moneyEarned = 0;
        self.consecHits = 0;
        self.baseScore = 0;
        //allHeads = [[NSMutableArray alloc] init];
        //selectedHeads = [[NSMutableArray alloc] init];
        selectHeadCount = 0;
        arrayOfAllPopups = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
/////////////////////
#pragma mark Singleton

+ (Game *) sharedGame {
    @synchronized(self) {
        if(nil == sharedGame)
            sharedGame = [[super allocWithZone:NULL] init];
    }
    return sharedGame;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedGame];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

/*- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}*/

#pragma mark -
/////////////////////
#pragma mark Reset

- (void) resetGameState {
    [self setIsGameOver:NO];
    [self setIsEnabledBackgroundMusic:YES];
    [self setIsEnabledSoundFX:YES];
    [self setDifficulty:0];
    [self setMoneyEarned:0];
    [self setConsecHits:0];
    [self setBaseScore:0];
    //[allHeads removeAllObjects];
    //[selectedHeads removeAllObjects];
    [self setSelectHeadCount:0];
    [arrayOfAllPopups removeAllObjects];
}

@end
