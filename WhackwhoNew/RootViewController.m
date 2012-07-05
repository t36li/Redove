//
//  RootViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "RootViewController.h"
#import "FBSingleton.h"
#import "Constants.h"
#import "StatusBarController.h"
#import "SelectToLoginViewController.h"

#define PlayToSelectLogInSegue @"PlayToSelectLogInSegue"
#define PlayToStatusSegue @"PlayToStatusSegue"
#define PlayToSegue @"PlayToSegue"


@interface RootViewController ()

@end

@implementation RootViewController
@synthesize LoginAccountImageView;
@synthesize play_but;

-(IBAction)play_touched:(id)sender{
    NSLog(@"Play Button Touched");
    
    switch (currentLogInType) {
        case NotLogIn:{
            [self performSegueWithIdentifier:PlayToSelectLogInSegue sender:sender];
            break;
        }
        case LogInFacebook:{
            if([[FBSingleton sharedInstance] isLogin]){
                //!!!!!!!!!!!!!When Databases knick in, check if it is a registered user.
                //current status, use all facebook users as registered users
                [self performSegueWithIdentifier:PlayToStatusSegue sender:self];
            }
            break;
        }  
        case LogInRenren:{
            break;
        }
        case LogInEmail:{
            break;
        }
        default:{
            SelectToLoginViewController *selectLoginVC = [[SelectToLoginViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:selectLoginVC animated:YES];
            break;
        }
    }
}


-(void) viewDidLoad
{
    NSLog(@"RootViewController viewDidLoad");
    [super viewDidLoad];
    [[FBSingleton sharedInstance] setDelegate:self];
    //[[NSUserDefaults standardUserDefaults] setInteger:nil forKey:LogInAs];
    currentLogInType = [[NSUserDefaults standardUserDefaults] integerForKey:LogInAs];
}

-(void) viewDidAppear:(BOOL)animated{
    if ([[FBSingleton sharedInstance] isLogin]){
        [[FBSingleton sharedInstance] RequestMeProfileImage];
    }
    else {
        LoginAccountImageView.image = nil;
    }
}

-(void) FBProfilePictureLoaded:(UIImage *)img{
    LoginAccountImageView.image = img;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PlayToSelectLogInSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToStatusSegue]){
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



@end
