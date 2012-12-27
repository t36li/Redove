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
#import "StatusCocosDelegate.h"
#import <RestKit/RestKit.h>

@interface StatusBarController : UIViewController<RKObjectLoaderDelegate, UIAlertViewDelegate> {// <CCDirectorDelegate, GameOverDelegate> {
    IBOutlet UIView *containerView;
    
    
    //define containerView subviews
    IBOutlet UIImageView *faceView;
    IBOutlet UIImageView *bodyView;
}

//define delegate
//@property (nonatomic, strong) id<StatusCocosDelegate> cocosDelegate;

//define the container view that stores the cocos2d view
@property (nonatomic, strong) IBOutlet UIView *containerView;

//define containerView subviews
@property (nonatomic) IBOutlet UIImageView *faceView;
@property (nonatomic) IBOutlet UIImageView *bodyView;

- (IBAction)Back_Touched:(id)sender;
- (IBAction)Ok_Pressed:(id)sender;
- (void)updateDB;
- (IBAction)publish_touched:(id)sender;

@end
