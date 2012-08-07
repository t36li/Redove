//
//  Dragbox.m
//  CaseMaster
//
//  Created by Bob Li on 12-05-14.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "Dragbox.h"
#import "StatusBarController.h"

@implementation Dragbox


- (id)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	startPoint = [[touches anyObject] locationInView:self];
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint pt = [[touches anyObject] locationInView:self];
	float dx = pt.x - startPoint.x;
    float dy = pt.y - startPoint.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    //stay within bounds
    float midPointX = CGRectGetMidX(self.bounds);
    //if too far right
    if (newcenter.x > self.superview.bounds.size.width - midPointX) {
        newcenter.x = self.superview.bounds.size.width - midPointX;
    //if too far left
    } else if (newcenter.x < midPointX) {
        newcenter.x = midPointX;
    }
    
    //if too far down
    float midPointY = CGRectGetMidY(self.bounds);
    if (newcenter.y > self.superview.bounds.size.height - midPointY) {
        newcenter.y = self.superview.bounds.size.height - midPointY;
    } else if (newcenter.y < midPointY) { //if too far up...
        newcenter.y = midPointY;
    }
	
    self.center = newcenter;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */


@end