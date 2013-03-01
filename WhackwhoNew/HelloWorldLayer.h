//
//  HelloWorldLayer.h
//  MoleIt
//
//  Created by Bob Li on 12-06-23.
//  Copyright Waterloo 2012. All rights reserved.
//


#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>

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
    NSMutableArray *sve; //special visual effects after certain consec hits
    //NSMutableArray *coins;
    //NSMutableArray *bomb;
    
    float speed;
    int level;
    int x_min, x_max, y_min, y_max;
    int sve_displayed;

    //BOOL has_bomb;
    
    NSDictionary *locations;
    CCSpriteBatchNode *baselayer;
    NSMutableArray *splashFrames, *bodyFrames;
    NSMutableArray *objectsCantCollide;
    
    CCSprite *spritePosTest;
    
    SystemSoundID _rightHammerSound, _wrongHammerSound, _fireSound;
}

@property (nonatomic, strong) NSDictionary *locations;
@property (nonatomic, strong) CCSpriteBatchNode *baselayer;
@property (nonatomic, strong) NSMutableArray *splashFrames;
@property (nonatomic, strong) NSMutableArray *bodyFrames;
@property (nonatomic, readwrite) BOOL stopAnimations;

@property (nonatomic, readwrite) int x_min;
@property (nonatomic, readwrite) int x_max;
@property (nonatomic, readwrite) int y_min;
@property (nonatomic, readwrite) int y_max;

-(void)setArrayForReview;
-(void)finalCleanup;

@end

@interface HelloWorldScene : CCScene
{
    HUDLayer * _hud;

    HelloWorldLayer *_layer;
    
    int lives;
    NSInteger consecHits, baseScore; //moneyEarned;
    NSInteger max_consecHits;
    
    NSMutableDictionary *dic;     //score storage
}

@property (nonatomic, strong) HelloWorldLayer *layer;
@property (nonatomic, strong) HUDLayer *hud;

//score methods
- (NSString *) dataFilepath;
- (void) writePlist: (NSString *) whichLbl withUpdate: (int) nmbr;
- (int) readPlist: (NSString *) whichLbl;

-(void)gameOver:(BOOL)timeout;
-(void)reduceHealth;
-(void)updateScore:(int)score;
-(void)updateConsecHits;
-(void)resetConsecHits;
-(void)compareConsecHits;
//-(void)updateGold:(int)gold;
-(NSInteger)consecHits;
//-(NSInteger)moneyEarned;
-(NSInteger)baseScore;
-(void)finalCleanup;

+(void)setGameOverDelegate:(id<GameOverDelegate>)delegate;
+(id<GameOverDelegate>)gameOverDelegate;

@end


