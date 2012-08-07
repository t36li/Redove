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

@interface AvatarViewController : AvatarBaseController <CameraOverlayControllerViewControllerDelegate> {
    
    IBOutlet UIView *imageView;
    IBOutlet UIView *wtfView;
    CameraOverlayControllerViewController *overlay;
    //IBOutlet AvatarView *avatarView;
    UIImagePickerController *cameraController;
    BOOL newPhoto;
}
@property (nonatomic) IBOutlet UIView *wtfView;

@property (nonatomic) IBOutlet UIView *imageView;

@property (nonatomic, strong) CameraOverlayControllerViewController *overlay;
@property (nonatomic) UIImagePickerController *cameraController;
//@property (nonatomic, retain) IBOutlet AvatarView *avatarView;

-(IBAction) startCamera:(id)sender;
-(IBAction) addPicture:(id)sender;
- (IBAction)Back_Touched:(id)sender;

@end
