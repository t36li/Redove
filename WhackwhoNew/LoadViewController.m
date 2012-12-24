//
//  LoadViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "LoadViewController.h"

#define networkErrorAlert 1
#define newbieAlert 2
#define FBprofileLoadFailedAlert 3

@implementation LoadViewController

@synthesize myLabel;

-(void) initializeConnections {
    gmethods = [[GlobalMethods alloc] init];
    usr = [UserInfo sharedInstance];
    //[[FBSingleton sharedInstance] setDelegate:self];
    
    NSLog(@"Load/set currentLogInType");
    int loginId =((int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs] == 0)? 0 : (int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs];
    [usr setCurrentLogInType:loginId];
    
    NSLog(@"login type ID: %i", loginId);
    switch (loginId) {
        case NotLogIn:{
            NSLog(@"login type : Not Logged in!");
            [self performSegueWithIdentifier:@"LoginToFacebook" sender:nil];
        }
            break;
        case LogInFacebook:{
            //fbs = [FBSingletonNew sharedInstance];
            //if ([fbs isLogin]==YES){
            //    [fbs populateUserDetails];
            //}
            //[[FBSingletonNew sharedInstance] openSession];
            [[FBSingletonNew sharedInstance] populateUserDetails];
        }
            break;
        case LogInGmail:
        case LogInRenren:
        case LogInEmail:
        default:{
            [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"login type : Not Logged in!");
            [self performSegueWithIdentifier:@"LoginToFacebook" sender:nil];
        }
            
            break;
    }
    
    NSLog(@"load Background");
    [gmethods setViewBackground:loading_bg viewSender:self.view];
    
    NSLog(@"load Loading Background");
    [myLabel setText:@"Loading...."];
}

-(void) viewDidLoad {
    [super viewDidLoad];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

-(void) viewDidAppear:(BOOL)animated{
    [FBSingletonNew sharedInstance].delegate = self;
    [self initializeConnections];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark- facebook delegate methods


-(void) FBUserProfileLoaded{
    [self connToDB];

}

-(void) FBUserProfileLoadFailed:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Facebook Error" message:[NSString stringWithFormat:@"Facebook profile failed to load: %@",error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.tag = FBprofileLoadFailedAlert;
    [errorAlert show];
    
}

//-(void) FBLogOutSuccess{
//    [[UserInfo sharedInstance] setCurrentLogInType:NotLogIn];
//    [self dismissModalViewControllerAnimated:YES];
//    [self goToMenu];
//}
#pragma mark- database delegate methods

//////////////////////Database REST:

-(void)connToDB{
    //User: a static class for loading userInfo
    User *user = [User alloc];
    [user getFromUserInfo];
    //[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@""];
    [[RKObjectManager sharedManager] getObject:user usingBlock:^(RKObjectLoader *loader){
        loader.targetObject = nil;
        loader.delegate = self;
    }];// get if not ...post
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"request: '%@'",[request HTTPBodyString]);
    NSLog(@"request Params: %@", [request params]);
    NSLog(@"response code: %d",[response statusCode]);
    
    
    if ([request isGET]) {
        if ([response isOK]) {
            NSLog(@"Retrieved JSON:%@",[response bodyAsString]);
        }
    }
    if ([request isPOST]) {
        if ([response isOK]){
            NSLog(@"create succeed.");
            NSLog(@"%@",response.bodyAsString);
        }
    }
    
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Network Connection Failed: the new user failed to generate account!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.tag = networkErrorAlert;
    [errorAlert show];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    User *userObject = [User alloc];
    userObject = object;
    [userObject copyToUserInfo];
    NSLog(@"User data loaded.");
    [myLabel setText:@"Loading Complete!"];
    [self performSelector:@selector(goToMenu) withObject:nil afterDelay:1.5];
    /*
    if(usr->usrImg == nil){
        UIAlertView *takePicAlert = [[UIAlertView alloc] initWithTitle:@"Newbie?" message:@"Take a photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        takePicAlert.tag = newbieAlert;
        [takePicAlert show];
    } else {
        [myLabel setText:@"Loading Complete!"];
        [self performSelector:@selector(goToMenu) withObject:nil afterDelay:1.5];
    }*/
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Loading Error" message:@"Database Connection Failed: unable to pull out your profile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    /*
    if (alertView.tag == networkErrorAlert){
        
    }
    else if (alertView.tag == newbieAlert){
        if (buttonIndex == 0){
            [self performSegueWithIdentifier:@"LoadToAvatar" sender:self];
        }
    }
     */
    if (alertView.tag == FBprofileLoadFailedAlert){
        [usr LogInTypeChanged:NotLogIn];
        [self goToMenu];
    }
}



-(void) goToMenu {
    [self performSegueWithIdentifier:@"GoToMenuSegue" sender:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
