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
@synthesize multiplier, timeBonus, consecHits, baseScore;
@synthesize friendList;
@synthesize selectedHeads;
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
        self.multiplier = 0;
        self.timeBonus = 0;
        self.consecHits = 0;
        self.baseScore = 0;
        friendList = [[NSMutableArray alloc] init];
        selectedHeads = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    // TODO: Dealloc
    [friendList release];
    [selectedHeads release];
    [super dealloc];
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
    return [[self sharedGame] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}

#pragma mark -
/////////////////////
#pragma mark Reset

- (void) resetGameState {
    [self setIsGameOver:NO];
    [self setIsEnabledBackgroundMusic:YES];
    [self setIsEnabledSoundFX:YES];
    [self setDifficulty:1];
    [self setMultiplier:0];
    [self setTimeBonus:0];
    [self setConsecHits:0];
    [self setBaseScore:0];
    //[biglist removeAllObjects];
    //[selectedHeads removeAllObjects];
}

@end
