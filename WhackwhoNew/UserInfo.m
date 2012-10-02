//
//  UserInfo.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize userName, userId, currentLogInType, headId, whackWhoId, gender, leftEyePosition, rightEyePosition, mouthPosition, faceRect, croppedImage, usrImg, currentEquip, storageInv,friendArray;

static UserInfo *sharedInstance = nil;

+(UserInfo *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/avatar.png",docDir];

            if ([fileMgr fileExistsAtPath:pngFilePath]) {
                [sharedInstance setUsrImg:[UIImage imageWithContentsOfFile:pngFilePath]];
            }
        }
    }
    return sharedInstance;
}

-(void) clearUserInfo{
    sharedInstance = nil;
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

-(void)markFaces:(UIImage *)img withDelegate:(id<UserInfoDelegate>)delegate {
    CIImage* image = [CIImage imageWithCGImage:img.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];

    NSArray* features = [detector featuresInImage:image];
    
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
//        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
//        [containerView addSubview:faceView];
        
        CGRect rectangle = faceFeature.bounds;
        NSString *output = [NSString stringWithFormat:@"Face: x: %f, y: %f, width: %f, height: %f", rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height];
        NSLog(@"%@", output);
        
        faceRect = faceFeature.bounds;
        faceRect.origin.y = img.size.height - (faceRect.origin.y + faceRect.size.height);
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
//            [containerView addSubview:leftEyeView];
            
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
//            [containerView addSubview:rightEyeView];
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
//            [containerView addSubview:mouthView];
            NSString *output = [NSString stringWithFormat:@"Mouth: %f, %f", faceFeature.mouthPosition.x, faceFeature.mouthPosition.y];
            NSLog(@"%@", output);
        }
//        [containerView setTransform:CGAffineTransformMakeScale(1, -1)];
        leftEyePosition = leftEyeView.center;
        leftEyePosition.y = img.size.height - leftEyePosition.y;
        rightEyePosition = rightEyeView.center;
        rightEyePosition.y = img.size.height - rightEyePosition.y;
        mouthPosition = mouthView.center;
        mouthPosition.y = img.size.height - mouthPosition.y;

    }
    if ([delegate respondsToSelector:@selector(setUserPictureCompleted)])
        [delegate setUserPictureCompleted];
}

-(void) setUserPicture:(UIImage *)img delegate:(id)sender{
//    usrImg = [UIImage imageWithCGImage:img.CGImage];
    if (usrImg != nil) {
        [self markFaces:img withDelegate:sender];
    }
}


+(UIImage *)getInjuredHead:(UIImage *)headImg {
        
    // Create new offscreen context with desired size
    UIGraphicsBeginImageContext(headImg.size);
    
    // draw img at 0,0 in the context
    [headImg drawAtPoint:CGPointZero];
    
    // assign context to UIImage
    UIImage *outputImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
}

@end