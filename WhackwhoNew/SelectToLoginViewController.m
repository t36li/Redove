//
//  SelectToLoginViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-27.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//


#import "SelectToLoginViewController.h"
#import "FBSingleton.h"
#import "GlobalMethods.h"
#import "UserInfo.h"


@interface SelectToLoginViewController ()

@end

@implementation SelectToLoginViewController
@synthesize FBBut;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    [gmethods setViewBackground:SelectToLogIn_bg viewSender:self.view];

    //setup FBBut Image;
    [FBBut setImage:[UIImage imageNamed:AccessFacebookIcon] forState:UIControlStateNormal];
    [FBBut setImage:[UIImage imageNamed:AccessFacebookIcon_HL] forState:UIControlStateHighlighted];
    //[FBBut setImage:[UIImage imageNamed:AccessFacebookIcon forState:UIControlStateNormal]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

-(IBAction)FBTouched:(id)sender{
    [[FBSingleton sharedInstance] login];
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
