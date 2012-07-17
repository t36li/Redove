//
//  RootViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "RootViewController.h"
#import "FBSingleton.h"
#import "StatusBarController.h"
#import "SelectToLoginViewController.h"
#import "GlobalMethods.h"
#import "OptionsViewController.h"
#import "FriendsViewController.h"
#import "UserInfo.h"
#import "cocos2d.h"

#define PlayToSelectLogInSegue @"PlayToSelectLogInSegue"
#define PlayToStatusSegue @"PlayToStatusSegue"
#define PlayToSegue @"PlayToSegue"
#define PlayToFriendSegue @"PlayToFriendSegue"

//static NSArray *FriendsData = nil;


@interface RootViewController (){
    @private
    UserInfo *usr;
    FBSingleton *fbs;
    GlobalMethods *gmethods;
}
@end

@implementation RootViewController
@synthesize LoginAccountImageView;
@synthesize play_but,opt_but;

-(void) viewDidLoad
{
    NSLog(@"RootViewController viewDidLoad");
    [super viewDidLoad];
    
    //Progression Anamation:

    
    UIImageView *myImageView =[[UIImageView alloc] initWithImage:
                               [UIImage imageNamed:Vald]];    
    myImageView.frame = CGRectMake(0, self.view.frame.size.height/2, 40, 40); 
    
    [self.view addSubview:myImageView];
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    [myArray addObject:myImageView];
    
    [UIView animateWithDuration:20 
                          delay:0 
                        options:(UIViewAnimationOptionAllowUserInteraction) // | something here?)
                     animations:^{
                         myImageView.frame = CGRectOffset(myImageView.frame, 500, 0);    
                     }
                     completion:^(BOOL finished){
                         //[myArray removeObject:myImageView];
                         //[myImageView removeFromSuperview];
                         //[myImageView release];
                     }
     ];
    
    
    
    NSLog(@"Load/set currentLogInType");
    gmethods = [[GlobalMethods alloc] init];
    usr = [UserInfo sharedInstance];
    
    if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs]>0){
        [usr setCurrentLogInType:(int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs]];
    }else{
        [usr setCurrentLogInType:NotLogIn];
        [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSLog(@"update UserInfo");
    switch ((int)[usr currentLogInType]) {
        case LogInFacebook:
            [[FBSingleton sharedInstance] setDelegate:self];
            fbs = [FBSingleton sharedInstance];
            if ([fbs isLogIn]){
                [fbs RequestMe];
            }
            else {
                [usr setCurrentLogInType:NotLogIn];
                [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            break;
            
        default:
            break;
    }
    
    NSLog(@"update Background");
    [gmethods setViewBackground:MainPage_bg viewSender:self.view];
}

-(void) viewDidAppear:(BOOL)animated{
    [[FBSingleton sharedInstance] setDelegate:self];
    /*
    if ((int)usr.currentLogInType != NotLogIn){
        LoginAccountImageView.image = [gmethods imageForObject:usr.userId];
    }
    else {
        LoginAccountImageView.image = nil;
    }
     */
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(IBAction)play_touched:(id)sender{
    NSLog(@"Play Button Touched");
    
    switch ((int)[usr currentLogInType]) {
        case NotLogIn:{
            [self performSegueWithIdentifier:PlayToSelectLogInSegue sender:sender];
            break;
        }
        case LogInFacebook:{
            if([[FBSingleton sharedInstance] isLogIn] ){
            //!!!!!!!!!!!!!When Databases kick in, check if it is a registered user.
            //current status, use all facebook users as registered users
            [self performSegueWithIdentifier:PlayToStatusSegue sender:sender];
            }
            break;
        }
        case LogInEmail:{
            break;
        }
        default:{
            [self performSegueWithIdentifier:PlayToSelectLogInSegue sender:sender];
            break;
        }
    }
}

-(IBAction)opt_touched:(id)sender{

}

-(IBAction)Friend_touched:(id)sender{
    if ([fbs isLogIn]){
        [[FBSingleton sharedInstance] RequestFriendList];
        [self performSegueWithIdentifier:PlayToFriendSegue sender:friend_but];
    }
}
        

//FBSingleton Delegate:

-(void) FBProfilePictureLoaded:(UIImage *)img{
    LoginAccountImageView.image = img;
    NSLog(@"profilepictureloaded profileimage: %@",LoginAccountImageView.image);
}

-(void)FBSingletonDidLogout {
    self.LoginAccountImageView.image = nil;
    [self dismissModalViewControllerAnimated:YES];
    [[UserInfo sharedInstance] setCurrentLogInType:NotLogIn];
}

-(void)FBSingletonDidLogin:(NSString *)userId :(NSString *)userName :(NSString *)gender {
    //[[FBSingleton sharedInstance] RequestMeProfileImage];
    [[UserInfo sharedInstance] setCurrentLogInType:LogInFacebook];
    [[UserInfo sharedInstance] setUserId:userId];
    [[UserInfo sharedInstance] setUserName:userName];
    [[UserInfo sharedInstance] setGender:gender];
    [self.navigationController popViewControllerAnimated:YES];
    [[FBSingleton sharedInstance] RequestMe];
}

-(void) FBSIngletonUserFriendsDidLoaded:(NSArray *)friends{
    friendVC.resultData = friends;
    [friendVC.spinner removeSpinner];
    [friendVC.friendTable reloadData];
}


-(void) FbMeLoaded:(NSString *)userId :(NSString *)userName : (NSString *)gender{
    if (userId != nil){
        [usr setUserId:userId];
        [usr setUserName:userName];
        [usr setGender:gender];
        
        NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", userId];   
        [LoginAccountImageView setImageWithURL:[NSURL URLWithString:formatting]];
        //LoginAccountImageView.image = [gmethods imageForObject:userId];
    }
}

///////////////////////////
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PlayToSelectLogInSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToStatusSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToFriendSegue]){
        friendVC = segue.destinationViewController;
        //[(FriendsViewController *)segue.destinationViewController   setResultData:FriendsData];
        //FriendsData = nil;
        //FriendsViewController *fvc = (FriendsViewController *)segue.destinationViewController;
        //fvc.resultData = [[NSMutableArray alloc] initWithArray:FriendsData copyItems:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
