//
//  GameOverDelegate.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-17.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameOverDelegate <NSObject>

-(void)returnToMenu;
-(void)proceedToReview;

@end
