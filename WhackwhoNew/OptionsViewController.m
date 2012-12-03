//
//  OptionsViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "OptionsViewController.h"
#import "FBSingletonNew.h"
#import "RootViewController.h"
#import "UserInfo.h"

@implementation OptionsViewController
@synthesize back, logout_but;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    usr = [UserInfo sharedInstance];
    fbs = [FBSingletonNew sharedInstance];
    if ((int)[[UserInfo sharedInstance] currentLogInType] != NotLogIn) {
        logout_but.hidden = NO;
    }
    else {
        logout_but.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(IBAction)back_touched:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)logout_touched:(id)sender{
    switch ([usr currentLogInType]) {
        case LogInFacebook:{
            if ([fbs isLogin]){
                [fbs performLogout];
            }
                }
            break;
            
        default:
            break;
    }
    //[self performSelector:@selector(back_Touched) withObject:self afterDelay:1.5];
    //**if ([[FBSingleton sharedInstance] isLogIn]){
    //**    [[FBSingleton sharedInstance] logout]; //logout facebook with authorized info
        //[[FBSingleton sharedInstance] unauthorized]; //facebook user info unauthorized
   // }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



@end
