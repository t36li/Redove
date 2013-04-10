//
//  StatusBarController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCocosDelegate.h"
#import <RestKit/RestKit.h>
#import "CameraOverlayControllerViewController.h"
#import "CameraOverlayControllerViewControllerDelegate.h"
#import "CustomDrawViewController.h"

//@class WEPopoverController;

@interface StatusViewController : UIViewController<RKObjectLoaderDelegate, UIAlertViewDelegate> {
    
    IBOutlet UILabel *popularity_lbl;
    IBOutlet UILabel *high_score_lbl;
    IBOutlet UILabel *games_played_lbl;
    IBOutlet UILabel *unlocks_lbl;
    
    //define containerView subviews
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *faceView;
    IBOutlet UIImageView *bodyView;
    
    //score storage
    NSDictionary *dic;
    
    CGFloat _xlastScale;
    CGFloat _ylastScale;
        
    //WEPopoverController *popoverController;
    UIView *popUp;
    BOOL shown;
}

//define delegate
//@property (nonatomic, strong) id<StatusCocosDelegate> cocosDelegate;

//define the container view that stores the cocos2d view
@property (nonatomic, strong) IBOutlet UIView *containerView;

//define containerView subviews
@property (nonatomic) IBOutlet UIImageView *faceView;
@property (nonatomic) IBOutlet UIImageView *bodyView;

@property (nonatomic) IBOutlet UILabel *popularity_lbl;
@property (nonatomic) IBOutlet UILabel *high_score_lbl;
@property (nonatomic) IBOutlet UILabel *games_played_lbl;
@property (nonatomic) IBOutlet UILabel *unlocks_lbl;

//@property (nonatomic, strong) WEPopoverController *popoverController;

//class methods
- (NSString *) dataFilepath;
- (NSNumber *) readPlist: (NSString *) whichLbl;

- (IBAction)Back_Touched:(id)sender;
- (IBAction)Ok_Pressed:(id)sender;
- (IBAction)Help_Pressed:(id)sender;
//- (void)updateDB;
- (IBAction)publish_touched:(id)sender;
- (IBAction)pushCamera:(id)sender;
- (IBAction)deletePlist:(id)sender;

@end
