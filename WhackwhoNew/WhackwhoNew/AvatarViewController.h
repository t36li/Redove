//
//  AvatarViewController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayControllerViewController.h"
#import "AvatarBaseController.h"
#import "GlobalMethods.h"
#import "QuartzCore/QuartzCore.h"
#import <CoreImage/CoreImage.h>
#import <RestKit/RestKit.h>
#import "UserInfoDelegate.h"
#import "LoadViewController.h"
#import "SpinnerView.h"
#import "FaceEffectsController.h"

@interface AvatarViewController : AvatarBaseController <CameraOverlayControllerViewControllerDelegate,RKObjectLoaderDelegate,UserInfoDelegate, UIGestureRecognizerDelegate> {
    
    IBOutlet UIView *imageView;
    IBOutlet UIView *wtfView;
    CameraOverlayControllerViewController *overlay;
    //IBOutlet AvatarView *avatarView;
    UIImagePickerController *cameraController;
    BOOL newPhoto;
    
    CGFloat _xlastScale;
    CGFloat _ylastScale;
}
@property (nonatomic) IBOutlet UIView *wtfView;

@property (nonatomic) IBOutlet UIView *imageView;

@property (nonatomic, strong) CameraOverlayControllerViewController *overlay;
@property (nonatomic) UIImagePickerController *cameraController;
//@property (nonatomic, retain) IBOutlet AvatarView *avatarView;


-(IBAction) startCamera:(id)sender;
-(IBAction) addPicture:(id)sender;
-(IBAction) Back:(id)sender;
-(IBAction) Change_Skin:(id)sender;
-(IBAction) goToSample:(id)sender;

@end
