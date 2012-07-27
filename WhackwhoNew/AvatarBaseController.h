//
//  AvatarBaseController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImage+fixOrientation.h"
#import "UserInfo.h"

@interface AvatarBaseController : UIViewController
{
    UIView *avatarView, *markingView;
    UIImageView *backgroundView, *headView, *photoView;
    CGPoint leftEyePos, rightEyePos, mouthPos;
}

@property (nonatomic) UIImageView *backgroundView, *headView, *photoView;
@property (nonatomic) UIView *avatarView, *markingView;

+(UIImage *)resizeImage:(UIImage *)img toSize:(CGSize)rect;
-(void)markFaces:(UIImageView *)facePicture;

@end
