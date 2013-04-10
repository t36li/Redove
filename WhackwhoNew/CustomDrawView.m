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
@synthesize oneStrokePoints;
@synthesize cacheImage;
@synthesize photo;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (userPoints == nil) {
        userPoints = [NSMutableArray array];
    }
    
    if (userPoints.count == 0) {
        cacheImage = photo;
    }
    
    if (oneStrokePoints == nil) {
        oneStrokePoints = [NSMutableArray array];
    }
    
    [oneStrokePoints removeAllObjects];
    
    UITouch *touch = [touches anyObject];
    self.previousPoint = [touch locationInView:self];
    [userPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    [oneStrokePoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [userPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    [oneStrokePoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];

    self.prePreviousPoint = self.previousPoint;
    self.previousPoint = [touch previousLocationInView:self];
    CGPoint currentPoint = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1 = [self calculateMidPointForPoint:self.previousPoint andPoint:self.prePreviousPoint];
    CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:self.previousPoint];
    
    UIGraphicsBeginImageContext(self.drawImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, self.lineWidth);
    
    [[self currentColor] setStroke];
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
    
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, self.previousPoint.x, self.previousPoint.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    /*
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
    */
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
    
    self.prePreviousPoint = self.previousPoint;
    self.previousPoint = [touch previousLocationInView:self];
    CGPoint currentPoint = [touch locationInView:self];
    
    [userPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
    [oneStrokePoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    
    NSArray *generalizedPoints = [self douglasPeucker:oneStrokePoints epsilon:2];
    NSArray *splinePoints = [self catmullRomSpline:generalizedPoints segments:4];
    UIImage *tempImg = [self drawPathWithPoints:splinePoints image:cacheImage];
    
    // calculate mid point
    //CGPoint mid1 = [self calculateMidPointForPoint:self.previousPoint andPoint:self.prePreviousPoint];
    //CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:self.previousPoint];

    UIGraphicsBeginImageContext(self.drawImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[self currentColor] setStroke];
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
    
    [tempImg drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
    /*
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
    */
    //    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
    
    self.cacheImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.drawImageView.image = cacheImage;
    
    UIGraphicsEndImageContext();

    
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

- (UIImage *)drawPathWithPoints:(NSArray *)points image:(UIImage *)image
{
    CGSize screenSize = self.drawImageView.frame.size;
    UIGraphicsBeginImageContext(screenSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineWidth(currentContext, self.lineWidth);

    CGContextBeginPath(currentContext);
    
    int count = [points count];
    CGPoint point = [[points objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(currentContext, point.x, point.y);
    for(int i = 1; i < count; i++) {
        point = [[points objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(currentContext, point.x, point.y);
    }
    CGContextStrokePath(currentContext);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

/** Draws a path to an image and returns the resulting image */
- (UIImage *)drawFinalPath:(NSArray *)points image:(UIImage *)image
{
    CGSize screenSize = self.drawImageView.frame.size;
    UIGraphicsBeginImageContext(screenSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetRGBStrokeColor(currentContext, 0, 0, 1, 1);
    CGContextSetFillColorWithColor(currentContext, [[UIColor blackColor] CGColor]);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGContextSetLineWidth(currentContext, self.lineWidth);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);
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
    
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    //CGContextEOFillPath(currentContext);
    
    CGPathRelease(pathRef);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

-(BOOL) resetPaths {
    int counter = [userPoints count];
    [userPoints removeAllObjects];
    [oneStrokePoints removeAllObjects];
    cacheImage = photo;
    
    return (counter == 0) || (userPoints == nil);
}

-(void) commitPaths{
    
    if (userPoints.count <= 0)
        return;
    
    UserInfo *user = [UserInfo sharedInstance];
    
    UIImage *mask = [self drawFinalPath:userPoints image:nil];
    
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
    
    user.faceRect = CGRectMake(0, 0, finalResizedImage.size.width, finalResizedImage.size.height);
    
    [userPoints removeAllObjects];
    
    return;
}

- (NSArray *)douglasPeucker:(NSArray *)points epsilon:(float)epsilon
{
    int count = [points count];
    if(count < 3) {
        return points;
    }
    
    //Find the point with the maximum distance
    float dmax = 0;
    int index = 0;
    for(int i = 1; i < count - 1; i++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        CGPoint lineA = [[points objectAtIndex:0] CGPointValue];
        CGPoint lineB = [[points objectAtIndex:count - 1] CGPointValue];
        float d = [self perpendicularDistance:point lineA:lineA lineB:lineB];
        if(d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    //If max distance is greater than epsilon, recursively simplify
    NSArray *resultList;
    if(dmax > epsilon) {
        NSArray *recResults1 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(0, index + 1)] epsilon:epsilon];
        
        NSArray *recResults2 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(index, count - index)] epsilon:epsilon];
        
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:recResults1];
        [tmpList removeLastObject];
        [tmpList addObjectsFromArray:recResults2];
        resultList = tmpList;
    } else {
        resultList = [NSArray arrayWithObjects:[points objectAtIndex:0], [points objectAtIndex:count - 1],nil];
    }
    
    return resultList;
}

- (float)perpendicularDistance:(CGPoint)point lineA:(CGPoint)lineA lineB:(CGPoint)lineB
{
    CGPoint v1 = CGPointMake(lineB.x - lineA.x, lineB.y - lineA.y);
    CGPoint v2 = CGPointMake(point.x - lineA.x, point.y - lineA.y);
    float lenV1 = sqrt(v1.x * v1.x + v1.y * v1.y);
    float lenV2 = sqrt(v2.x * v2.x + v2.y * v2.y);
    float angle = acos((v1.x * v2.x + v1.y * v2.y) / (lenV1 * lenV2));
    return sin(angle) * lenV2;
}

- (NSArray *)catmullRomSpline:(NSArray *)points segments:(int)segments
{
    int count = [points count];
    if(count < 4) {
        return points;
    }
    
    float b[segments][4];
    {
        // precompute interpolation parameters
        float t = 0.0f;
        float dt = 1.0f/(float)segments;
        for (int i = 0; i < segments; i++, t+=dt) {
            float tt = t*t;
            float ttt = tt * t;
            b[i][0] = 0.5f * (-ttt + 2.0f*tt - t);
            b[i][1] = 0.5f * (3.0f*ttt -5.0f*tt +2.0f);
            b[i][2] = 0.5f * (-3.0f*ttt + 4.0f*tt + t);
            b[i][3] = 0.5f * (ttt - tt);
        }
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    {
        int i = 0; // first control point
        [resultArray addObject:[points objectAtIndex:0]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = (b[j][0]+b[j][1])*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = (b[j][0]+b[j][1])*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    for (int i = 1; i < count-2; i++) {
        // the first interpolated point is always the original control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    {
        int i = count-2; // second to last control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + (b[j][2]+b[j][3])*pointIp1.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + (b[j][2]+b[j][3])*pointIp1.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    // the very last interpolated point is the last control point
    [resultArray addObject:[points objectAtIndex:(count - 1)]];
    
    return resultArray;
}


@end
