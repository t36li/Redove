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
#import "SpinnerView.h"

@interface AvatarViewController : AvatarBaseController <CameraOverlayControllerViewControllerDelegate> {
    
    IBOutlet UIView *imageView;
    CameraOverlayControllerViewController *overlay;
    //IBOutlet AvatarView *avatarView;
    UIImagePickerController *cameraController;
    BOOL newPhoto;
    SpinnerView *spinner;
}

@property (nonatomic, retain) IBOutlet UIView *imageView;

@property (nonatomic, retain) SpinnerView *spinner;

@property (nonatomic, retain) CameraOverlayControllerViewController *overlay;
@property (nonatomic, retain) UIImagePickerController *cameraController;
//@property (nonatomic, retain) IBOutlet AvatarView *avatarView;

-(IBAction) startCamera:(id)sender;

@end
