//
//  CocosViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "GameOverDelegate.h"
#import "MainMenuDelegate.h"
#import "StatusViewLayer.h"
#import "LoadLayer.h"
#import "CocosViewControllerDelegate.h"

@interface CocosViewController : UIViewController <CCDirectorDelegate, GameOverDelegate, MainMenuDelegate> {
    id<CocosViewControllerDelegate> delegate;
}

@property (nonatomic) id<CocosViewControllerDelegate> delegate;


@end
