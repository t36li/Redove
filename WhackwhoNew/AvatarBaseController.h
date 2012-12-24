//
//  AvatarBaseController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+fixOrientation.h"
#import "UserInfo.h"
#import "QuartzCore/QuartzCore.h"

@interface AvatarBaseController : UIViewController
{
    UIView *avatarView, *markingView, *faceEffectsView;
    UIImageView *backgroundView, *headView, *photoView;
    CGPoint leftEyePos, rightEyePos, mouthPos;
}

@property (nonatomic) UIImageView *backgroundView, *headView, *photoView;
@property (nonatomic) UIView *avatarView, *markingView, *faceEffectsView;

+(UIImage *)resizeImage:(UIImage *)img toSize:(CGSize)rect;
+(UIImage *)cropImage:(UIImage *)image inRect:(CGRect)rect;
+(UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

@end
