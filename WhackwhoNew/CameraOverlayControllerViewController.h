//
//  CameraOverlayControllerViewController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayControllerViewControllerDelegate.h"
#import "AvatarBaseController.h"
#import "QuartzCore/QuartzCore.h"

@interface CameraOverlayControllerViewController : AvatarBaseController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *pickerReference;
    UIImage *validPhoto, *croppedImage;
    
    IBOutlet UIView *outfitView;
    IBOutlet UIButton *takePicBtn;
    id<CameraOverlayControllerViewControllerDelegate> delegate;
}

@property (nonatomic) UIImagePickerController *pickerReference;
@property (nonatomic) IBOutlet UIView *outfitView;
@property (nonatomic) IBOutlet UIButton *takePicBtn;
@property (nonatomic) UIImage *validPhoto, *croppedImage;
@property (nonatomic) id<CameraOverlayControllerViewControllerDelegate> delegate;

-(IBAction)takePicture:(id)sender;
-(IBAction)switchCamera:(id)sender;
@end
