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

@interface StatusBarController : UIViewController<RKObjectLoaderDelegate, UIAlertViewDelegate, CameraOverlayControllerViewControllerDelegate> {
    
    IBOutlet UILabel *popularity_lbl;
    IBOutlet UILabel *high_score_lbl;
    IBOutlet UILabel *total_gp_lbl;
    IBOutlet UILabel *total_gold_lbl;
    
    //define containerView subviews
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *faceView;
    IBOutlet UIImageView *bodyView;
    
    //score storage
    NSDictionary *dic;
    
    CameraOverlayControllerViewController *overlay;
    //IBOutlet AvatarView *avatarView;
    UIImagePickerController *cameraController;
    UIImageView *cameraOverlayView;
    
    CGFloat _xlastScale;
    CGFloat _ylastScale;
    
    UIImage *tempPhoto;
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
@property (nonatomic) IBOutlet UILabel *total_gp_lbl;
@property (nonatomic) IBOutlet UILabel *total_gold_lbl;
@property (nonatomic, strong) CameraOverlayControllerViewController *overlay;
@property (nonatomic, strong) UIImagePickerController *cameraController;
@property (nonatomic, strong) UIImageView *cameraOverlayView;


//class methods
- (NSString *) dataFilepath;
- (NSString *) readPlist: (NSString *) whichLbl;

- (IBAction)Back_Touched:(id)sender;
- (IBAction)Ok_Pressed:(id)sender;
//- (void)updateDB;
- (IBAction)publish_touched:(id)sender;
-(IBAction)pushCamera:(id)sender;

@end
