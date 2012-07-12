//
//  AvatarViewController.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "AvatarViewController.h"
#import "QuartzCore/QuartzCore.h"
#import <CoreImage/CoreImage.h>
#import "UserInfo.h"


@interface AvatarViewController ()

@end

@implementation AvatarViewController

@synthesize imageView, overlay, validPhoto, cameraController;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    cameraController = [[UIImagePickerController alloc] init];
    self.overlay = [[CameraOverlayControllerViewController alloc] initWithNibName:@"CameraOverlayControllerViewController" bundle:nil];
    self.overlay.pickerReference = cameraController;
    self.overlay.delegate = self;
    cameraController.delegate = self.overlay;
    cameraController.navigationBarHidden = YES;
    cameraController.toolbarHidden = YES;
    cameraController.wantsFullScreenLayout = YES;
    
    // Insert the overlay
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        cameraController.showsCameraControls = YES;

        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } else
            cameraController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        cameraController.cameraOverlayView = self.overlay.view;

    } else {
        [cameraController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    //avatarView.frame = imageView.bounds;
    [self.imageView addSubview:avatarView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.avatarView.frame = imageView.bounds;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(IBAction)startCamera:(id)sender {
    [self presentModalViewController:cameraController animated:NO];
}

-(void)validImageCaptured:(UIImage *)image croppedImage:(UIImage *)croppedImg{
    self.validPhoto = image;
    photoView.image = image;
    //self.imageView.image = image;
    UserInfo *usr = [UserInfo sharedInstance];
    usr.usrImg = image;
    usr.croppedImage = croppedImg;
}

@end
