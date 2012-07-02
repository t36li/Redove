//
//  CameraOverlayControllerViewControllerDelegate.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraOverlayControllerViewControllerDelegate <NSObject>

-(void)validImageCaptured:(UIImage *)image croppedImage:(UIImage*)croppedImg;
@end
