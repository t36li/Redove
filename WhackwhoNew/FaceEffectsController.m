//
//  FaceEffectsController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-09-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FaceEffectsController.h"

@interface FaceEffectsController ()

@end

@implementation FaceEffectsController

@synthesize backButton, containerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [containerView addSubview:avatarView];
    UserInfo *user = [UserInfo sharedInstance];
    headView.image = user.croppedImage;
}

- (void)viewWillAppear:(BOOL)animated {
    UserInfo *user = [UserInfo sharedInstance];
    
    for (UIView *subview in faceEffectsView.subviews)
         [subview removeFromSuperview];
    
    [user markFaces:user.croppedImage];
    CGFloat faceWidth = user.faceRect.size.width;
    
    CGFloat widthRatio = headView.frame.size.width / user.croppedImage.size.width;
    CGFloat heightRatio = headView.frame.size.height / user.croppedImage.size.height;
    
    UIImageView *leftEye = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye1.png"]];
    CGRect leftEyeFrame = CGRectMake((user.leftEyePosition.x-faceWidth*0.15)*widthRatio, (user.leftEyePosition.y-faceWidth*0.15)*heightRatio, faceWidth*0.3, faceWidth*0.3);
    leftEye.frame = leftEyeFrame;
    [faceEffectsView addSubview:leftEye];
    
    UIImageView *rightEye = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye2.png"]];
    CGRect rightEyeFrame = CGRectMake((user.rightEyePosition.x-faceWidth*0.15)*widthRatio, (user.rightEyePosition.y-faceWidth*0.15)*heightRatio, faceWidth*0.3, faceWidth*0.3);
    rightEye.frame = rightEyeFrame;
    [faceEffectsView addSubview:rightEye];
    
    UIImageView *mouth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lip 1.png"]];
    CGRect mouthFrame = CGRectMake((user.mouthPosition.x-faceWidth*0.2)*widthRatio, (user.mouthPosition.y-faceWidth*0.2)*heightRatio, faceWidth*0.4, faceWidth*0.4);
    mouth.frame = mouthFrame;
    [faceEffectsView addSubview:mouth];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
