//
//  AvatarView.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-09.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "AvatarView.h"
#import "QuartzCore/QuartzCore.h"

@implementation AvatarView

@synthesize headView, backgroundView, photoView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AvatarView" owner:self options:nil];
        self = [array objectAtIndex:0];
        self.frame = frame;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor redColor].CGColor;
        NSArray *viewArray = self.subviews;
        for (UIView *vw in self.subviews) {
            switch (vw.tag) {
                case 1:
                    self.backgroundView = (UIImageView *)vw;
                    break;
                case 2:
                    self.headView = (UIImageView *)vw;
                    break;
                case 3:
                    self.photoView = (UIImageView *)vw;
                    break;
                    
                default:
                    break;
            }
        }
        
        self.photoView.image = [UIImage imageNamed:@"icon@2x.png"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
