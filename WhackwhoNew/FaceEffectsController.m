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

@synthesize backButton, containerView, cropImage;

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
}

- (void)viewWillAppear:(BOOL)animated {
    UIImage *resizedImage = [AvatarBaseController resizeImage:cropImage toSize:headView.frame.size];
    headView.image = resizedImage;
    UserInfo *user = [UserInfo sharedInstance];
    user.delegate = self;
    
    for (UIView *subview in faceEffectsView.subviews)
         [subview removeFromSuperview];
    
    [user performSelectorInBackground:@selector(markFaces:) withObject:headView.image];
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

-(void)setUserPictureCompleted {
    UserInfo *user = [UserInfo sharedInstance];
    CGFloat faceWidth = user.faceRect.size.width;
    
    UIImageView *leftEye = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye1.png"]];
    CGRect leftEyeFrame = CGRectMake(user.leftEyePosition.x-faceWidth*0.15, user.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3);
    leftEye.frame = leftEyeFrame;
    leftEye.center = user.leftEyePosition;
    [faceEffectsView addSubview:leftEye];
    
    UIImageView *rightEye = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye2.png"]];
    CGRect rightEyeFrame = CGRectMake(user.rightEyePosition.x-faceWidth*0.15, user.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3);
    rightEye.frame = rightEyeFrame;
    rightEye.center = user.rightEyePosition;
    [faceEffectsView addSubview:rightEye];
    
    UIImageView *mouth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lip 1.png"]];
    CGRect mouthFrame = CGRectMake(user.mouthPosition.x-faceWidth*0.2, user.mouthPosition.y-faceWidth*0.15, faceWidth*0.4, faceWidth*0.3);
    mouth.frame = mouthFrame;
    mouth.center = user.mouthPosition;
    [faceEffectsView addSubview:mouth];
}

@end
