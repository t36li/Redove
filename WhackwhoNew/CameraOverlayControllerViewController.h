//
//  CameraOverlayControllerViewController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CameraOverlayControllerViewControllerDelegate.h"

@interface CameraOverlayControllerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *pickerReference;
    UIImage *validPhoto, *croppedImage;

    IBOutlet UIButton *switchCameraBtn, *takeBtn, *closePreviewBtn, *acceptPreviewBtn;
    
    IBOutlet UIView *containerView, *idView;
    
    id<CameraOverlayControllerViewControllerDelegate> delegate;
}

@property (nonatomic, retain) UIImagePickerController *pickerReference;
@property (nonatomic, retain) IBOutlet UIButton *switchCameraBtn, *takeBtn, *closePreviewBtn, *acceptPreviewBtn;
@property (nonatomic, retain) IBOutlet UIView *containerView, *idView; 
@property (nonatomic, retain) UIImage *validPhoto, *croppedImage;
@property (nonatomic, retain) id<CameraOverlayControllerViewControllerDelegate> delegate;

-(IBAction)takePicture:(id)sender;
-(IBAction)switchCamera:(id)sender;
-(IBAction)closePreview:(id)sender;
-(IBAction)acceptPreview:(id)sender;
@end
