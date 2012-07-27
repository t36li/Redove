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

@synthesize pickerReference;
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
    
    outfitView.layer.borderColor = [UIColor yellowColor].CGColor;
    outfitView.layer.borderWidth = 2;
    outfitView.contentMode = UIViewContentModeScaleAspectFit;
    [self.outfitView addSubview:avatarView];
    
    avatarView.frame = outfitView.frame;
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
    UIGraphicsBeginImageContextWithOptions(avatarView.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [avatarView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UserInfo sharedInstance] setGameImage:finalImage];
    
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
/*
-(void)markFaces:(UIImageView *)facePicture
{
    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage]; // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    // we'll iterate through every detected face. CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected. Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for(CIFaceFeature* faceFeature in features)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([facePicture.image CGImage], faceView.frame);
        UIImage *croppedImg = [UIImage imageWithCGImage:imageRef]; 
        CGImageRelease(imageRef);
        self.croppedImage = croppedImg;
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];

        
        // add the new view to create a box around the face
        [idView addSubview:faceView];
        
        
        if(faceFeature.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [idView addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the rightEyeView based on the face
            [leftEye setCenter:faceFeature.rightEyePosition];
            // round the corners
            leftEye.layer.cornerRadius = faceWidth*0.15;
            // add the new view to the window
            [idView addSubview:leftEye];
        }
        if(faceFeature.hasMouthPosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            // change the background color for the mouth to green
            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
            // set the position of the mouthView based on the face
            [mouth setCenter:faceFeature.mouthPosition];
            // round the corners
            mouth.layer.cornerRadius = faceWidth*0.2;
            // add the new view to the window
            [idView addSubview:mouth];
        }
    }
    
    if (features.count > 0) {
        self.validPhoto = facePicture.image;
        acceptPreviewBtn.hidden = NO;
    } else {
        acceptPreviewBtn.hidden = YES;
    }
}
*/
/*
-(IBAction)closePreview:(id)sender {
    [UIView animateWithDuration:0.5f animations:^(void) {
        CGRect frame = containerView.frame;
        frame.origin.y += containerView.frame.size.height;
        containerView.frame = frame;
    }completion:^(BOOL finished) {
        CGRect frame = containerView.frame;
        frame.origin.y = 0;
        containerView.frame = frame;
        containerView.hidden = YES;
        for (UIView *view in idView.subviews) {
            if (view != acceptPreviewBtn && view != closePreviewBtn)
                [view removeFromSuperview];
        }
        //idView.frame = containerView.frame;
        [idView setTransform:CGAffineTransformMakeScale(1, -1)];
    }];
}
*/
@end
