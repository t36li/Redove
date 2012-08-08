//
//  StatusViewLayer.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "StatusCocosDelegate.h"

@interface StatusViewLayer : CCLayer<StatusCocosDelegate> {
    CCSprite *face;
    CCSprite *helmet;
    CCSprite *body;
    CCSprite *left_hand;
    CCSprite *right_hand;
}
+(id) scene;

@end