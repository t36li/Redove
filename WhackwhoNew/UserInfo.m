//
//  UserInfo.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize userName, userId, currentLogInType, headId, whackWhoId, gender, leftEyePosition, rightEyePosition, mouthPosition, faceRect, croppedImage, usrImg, currentEquip, storageInv,friendArray,myFriendPlayers;//,profileImageView;

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

+(UIImage *)getInjuredHead:(UIImage *)headImg {
        
    // Create new offscreen context with desired size
    UIGraphicsBeginImageContext(headImg.size);
    
    // draw img at 0,0 in the context
    [headImg drawAtPoint:CGPointZero];
    
    // assign context to UIImage
    UIImage *outputImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return outputImg;
}

-(void)LogInTypeChanged:(LogInType) type{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:LogInAs];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setCurrentLogInType:type];
}

-(void)closeInstance{
    sharedInstance = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end