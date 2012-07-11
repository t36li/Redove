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
@synthesize FBBut,EMBut;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    [gmethods setViewBackground:SelectToLogIn_bg viewSender:self.view];

    //setup FBBut Image;
    [FBBut setImage:[UIImage imageNamed:AccessFacebookIcon] forState:UIControlStateNormal];
    [FBBut setImage:[UIImage imageNamed:AccessFacebookIcon_HL] forState:UIControlStateHighlighted];
    //setup EMBut Image
    //[FBBut setImage:[UIImage imageNamed:AccessFacebookIcon forState:UIControlStateNormal]];
}

-(void)viewDidAppear:(BOOL)animated{
    [[FBSingleton sharedInstance] setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

-(IBAction)FBTouched:(id)sender{
    [[FBSingleton sharedInstance] login];
}
-(IBAction)EMTouched:(id)sender{
    
}

-(void)FBSingletonDidLogin:(NSString *)userId :(NSString *)userName{
    [[UserInfo sharedInstance] setUserId:userId];
    [[UserInfo sharedInstance] setUserName:userName];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
