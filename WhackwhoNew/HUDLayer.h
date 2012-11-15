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
    //int baseScore, multiplier, coin;
    //id<GameOverDelegate> gameOverDelegate;
    NSMutableArray *hearts;
    CCLabelTTF *timeLabel, *scoreLabel;
    CCMenu *pauseMenu;
    BOOL gameOver;
    CCSprite *scoreboard;
    ccTime myTime;
    int lives;
}

-(void)resetTimer;
-(void)removeHeart;
-(void)updateScore:(NSInteger)score;

//- (void)showPauseMenu:(id<GameOverDelegate>)delegate;
//@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;

@end
