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

@interface CameraOverlayControllerViewController : AvatarBaseController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *pickerReference;
    UIImage *validPhoto, *croppedImage;
    
    IBOutlet UIView *outfitView;    
    id<CameraOverlayControllerViewControllerDelegate> delegate;
}

@property (nonatomic, retain) UIImagePickerController *pickerReference;
@property (nonatomic, retain) IBOutlet UIView *outfitView;
@property (nonatomic, retain) UIImage *validPhoto, *croppedImage;
@property (nonatomic, retain) id<CameraOverlayControllerViewControllerDelegate> delegate;

-(IBAction)takePicture:(id)sender;
-(IBAction)switchCamera:(id)sender;
@end
