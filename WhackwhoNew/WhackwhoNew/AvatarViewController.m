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

@synthesize imageView, cameraController, photoView;

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
	// Do any additional setup after loading the view.
    cameraController = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        [cameraController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else 
    {
        [cameraController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [cameraController setDelegate:self];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationController.navigationBarHidden = NO;
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

-(IBAction) startCamera:(id)sender {
    [self presentModalViewController:cameraController animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    //[self.imageView setImage:image];
    
    self.imageView.image = image;
    
    // Execute the method used to markFaces in background
    [self performSelectorInBackground:@selector(markFaces:) withObject:imageView];
    
    // flip image on y-axis to match coordinate system used by core image
    [imageView setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // flip the entire window to make everything right side up
    [photoView setTransform:CGAffineTransformMakeScale(1, -1)];
    
    [self dismissModalViewControllerAnimated:YES];
}

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
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
        [photoView addSubview:faceView];
        
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
            [photoView addSubview:leftEyeView];
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
            [photoView addSubview:leftEye];
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
            [photoView addSubview:mouth];
        }
    }
}

@end
