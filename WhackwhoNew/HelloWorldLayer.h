//
//  HelloWorldLayer.h
//  MoleIt
//
//  Created by Bob Li on 12-06-23.
//  Copyright Waterloo 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HUDLayer.h"
#import "Game.h"
#import "Character.h"
//#import "ChooseWhoLayer.h"
#import "GlobalMethods.h"
#import "GameOverDelegate.h"


#define DEFAULT_HEAD_POP_SPEED 1.5
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    NSMutableArray *heads;
    NSMutableArray *rainbows;
    NSMutableArray *coins;
    NSMutableArray *bomb;
    
    //CCLabelTTF *hitsLabel;

    float speed;
    
    BOOL has_bomb;//shake_once
    BOOL stopAnimations;
    NSArray *botLeft, *botRight, *midLeft, *midRight, *topLeft, *topMid, *topRight;

    int level;
    
    NSDictionary *locations;
    CCSpriteBatchNode *splashSheet;
    NSMutableArray *splashFrames;
    

}

@property (nonatomic, strong) NSDictionary *locations;
@property (nonatomic, strong) CCSpriteBatchNode *splashSheet;
@property (nonatomic, strong) NSMutableArray *splashFrames;
@property (nonatomic, readwrite) BOOL stopAnimations;

-(void)setArrayForReview;

@end

@interface HelloWorldScene : CCScene
{
    HUDLayer * _hud;

    HelloWorldLayer *_layer;
    
    int lives;
    NSInteger consecHits, baseScore, moneyEarned;
    
    //score storage
    NSMutableDictionary *dic;
}

@property (nonatomic, strong) HelloWorldLayer *layer;
@property (nonatomic, strong) HUDLayer *hud;

//score methods
- (NSString *) dataFilepath;
- (void) writePlist: (NSString *) whichLbl withUpdate: (int) nmbr;
- (int) readPlist: (NSString *) whichLbl;

-(void)animationCoolDown;
-(void)gameOver:(BOOL)timeout;
-(void)reduceHealth;
-(void)updateScore:(int)score;
-(void)updateConsecHits;
-(void)resetConsecHits;
-(void)updateGold:(int)gold;
-(NSInteger)consecHits;
-(NSInteger)moneyEarned;
-(NSInteger)baseScore;

+(void)setGameOverDelegate:(id<GameOverDelegate>)delegate;
+(id<GameOverDelegate>)gameOverDelegate;

@end


