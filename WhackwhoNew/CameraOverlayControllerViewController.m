//
//  CameraOverlayControllerViewController.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CameraOverlayControllerViewController.h"

@interface CameraOverlayControllerViewController ()

@end

@implementation CameraOverlayControllerViewController

@synthesize pickerReference, takePicBtn;
@synthesize validPhoto, delegate, outfitView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    outfitView.contentMode = UIViewContentModeScaleAspectFit;
    [self.outfitView addSubview:avatarView];
    
    avatarView.frame = outfitView.frame;
    
    backgroundView.image = [UIImage imageNamed:@"camera frame.png"];
}
    
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [pickerReference dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    UIImage *img = [image fixOrientation];
    photoView.image = nil;
    
    [self.delegate validImageCaptured:img croppedImage:nil];
    [self.pickerReference dismissModalViewControllerAnimated:YES];

}

-(IBAction)takePicture:(id)sender {
    [pickerReference takePicture];
}

-(IBAction)switchCamera:(id)sender {
    if (pickerReference.cameraDevice == UIImagePickerControllerCameraDeviceRear)
        pickerReference.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    else {
        pickerReference.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}
@end
