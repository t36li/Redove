//
//  Character.h
//  WhackWho
//
//  Created by Bob Li on 12-06-24.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
@interface Character : CCSprite {
    
    //hit point algorithm....
    //so provide peter the face image + helmet + all other gear
    //to get other gear, we have user's whackID (must previously save this in an array)
    //then according to HP, peter attaches on the face effects
    
    //polish the game
    //1. give user notice when hits the wrong guy (flashing screen on, or vibrate)
    //2. provide little text beside for + pts, -pts, etc..
    //3. swipe bomb to go away
    
    int hp;
    NSString *whackID;

    BOOL tappable;
    BOOL isSelectedHit;
    BOOL didMiss;
    //BOOL sideWaysMove;
    //NSString *imageName;
    
    NSInteger numberOfHits;
    
}
//@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic) int hp;
@property (nonatomic) NSString *whackID;
@property (nonatomic) BOOL tappable;
@property (nonatomic) BOOL isSelectedHit;
@property (nonatomic) BOOL didMiss;
@property (nonatomic) NSInteger numberOfHits;
//@property (nonatomic) CCSprite *body;
//@property (nonatomic) BOOL sideWaysMove;
//@property (nonatomic) int posOccupied;

@end