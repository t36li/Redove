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

-(void)viewDidAppear:(BOOL)animated{
    [[FBSingletonNew sharedInstance] setDelegate:self];
}

-(IBAction)tutSwitch_touched:(id)sender {
    UISwitch *temp = (UISwitch *) sender;
    
    if ([temp isOn]) {
        NSLog(@"Tutorial is on");
    } else {
        NSLog(@"Tutorial turned off");
    }
}


-(IBAction)back_touched:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)FBLogOutSuccess{
    [[UserInfo sharedInstance] setCurrentLogInType:NotLogIn];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

-(void)closedAboutPage:(UIButton *)sender {
    [UIView animateWithDuration:0.3/1.5 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    } completion:^(BOOL finished) {
        [popUp removeFromSuperview];
    }];
}

-(IBAction)about_touched:(id)sender {
    popUp = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about us.png"]];
    imgView.frame = popUp.frame;
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:self.view.frame];
    [okBtn addTarget:self action:@selector(closedAboutPage:) forControlEvents:UIControlEventTouchUpInside];
    [popUp addSubview:imgView];
    [popUp addSubview:okBtn];
    
    
    
    popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self.view addSubview:popUp];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popUp.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}




@end
