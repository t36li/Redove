//
//  StatusBarController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusBarController.h"
#import "UserInfo.h"


@implementation StatusBarController

@synthesize Bobhead, headView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view, typically from a nib.

    [Bobhead setContentMode:UIViewContentModeScaleAspectFit];
    [Bobhead setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    UserInfo *usr = [UserInfo sharedInstance];
    if (usr.usrImg != nil) {
        headView.image = usr.croppedImage;
    }
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
