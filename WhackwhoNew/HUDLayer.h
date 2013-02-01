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
    CCLabelTTF *timeLabel, *scoreLabel, *hitsLabel, *gameOverLabel;
    CCMenu *pauseMenu;
    BOOL gameOver;
    CCSpriteBatchNode *hud_spritesheet;
    ccTime myTime;
    int lives;
}

-(void)resetTimer;
-(void)removeHeart;
-(void)updateScore:(NSInteger)score;
-(void)updateHits:(NSInteger)hits;
-(void)showGameOverLabel:(NSString *)msg;

//- (void)showPauseMenu:(id<GameOverDelegate>)delegate;
//@property (nonatomic, retain) id<GameOverDelegate> gameOverDelegate;

@end
