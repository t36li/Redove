//
//  GameViewController.h
//  WhackwhoNew
//
//  Created by Peter on 2012-10-23.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GameOverDelegate.h"

@interface GameViewController : UIViewController <CCDirectorDelegate, GameOverDelegate> {
}

@end
