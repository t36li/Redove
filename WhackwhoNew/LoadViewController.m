//
//  LoadViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "LoadViewController.h"
#import "Reachability.h"

#define networkErrorAlert 1
#define newbieAlert 2
#define FBprofileLoadFailedAlert 3

@implementation LoadViewController

@synthesize myLabel;
@synthesize internetActive, hostActive;

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
            if ([[FBSingletonNew sharedInstance] isLogin]){
                [[FBSingletonNew sharedInstance] populateUserDetails];
            }else{
                [[FBSingletonNew sharedInstance] openSession];
            }
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
    
    //NSLog(@"load Background");
    //[gmethods setViewBackground:loading_bg viewSender:self.view];
    
    NSLog(@"load Loading Background");
    [myLabel setText:@"Loading...."];
    
}

- (void) checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            self.internetActive = NO;
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry, there's no active internet connection to your device~ Please find one ASAP to enjoy Whackwho!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
            
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
            
        }
    }
    
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    hostReachable = [Reachability reachabilityWithHostname:@"www.whackwho.com"];
    [hostReachable startNotifier];

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

-(void) viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Loading Error" message:@"Database Connection Failed: unable to pull out your profile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

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
