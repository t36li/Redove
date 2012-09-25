//
//  AvatarBaseController.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "AvatarBaseController.h"

@interface AvatarBaseController ()

@end

@implementation AvatarBaseController

@synthesize backgroundView, headView, photoView, avatarView, markingView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
        [self loadAvatarView];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // initialize what you need here
        [self loadAvatarView];
    }
    
    return self;
}

- (void)loadAvatarView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AvatarView" owner:self options:nil];
    self.avatarView = [arr objectAtIndex:0];
    NSArray *subviews = avatarView.subviews;
    self.photoView = [subviews objectAtIndex:0];
    self.headView = [subviews objectAtIndex:1];
    self.markingView = [subviews objectAtIndex:2];
    self.backgroundView = [subviews objectAtIndex:3];
    
    [avatarView bringSubviewToFront:markingView];    
    [avatarView bringSubviewToFront:backgroundView];
    [avatarView sendSubviewToBack:headView];
    [avatarView sendSubviewToBack:photoView];

    avatarView.autoresizesSubviews = YES;
    
//    CGSize rect = headView.frame.size;
//    CGSize rect2 = backgroundView.frame.size;
//    CGSize rect3 = photoView.frame.size;
//    UIImage *img = headView.image;
//    UIImage *img2 = backgroundView.image;
//    UIImage *img3 = photoView.image;
     
//    photoView.layer.borderColor = [UIColor blueColor].CGColor;
//    photoView.layer.borderWidth = 15;
//    headView.layer.borderColor = [UIColor redColor].CGColor;
//    headView.layer.borderWidth = 15;
//    backgroundView.layer.borderColor = [UIColor purpleColor].CGColor;
//    backgroundView.layer.borderWidth = 10;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+(UIImage *)cropImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    // or use the UIImage wherever you like
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//
//-(void)markFaces:(UIImageView *)facePicture
//{
//    UIImage *tempImage = [AvatarBaseController resizeImage:[UIImage imageWithCGImage:facePicture.image.CGImage] toSize:markingView.frame.size];
//    
//    //UIImageView *tempView = [[UIImageView alloc] initWithImage:tempImage];
//    //[tempView setTransform:CGAffineTransformMakeScale(1, -1)];
//
//    //UIImage *resizedImage = [AvatarBaseController resizeImage:facePicture.image toSize:avatarView.bounds.size];
//    
//    // draw a CI image with the previously loaded face detection picture
//    CIImage* image = [CIImage imageWithCGImage:tempImage.CGImage]; // create a face detector - since speed is not an issue we'll use a high accuracy
//    // detector
//    
//    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
//                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
//    
//    // create an array containing all the detected faces from the detector
//    //NSArray* features = [detector featuresInImage:image options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:6] forKey:CIDetectorImageOrientation]];
//    NSArray* features = [detector featuresInImage:image];
//    
//    // we'll iterate through every detected face. CIFaceFeature provides us
//    // with the width for the entire face, and the coordinates of each eye
//    // and the mouth if detected. Also provided are BOOL's for the eye's and
//    // mouth so we can check if they already exist.
//    /*
//    if (features.count <= 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Retake Photo" message:@"Facial features could not be detected!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }*/
//    
//    //we need to capture the coordinates of the eyes and mouth
//    
//    for(CIFaceFeature* faceFeature in features)
//    {
//        // get the width of the face
//        CGFloat faceWidth = faceFeature.bounds.size.width;
//        
//        // create a UIView using the bounds of the face
//        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
//        
//        // add a border around the newly created UIView
//        faceView.layer.borderWidth = 1;
//        faceView.layer.borderColor = [[UIColor redColor] CGColor];
//        faceView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        faceView.autoresizesSubviews = YES;
//        
//        // add the new view to create a box around the face
//        [markingView addSubview:faceView];
//        CGRect rectangle = faceFeature.bounds;
//        NSString *output = [NSString stringWithFormat:@"Face: x: %f, y: %f, width: %f, height: %f", rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height];
//        NSLog(@"%@", output);
//        
//        UIView *leftEyeView, *rightEyeView, *mouthView;
//        
//        if(faceFeature.hasLeftEyePosition)
//        {
//            // create a UIView with a size based on the width of the face
//            leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
//            leftEyeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            leftEyeView.autoresizesSubviews = YES;
//            // change the background color of the eye view
//            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            // set the position of the leftEyeView based on the face
//            [leftEyeView setCenter:faceFeature.leftEyePosition];
//            // round the corners
//            leftEyeView.layer.cornerRadius = faceWidth*0.15;
//            // add the view to the window
//            [markingView addSubview:leftEyeView];
//            NSString *output = [NSString stringWithFormat:@"Left Eye: %f, %f", faceFeature.leftEyePosition.x, faceFeature.leftEyePosition.y];
//            NSLog(@"%@", output);
//        }
//        
//        if(faceFeature.hasRightEyePosition)
//        {
//            // create a UIView with a size based on the width of the face
//            rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
//            rightEyeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            rightEyeView.autoresizesSubviews = YES;
//            // change the background color of the eye view
//            [rightEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            // set the position of the rightEyeView based on the face
//            [rightEyeView setCenter:faceFeature.rightEyePosition];
//            // round the corners
//            rightEyeView.layer.cornerRadius = faceWidth*0.15;
//            // add the new view to the window
//            [markingView addSubview:rightEyeView];
//            NSString *output = [NSString stringWithFormat:@"Right Eye: %f, %f", faceFeature.rightEyePosition.x, faceFeature.rightEyePosition.y];
//            NSLog(@"%@", output);
//        }
//        if(faceFeature.hasMouthPosition)
//        {
//            // create a UIView with a size based on the width of the face
//            mouthView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
//            mouthView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            mouthView.autoresizesSubviews = YES;
//            // change the background color for the mouth to green
//            [mouthView setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
//            // set the position of the mouthView based on the face
//            [mouthView setCenter:faceFeature.mouthPosition];
//            // round the corners  
//            mouthView.layer.cornerRadius = faceWidth*0.2;
//            // add the new view to the window
//            [markingView addSubview:mouthView];
//            NSString *output = [NSString stringWithFormat:@"Mouth: %f, %f", faceFeature.mouthPosition.x, faceFeature.mouthPosition.y];
//            NSLog(@"%@", output);
//        }
//    }
//    
//    [markingView setTransform:CGAffineTransformMakeScale(1, -1)];
//    //[photoView setTransform:CGAffineTransformMakeScale(1, -1)];
//
//}


@end
