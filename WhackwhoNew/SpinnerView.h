//
//  SpinnerView.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-14.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView {
    UIImageView *backgroundView;
    UIView *superView;
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) UIView *superView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

+(SpinnerView *)loadSpinnerIntoView:(UIView *)containerView;
-(void)removeSpinner;
- (UIImage *)addBackground;
- (void)setBackgroundColor;
- (void)startSpinnerInView:(UIView *)superView;

@end
