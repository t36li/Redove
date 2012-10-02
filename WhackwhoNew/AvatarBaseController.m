//
//  AvatarBaseController.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "AvatarBaseController.h"

@interface AvatarBaseController ()

@end

@implementation AvatarBaseController

@synthesize backgroundView, headView, photoView, avatarView, markingView, faceEffectsView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
        [self loadAvatarView];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // initialize what you need here
        [self loadAvatarView];
    }
    
    return self;
}

- (void)loadAvatarView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AvatarView" owner:self options:nil];
    self.avatarView = [arr objectAtIndex:0];
    NSArray *subviews = avatarView.subviews;
    self.photoView = [subviews objectAtIndex:0];
    self.headView = [subviews objectAtIndex:1];
    self.markingView = [subviews objectAtIndex:2];
    self.faceEffectsView = [subviews objectAtIndex:3];
    self.backgroundView = [subviews objectAtIndex:4];
    
    [avatarView bringSubviewToFront:markingView];
    [avatarView bringSubviewToFront:faceEffectsView];
    [avatarView bringSubviewToFront:backgroundView];
    [avatarView sendSubviewToBack:headView];
    [avatarView sendSubviewToBack:photoView];

    avatarView.autoresizesSubviews = YES;
    
//    CGSize rect = headView.frame.size;
//    CGSize rect2 = backgroundView.frame.size;
//    CGSize rect3 = photoView.frame.size;
//    UIImage *img = headView.image;
//    UIImage *img2 = backgroundView.image;
//    UIImage *img3 = photoView.image;
     
//    photoView.layer.borderColor = [UIColor blueColor].CGColor;
//    photoView.layer.borderWidth = 15;
//    headView.layer.borderColor = [UIColor redColor].CGColor;
//    headView.layer.borderWidth = 15;
//    backgroundView.layer.borderColor = [UIColor purpleColor].CGColor;
//    backgroundView.layer.borderWidth = 10;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+(UIImage *)cropImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    // or use the UIImage wherever you like
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
