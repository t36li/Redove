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
    //int hp;
    //int posOccupied;
    BOOL tappable;
    BOOL isSelectedHit;
    BOOL didMiss;
    //CCSprite *body;
    //BOOL sideWaysMove;
    //NSString *imageName;
    
}
//@property (nonatomic, retain) CCSprite *sprite;
//@property (nonatomic) int hp;
@property (nonatomic) BOOL tappable;
@property (nonatomic) BOOL isSelectedHit;
@property (nonatomic) BOOL didMiss;
//@property (nonatomic) CCSprite *body;
//@property (nonatomic) BOOL sideWaysMove;
//@property (nonatomic) int posOccupied;
//@property (nonatomic) NSString *imageName;

@end