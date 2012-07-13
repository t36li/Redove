//
//  AvatarBaseController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AvatarBaseController : UIViewController
{
    UIView *avatarView;
    UIImageView *backgroundView, *headView, *photoView;
}

@property (nonatomic, retain) UIImageView *backgroundView, *headView, *photoView;
@property (nonatomic, retain) UIView *avatarView;

+(UIImage *)resizeImage:(UIImage *)img toSize:(CGSize)rect;

@end
