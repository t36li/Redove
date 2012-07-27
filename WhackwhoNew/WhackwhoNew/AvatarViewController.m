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

@interface AvatarViewController ()

@end

@implementation AvatarViewController

@synthesize imageView, overlay, cameraController, wtfView;

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
    
    newPhoto = NO;
    
    //set up background image
    GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    [gmethods setViewBackground:FriendList_bg viewSender:self.view];
    
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
    self.wtfView.backgroundColor = [UIColor clearColor];
    
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 10.0;
    [self.imageView addSubview:avatarView];
}

- (void)viewWillAppear:(BOOL)animated {
    /*
    CGRect frame = imageView.bounds;
    CGRect frame2 = avatarView.frame;
    CGRect frame3 = headView.frame;
     */
    self.avatarView.frame = imageView.bounds;
    /*
    CGRect frame4 = imageView.bounds;
    CGRect frame5 = avatarView.frame;
    CGRect frame6 = headView.frame;
     */
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
    //photoView.image = image;
    //self.imageView.image = image;
    UserInfo *usr = [UserInfo sharedInstance];
    
    if (image != nil) {
        //photoView.image = image;
        [usr setUserPicture:image];
        newPhoto = YES;
    }

}

-(void)viewDidAppear:(BOOL)animated {
    if (newPhoto) {
        // Create a new image view, from the image made by our gradient metho
        //[self performSelectorInBackground:@selector(markFaces:) withObject:photoView];
        
        newPhoto = NO;
    }
}

-(IBAction) addPicture:(id)sender {
    headView.image = [[UserInfo sharedInstance] getCroppedImage];
}
@end
