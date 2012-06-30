//
//  AvatarViewController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayControllerViewController.h"

@interface AvatarViewController : UIViewController <CameraOverlayControllerViewControllerDelegate> {
    
    IBOutlet UIImageView *imageView;
    CameraOverlayControllerViewController *overlay;
    UIImage *validPhoto;
    UIImagePickerController *cameraController;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) CameraOverlayControllerViewController *overlay;
@property (nonatomic, retain) UIImage *validPhoto;
@property (nonatomic, retain) UIImagePickerController *cameraController;

-(IBAction) startCamera:(id)sender;

@end
