//
//  StatusBarController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GameOverDelegate.h"

@interface StatusBarController : UIViewController <CCDirectorDelegate, GameOverDelegate> {
    IBOutlet UIView *containerView;
}

@property (nonatomic) IBOutlet UIView *containerView;

- (IBAction)Back_Touched:(id)sender;
- (IBAction)Ok_Pressed:(id)sender;

@end
