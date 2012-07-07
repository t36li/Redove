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
#import "GlobalMethods.h"
#import "OptionsViewController.h"
#import "FriendsViewController.h"

#define PlayToSelectLogInSegue @"PlayToSelectLogInSegue"
#define PlayToStatusSegue @"PlayToStatusSegue"
#define PlayToSegue @"PlayToSegue"
#define PlayToFriendSegue @"PlayToFriendSegue"

static NSMutableArray *FriendsData = nil;

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize LoginAccountImageView;
@synthesize play_but,opt_but;


-(void) viewDidLoad
{
    NSLog(@"RootViewController viewDidLoad");
    [super viewDidLoad];
    GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    [gmethods setViewBackground:MainPage_bg viewSender:self.view];
    
    //[[NSUserDefaults standardUserDefaults] setInteger:nil forKey:LogInAs]; 
    
}

-(void) viewWillAppear:(BOOL)animated{
    [[FBSingleton sharedInstance] setDelegate:self];
    //currentLogInType = [[NSUserDefaults standardUserDefaults] integerForKey:LogInAs];

    if ([[FBSingleton sharedInstance] isLogin]){
        [[FBSingleton sharedInstance] RequestMeProfileImage];
    }
    else {
        LoginAccountImageView.image = nil;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(IBAction)play_touched:(id)sender{
    NSLog(@"Play Button Touched");
    
    switch ((int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs]) {
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
            //[self performSegueWithIdentifier:PlayToSelectLogInSegue sender:sender];
            break;
        }
    }
}

-(IBAction)opt_touched:(id)sender{

}

-(IBAction)Friend_touched:(id)sender{
    if ([[FBSingleton sharedInstance] isLogin]){
    [[FBSingleton sharedInstance] RequestFriendList];
    
    }
}
        

//FBSingleton Delegate:

-(void) FBProfilePictureLoaded:(UIImage *)img{
    LoginAccountImageView.image = img;
    NSLog(@"profilepictureloaded profileimage: %@",LoginAccountImageView.image);
}

-(void)FBSingletonDidLogout {
    self.LoginAccountImageView.image = nil;
    
}

-(void)FBSingletonDidLogin {
    [[FBSingleton sharedInstance] RequestMeProfileImage];
}

-(void) FBSIngletonUserFriendsDidLoaded:(NSMutableArray *)friends{
    FriendsData = [[NSMutableArray alloc] initWithArray:friends copyItems:YES];
    [self performSegueWithIdentifier:PlayToFriendSegue sender:friend_but];
    
}

///////////////////////////
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PlayToSelectLogInSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToStatusSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToFriendSegue]){
        [(FriendsViewController *)segue.destinationViewController   setResultData:FriendsData];
        //FriendsViewController *fvc = (FriendsViewController *)segue.destinationViewController;
        //fvc.resultData = [[NSMutableArray alloc] initWithArray:FriendsData copyItems:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
