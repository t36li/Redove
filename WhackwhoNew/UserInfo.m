//
//  UserInfo.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize userName, userId, currentLogInType, gender, leftEyePosition, rightEyePosition, mouthPosition, faceRect;

static UserInfo *sharedInstance = nil;

-(id) init {
    if (self = [super init]) {
        self.userId = @"12345678";
    }
    return self;
}

+(UserInfo *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

-(void) clearUserInfo{
    [self setCurrentLogInType:NotLogIn];
    [self setUserId:nil];
    [self setUserName:nil];
    [self setGender:nil];
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)getCroppedImage:(UIImage *)img inRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], rect);
    UIImage *croppedImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImg;
}

-(void)markFaces {
    //UIImage *tempImage = [UserInfo resizeImage:facePicture.image toSize:facePicture.s];
    //UIImageView *tempView = [[UIImageView alloc] initWithImage:tempImage];
    //[tempView setTransform:CGAffineTransformMakeScale(1, -1)];
    
    //UIImage *resizedImage = [AvatarBaseController resizeImage:facePicture.image toSize:avatarView.bounds.size];
    //UIImage *tempImage = [UserInfo resizeImage:usrImg toSize:usrImg.size];
    // draw a CI image with the previously loaded face detection picture
    
    CIImage* image = [CIImage imageWithCGImage:usrImg.CGImage]; // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    //NSArray* features = [detector featuresInImage:image options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:6] forKey:CIDetectorImageOrientation]];
    NSArray* features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face. CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected. Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    /*
     if (features.count <= 0) {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Retake Photo" message:@"Facial features could not be detected!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alertView show];
     }*/
    
    //we need to capture the coordinates of the eyes and mouth
    
    for(CIFaceFeature* faceFeature in features)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        faceView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        faceView.autoresizesSubviews = YES;
        
        // add the new view to create a box around the face
        UIView *leftEyeView, *rightEyeView, *mouthView;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, usrImg.size.width, usrImg.size.height)];
        [containerView addSubview:faceView];
        
        CGRect rectangle = faceFeature.bounds;
        NSString *output = [NSString stringWithFormat:@"Face: x: %f, y: %f, width: %f, height: %f", rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height];
        NSLog(@"%@", output);
        
        faceRect = faceFeature.bounds;
        faceRect.origin.y = usrImg.size.height - (faceRect.origin.y + faceRect.size.height);
        if(faceFeature.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            leftEyeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            leftEyeView.autoresizesSubviews = YES;
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [containerView addSubview:leftEyeView];
            
            NSString *output = [NSString stringWithFormat:@"Left Eye: %f, %f", faceFeature.leftEyePosition.x, faceFeature.leftEyePosition.y];
            NSLog(@"%@", output);
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            // create a UIView with a size based on the width of the face
            rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            rightEyeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            rightEyeView.autoresizesSubviews = YES;
            // change the background color of the eye view
            [rightEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the rightEyeView based on the face
            [rightEyeView setCenter:faceFeature.rightEyePosition];
            // round the corners
            rightEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the new view to the window
            [containerView addSubview:rightEyeView];
            NSString *output = [NSString stringWithFormat:@"Right Eye: %f, %f", faceFeature.rightEyePosition.x, faceFeature.rightEyePosition.y];
            NSLog(@"%@", output);
        }
        if(faceFeature.hasMouthPosition)
        {
            // create a UIView with a size based on the width of the face
            mouthView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            mouthView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            mouthView.autoresizesSubviews = YES;
            // change the background color for the mouth to green
            [mouthView setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
            // set the position of the mouthView based on the face
            [mouthView setCenter:faceFeature.mouthPosition];
            // round the corners
            mouthView.layer.cornerRadius = faceWidth*0.2;
            // add the new view to the window
            [containerView addSubview:mouthView];
            NSString *output = [NSString stringWithFormat:@"Mouth: %f, %f", faceFeature.mouthPosition.x, faceFeature.mouthPosition.y];
            NSLog(@"%@", output);
        }
        [containerView setTransform:CGAffineTransformMakeScale(1, -1)];
        leftEyePosition = leftEyeView.center;
        leftEyePosition.y = usrImg.size.height - leftEyePosition.y;
        rightEyePosition = rightEyeView.center;
        rightEyePosition.y = usrImg.size.height - rightEyePosition.y;
        mouthPosition = mouthView.center;
        mouthPosition.y = usrImg.size.height - mouthPosition.y;

        croppedImage = [UserInfo getCroppedImage:usrImg inRect:faceRect];
    }
    
    //[photoView setTransform:CGAffineTransformMakeScale(1, -1)];
}

-(void) setUserPicture:(UIImage *)img {
    usrImg = [UIImage imageWithCGImage:img.CGImage];
    if (usrImg != nil) {
        [self performSelectorInBackground:@selector(markFaces) withObject:nil];
    }
}

-(UIImage *)getCroppedImage {
    return [UIImage imageWithCGImage:croppedImage.CGImage];
}

-(UIImage *)getAvatarImage {
    if (croppedImage == nil)
        return nil;
    baseController = [[AvatarBaseController alloc] initWithNibName:@"AvatarView" bundle:nil];
    baseController.headView.image = croppedImage;
    UIView *view = baseController.avatarView;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end