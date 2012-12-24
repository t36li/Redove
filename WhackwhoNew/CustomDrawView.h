//
//  CustomDrawView.h
//  WhackwhoNew
//
//  Created by Peter on 2012-11-28.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomDrawView : UIView {
    IBOutlet UIImageView *drawImageView;
    NSMutableArray *userPoints;
    CGFloat lineWidth;
}

@property (nonatomic,strong) IBOutlet UIImageView *drawImageView;
@property (nonatomic, strong) NSMutableArray *userPoints;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic,strong) UIColor *currentColor;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint prePreviousPoint;
@property (nonatomic) CGPoint previousPoint;

-(void) resetPaths;
-(void) commitPaths;

@end