//
//  OptionsViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "OptionsViewController.h"
#import "FBSingleton.h"


@interface OptionsViewController ()

@end

@implementation OptionsViewController
@synthesize back, logout_but;

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
    [[FBSingleton sharedInstance] setDelegate:self];
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
}

-(void)FBSingletonDidLogout{
    [back sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
