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
@synthesize validPhoto, delegate, croppedImage, outfitView;

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
    // Do any additional setup after loading the view from its nib.
    
//    outfitView.layer.borderColor = [UIColor yellowColor].CGColor;
//    outfitView.layer.borderWidth = 2;
    outfitView.contentMode = UIViewContentModeScaleAspectFit;
    [self.outfitView addSubview:avatarView];
    
    avatarView.frame = outfitView.frame;
    
//    UserInfo *usr = [UserInfo sharedInstance];
    
//    if ([usr.gender isEqualToString:@"male"]) {
//        backgroundView.image = [UIImage imageNamed:@"standard blue.png"];
//    } else {
//        backgroundView.image = [UIImage imageNamed:@"standard pink.png"];
//    }
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
    [pickerReference dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    /*
    UIImage *newImage = [AvatarBaseController resizeImage:image toSize:outfitView.frame.size];


    CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], headView.frame);
    UIImage *croppedImg = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    */
    
    UIImage *img = [image fixOrientation];
    UIImage *resizedImage = [AvatarBaseController resizeImage:img toSize:avatarView.frame.size];
    UIImage *croppedImg = [AvatarBaseController cropImage:resizedImage inRect:headView.frame];
    
    headView.image = croppedImg;
    /*
    UIGraphicsBeginImageContextWithOptions(avatarView.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [avatarView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UserInfo sharedInstance] setGameImage:finalImage];
     */
    photoView.image = nil;
    
    [self.delegate validImageCaptured:img croppedImage:croppedImg];
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
