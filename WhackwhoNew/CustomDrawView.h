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
    
    NSMutableArray *oneStrokePoints;
    UIImage *cacheImage;
    UIImage *photo;
}

@property (nonatomic,strong) IBOutlet UIImageView *drawImageView;
@property (nonatomic, strong) NSMutableArray *userPoints, *oneStrokePoints;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic,strong) UIColor *currentColor;

@property (nonatomic, strong) UIImage *cacheImage, *photo;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint prePreviousPoint;
@property (nonatomic) CGPoint previousPoint;

-(BOOL) resetPaths;
-(void) commitPaths;

@end