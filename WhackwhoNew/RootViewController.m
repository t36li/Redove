//
//  RootViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "RootViewController.h"
#import "StatusBarController.h"
#import "SelectToLoginViewController.h"
#import "AvatarViewController.h"
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
#define PlayToFriendSegue @"PlayToFriendSegue"
#define SelectToLoginToAvatar @"SelectToLoginToAvatar"

#define networkErrorAlert 1
#define newbieAlert 2

//static NSArray *FriendsData = nil;


@implementation RootViewController
@synthesize play_but,opt_but;
@synthesize profileImageView;

-(void) viewDidLoad
{
    //NSLog(@"RootViewController viewDidLoad");
    [super viewDidLoad];
    usr = [UserInfo sharedInstance];
    fbs = [FBSingletonNew sharedInstance];
    
    GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    [gmethods setViewBackground:MainPage_bg viewSender:self.view];
    NSLog(@"RootViewController: Background loaded");
}


-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"RootViewController: load Profile Image");
    if ([fbs isLogin] == YES){
        self.profileImageView.profileID = [usr userId];
    }else{
        profileImageView.profileID = nil;
    }
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
        [self performSegueWithIdentifier:PlayToFriendSegue sender:friend_but];
}


-(IBAction)upload_clicked:(id)sender {
    RKParams* params = [RKParams params];
   // NSArray *items = [[NSArray alloc] initWithObjects:@"hammer.png", @"pinky head.png", @"bomb.png", nil];
    
    //for (NSString *filename in items) {
        //[params setValue:[NSString stringWithFormat:@"%d",user.whackWhoId] forParam:@"ItemID"];
        [params setValue:@"bomb" forParam:@"FileName"];
        [params setValue:[NSString stringWithFormat:@"%d", 200] forParam:@"PropertyID"];
        [params setValue:[NSString stringWithFormat:@"%d", 20] forParam:@"BodyPartID"];
        
        //UIImage *uploadImage = usrInfo->croppedImage;//[UIImage imageNamed:@"pause.png"];//usrInfo->usrImg;
        //NSData* imageData = UIImagePNGRepresentation(uploadImage);
        //[params setData:imageData MIMEType:@"image/png" forParam:[NSString stringWithFormat:@"%d",user.headId]];
        
        // Log info about the serialization
        NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
        
       // [[RKObjectManager sharedManager].client post:@"/uploadImage" params:params delegate:self];
}

//-(void) FBLogOutSuccess{
//    profileImageView.profileID = nil;
//}


-(void)FBSingletonDidLogout {
    //self.LoginAccountImageView.image = nil;
    [[UserInfo sharedInstance] clearUserInfo];
    [[UserInfo sharedInstance] setCurrentLogInType:NotLogIn];
    
    [self dismissModalViewControllerAnimated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) FBSIngletonFriendsDidLoaded:(NSDictionary *)friends{
    friendVC.resultData = [[NSArray alloc] initWithArray:[friends allValues]];
    [friendVC.spinner removeSpinner];
    [friendVC.friendTable reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PlayToSelectLogInSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToStatusSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToFriendSegue]){
        //self.friendVC = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:SelectToLoginToAvatar]){
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
