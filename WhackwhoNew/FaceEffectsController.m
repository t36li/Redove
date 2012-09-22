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

@synthesize containerView;
@synthesize nose, mouth, left_eye, left_ear, left_tear, right_ear, right_eye, right_tear;
@synthesize backButton;

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
    
    [self.containerView addSubview:avatarView];
    [containerView sendSubviewToBack:avatarView];
    avatarView.frame = containerView.bounds;
    UserInfo *user = [UserInfo sharedInstance];
    headView.image = user.croppedImage;
}

- (void)viewWillAppear:(BOOL)animated {

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
