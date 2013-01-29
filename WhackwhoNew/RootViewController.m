//
//  RootViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "RootViewController.h"
#import "SelectToLoginViewController.h"
#import "GlobalMethods.h"
#import "OptionsViewController.h"
#import "FriendsViewController.h"
#import "UserInfo.h"
#import "User.h"
#import "cocos2d.h"
#import "StatusViewLayer.h"

#define PlayToSelectLogInSegue @"PlayToSelectLogInSegue"
#define PlayToStatusSegue @"PlayToStatusSegue"
#define PlayToSegue @"PlayToSegue"
//#define PlayToFriendSegue @"PlayToFriendSegue"
#define SelectToLoginToAvatar @"SelectToLoginToAvatar"

#define networkErrorAlert 1
#define newbieAlert 2

//static NSArray *FriendsData = nil;


@implementation RootViewController
@synthesize play_but,opt_but;
@synthesize profileImageView;
@synthesize baby, whack_label, poster;

-(void) viewDidLoad
{
    //NSLog(@"RootViewController viewDidLoad");
    [super viewDidLoad];
    usr = [UserInfo sharedInstance];
    fbs = [FBSingletonNew sharedInstance];
    
    //GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    //[gmethods setViewBackground:MainPage_bg viewSender:self.view];
    //NSLog(@"RootViewController: Background loaded");
    [self performSelector:@selector(appInviteAlertActivate) withObject:nil afterDelay:1];
}


-(void) viewDidAppear:(BOOL)animated{
    fbs.delegate = self;
    NSLog(@"RootViewController: load Profile Image");
    if ([fbs isLogin] == YES){
        self.profileImageView.profileID = [usr userId];
    }else{
        profileImageView.profileID = nil;
    }
    
    [self startWalking];
    //[self startLabelAnimation];
    [self startPosterAnimation];
}

- (void) startPosterAnimation {
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"Main_Poster1.png"],
                             [UIImage imageNamed:@"Main_Poster2.png"],
                             nil];
    poster.animationImages = imageArray;
    poster.animationDuration = 0.5;
    poster.animationRepeatCount = 0;
    [poster startAnimating];
}

- (void) startLabelAnimation {
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"whackwho1.png"],
                             [UIImage imageNamed:@"whackwho2.png"],
                             [UIImage imageNamed:@"whgackwho3.png"],
                             nil];
    whack_label.animationImages = imageArray;
    whack_label.animationDuration = 1;
    whack_label.animationRepeatCount = 0;
    //CGPoint p = whack_label.center;
    //p.x -= 408;
    //ryuJump.center = p;
    
    //[UIView animateWithDuration:30
      //                    delay:0
        //                options: UIViewAnimationOptionCurveLinear
          //           animations:^{
            //             baby.center = CGPointMake(p.x, p.y);
              //       }
                //     completion:^(BOOL finished){
                  //   }];
    [whack_label startAnimating];
}

- (void)startWalking {
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"baby1.png"],
                             [UIImage imageNamed:@"baby2.png"],
                             [UIImage imageNamed:@"baby3.png"],
                             [UIImage imageNamed:@"baby4.png"],
                             [UIImage imageNamed:@"baby5.png"],
                             [UIImage imageNamed:@"baby6.png"],
                             nil];
    baby.animationImages = imageArray;
    baby.animationDuration = 2;
    baby.animationRepeatCount = 0;
    CGPoint p = baby.center;
    p.x -= 408;
    //ryuJump.center = p;
    
    [UIView animateWithDuration:30
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         baby.center = CGPointMake(p.x, p.y);
                     }
                     completion:^(BOOL finished){
                     }];
    [baby startAnimating];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(IBAction)play_touched:(id)sender{
    NSLog(@"Play Button Touched");
    if ([fbs isLogin]==YES){
        [self performSegueWithIdentifier:PlayToStatusSegue sender:sender];
    }else{
        //[self performSegueWithIdentifier:PlayToSelectLogInSegue sender:sender];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

-(IBAction)opt_touched:(id)sender{

}

-(IBAction)Friend_touched:(id)sender{//change it to invite friends![button changed]
    if ([[FBSingletonNew sharedInstance] isLogin])
    [[FBSingletonNew sharedInstance] performSelector:@selector(sendRequest) withObject:nil afterDelay:0.5];
}

/*
 * This private method will be used to check the app
 * usage counter, update it as necessary, and return
 * back an indication on whether the user should be
 * shown the prompt to invite friends
 */
- (BOOL) checkAppUsageTrigger {
    // Initialize the app active count
    NSInteger appActiveCount = 0;
    // Read the stored value of the counter, if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"AppUsedCounter"]) {
        appActiveCount = [defaults integerForKey:@"AppUsedCounter"];
    }
    
    // Increment the counter
    appActiveCount++;
    BOOL trigger = NO;
    // Only trigger the prompt if the facebook session is valid and
    // the counter is greater than a certain value, 3 in this sample
    if (FBSession.activeSession.isOpen && (appActiveCount >= 3)) {
        trigger = YES;
        appActiveCount = 0;
    }
    // Save the updated counter
    [defaults setInteger:appActiveCount forKey:@"AppUsedCounter"];
    [defaults synchronize];
    return trigger;
}

// Check the flag for enabling any prompts. If that flag is on
// check the app active counter
-(void) appInviteAlertActivate{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[FBSingletonNew sharedInstance] isLogin] && [appDelegate appUsageCheckEnabled] && [self checkAppUsageTrigger]) {
        // If the user should be prompter to invite friends, show
        // an alert with the choices.
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invite Friends"
                              message:@"If you enjoy using this app, would you mind taking a moment to invite a few friends that you think will also like it?"
                              delegate:self
                              cancelButtonTitle:@"Never Invite"
                              otherButtonTitles:@"Tell Friends!", @"Remind Me Later", nil];
        [alert show];
    }
}



/*
 * When the alert is dismissed check which button was clicked so
 * you can take appropriate action, such as displaying the request
 * dialog, or setting a flag not to prompt the user again.
 */

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // User has clicked on the No Thanks button, do not ask again
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"AppUsageCheck"];
        [defaults synchronize];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setAppUsageCheckEnabled:NO];
    } else if (buttonIndex == 1) {
        // User has clicked on the Tell Friends button
        [[FBSingletonNew sharedInstance] performSelector:@selector(sendRequest) withObject:nil afterDelay:0.5];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PlayToSelectLogInSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToStatusSegue]){
    }
    //else if ([segue.identifier isEqualToString:PlayToFriendSegue]){
        //self.friendVC = segue.destinationViewController;
   // }
    else if ([segue.identifier isEqualToString:SelectToLoginToAvatar]){
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
