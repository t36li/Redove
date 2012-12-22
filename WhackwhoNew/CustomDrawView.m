//
//  CustomDrawView.m
//  WhackwhoNew
//
//  Created by Peter on 2012-11-28.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//
#import "CustomDrawView.h"
#import "UserInfo.h"
#import "AvatarBaseController.h"

@implementation CustomDrawView

@synthesize drawImageView;
@synthesize userPoints;
@synthesize lineWidth;
@synthesize lastPoint;
@synthesize prePreviousPoint;
@synthesize previousPoint;
@synthesize currentColor;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (userPoints == nil)
        userPoints = [NSMutableArray array];
    
    UITouch *touch = [touches anyObject];
    self.previousPoint = [touch locationInView:self];
    [userPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [userPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    
    self.prePreviousPoint = self.previousPoint;
    self.previousPoint = [touch previousLocationInView:self];
    CGPoint currentPoint = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1 = [self calculateMidPointForPoint:self.previousPoint andPoint:self.prePreviousPoint];
    CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:self.previousPoint];
    
    UIGraphicsBeginImageContext(self.drawImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[self currentColor] setStroke];
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
    
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, self.previousPoint.x, self.previousPoint.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGFloat xDist = (previousPoint.x - currentPoint.x); //[2]
    CGFloat yDist = (previousPoint.y - currentPoint.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    
    distance = distance / 10;
    
    if (distance > 10) {
        distance = 10.0;
    }
    
    distance = distance / 10;
    distance = distance * 3;
    
    if (4.0 - distance > self.lineWidth) {
        lineWidth = lineWidth + 0.3;
    } else {
        lineWidth = lineWidth - 0.3;
    }
    
    CGContextSetLineWidth(context, self.lineWidth);
    
    //    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
    
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (CGPoint)calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    [userPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
    
    
    return;
    /*
    
    [self setLineWidth:1.0];
    
    if ([touch tapCount] == 1) {
        UIGraphicsBeginImageContext(self.drawImageView.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [[self currentColor] setStroke];
        
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
        CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
        
        [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
        
        CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGContextSetLineWidth(context, 4.0);
        
        CGContextStrokePath(context);
        
        self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        CGContextClosePath(context);
        CGContextEOFillPath(context);
        UIGraphicsEndImageContext();
    }
     */
}

/** Draws a path to an image and returns the resulting image */
- (UIImage *)drawPathWithPoints:(NSArray *)points image:(UIImage *)image
{
    CGSize screenSize = self.drawImageView.frame.size;
    UIGraphicsBeginImageContext(screenSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineWidth(currentContext, 1.0);
    CGContextSetRGBStrokeColor(currentContext, 0, 0, 1, 1);
    CGContextSetFillColorWithColor(currentContext, [[UIColor blackColor] CGColor]);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    //CGContextBeginPath(currentContext);
    
    int count = [points count];
    CGPoint point = [[points objectAtIndex:0] CGPointValue];
    CGPathMoveToPoint(pathRef, NULL, point.x, point.y);
    //CGContextMoveToPoint(currentContext, point.x, point.y);
    for(int i = 1; i < count; i++) {
        point = [[points objectAtIndex:i] CGPointValue];
        CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
        //CGContextAddLineToPoint(currentContext, point.x, point.y);
    }
    //CGContextStrokePath(currentContext);
    CGPathCloseSubpath(pathRef);
    CGContextAddPath(currentContext, pathRef);
    CGContextEOFillPath(currentContext);
    
    CGPathRelease(pathRef);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

-(void) resetPaths {
    [userPoints removeAllObjects];
    
    UserInfo *user = [UserInfo sharedInstance];
    self.drawImageView.image = user.usrImg;
}

-(void) commitPaths{
    
    UserInfo *user = [UserInfo sharedInstance];
    
    UIImage *mask = [self drawPathWithPoints:userPoints image:nil];
    
    UIView *container = [[UIView alloc] initWithFrame:self.frame];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:mask];
    [container setBackgroundColor:[UIColor whiteColor]];
    [imgView setBackgroundColor:[UIColor clearColor]];
    [container addSubview:imgView];
    //[self addSubview:container];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [container.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *renderedMask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *resizedImage = [AvatarBaseController resizeImage:drawImageView.image toSize:drawImageView.frame.size];
    UIImage *maskedImage = [AvatarBaseController maskImage:resizedImage withMask:renderedMask];
    
    
    int max_X, max_Y, min_X, min_Y;
    max_X = max_Y = 0;
    min_X = min_Y = INT_MAX;
    
    for (NSValue *val in userPoints) {
        CGPoint point = val.CGPointValue;
        int x = point.x;
        int y = point.y;
        
        if (x > max_X)
            max_X = x;
        else if (x < min_X)
            min_X = x;
        
        if (y > max_Y)
            max_Y = y;
        else if (y < min_Y)
            min_Y = y;
        
    }
    
    CGRect faceRect = CGRectMake(min_X, min_Y, max_X - min_X, max_Y - min_Y);
    
    UIImage *finalImage = [AvatarBaseController cropImage:maskedImage inRect:faceRect];
    
    UIImage *finalResizedImage = [AvatarBaseController resizeImage:finalImage toSize:drawImageView.frame.size];
    
    drawImageView.image = finalResizedImage;
    
    [user setCroppedImage:finalResizedImage];
    [user setUsrImg:nil];
    user.faceRect = faceRect;
    
    [userPoints removeAllObjects];
    
    return;
}

@end
