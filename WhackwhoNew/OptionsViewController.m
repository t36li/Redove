//
//  OptionsViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "OptionsViewController.h"
#import "FBSingleton.h"
#import "RootViewController.h"


@interface OptionsViewController ()

@end

@implementation OptionsViewController
@synthesize back, logout_but;

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

-(void)viewWillAppear:(BOOL)animated{
    if ([[FBSingleton sharedInstance] isLogin]) {
        logout_but.hidden = NO;
    }
    else {
        logout_but.hidden = YES;
    }
}

-(IBAction)back_touched:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)logout_touched:(id)sender{
    if ([[FBSingleton sharedInstance] isLogin]){
        [[FBSingleton sharedInstance] logout];
    }
    [self dismissModalViewControllerAnimated:YES];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
