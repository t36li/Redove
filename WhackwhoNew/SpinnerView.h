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
}

@property (nonatomic, retain) UIImageView *backgroundView;

+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView;
-(void)removeSpinner;
- (UIImage *)addBackground;

@end
