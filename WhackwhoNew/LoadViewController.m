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

@implementation LoadViewController

@synthesize myLabel;

-(void) initializeConnections {
    gmethods = [[GlobalMethods alloc] init];
    usr = [UserInfo sharedInstance];
    [[FBSingleton sharedInstance] setDelegate:self];
    
    NSLog(@"Load/set currentLogInType");
    int loginId =((int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs] == 0)? 0 : (int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs];
    [usr setCurrentLogInType:loginId];
    
    NSLog(@"login type ID: %i", loginId);
    if (loginId == 0){
        [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"login type : Not Logged in!");
        [self performSegueWithIdentifier:@"LoginToFacebook" sender:nil];
    }
    

    
    NSLog(@"load Background");
    [gmethods setViewBackground:loading_bg viewSender:self.view];
    
    NSLog(@"load Loading Background");
    [myLabel setText:@"Loading...."];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Load/set currentLogInType");
    int loginId =((int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs] == 0)? 0 : (int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs];
    usr = [UserInfo sharedInstance];
    [usr setCurrentLogInType:loginId];
    //NSLog(@"load UserInfo");
    switch ((int)[usr currentLogInType]) {
        case LogInFacebook:
            fbs = [FBSingleton sharedInstance];
            if ([fbs isLogIn]) [fbs RequestMe];
            break;
        case NotLogIn:
        default:
            break;
    }

}

-(void) viewDidAppear:(BOOL)animated{
    [self initializeConnections];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark- facebook delegate methods
-(void) FBProfilePictureLoaded:(UIImage *)img{
    //LoginAccountImageView.image = img;
    //NSLog(@"profilepictureloaded profileimage: %@",LoginAccountImageView.image);
}

-(void)FBSingletonDidLogin:(NSString *)userId :(NSString *)userName :(NSString *)gender {
    //[[FBSingleton sharedInstance] RequestMeProfileImage];
    [[UserInfo sharedInstance] setCurrentLogInType:LogInFacebook];
    [[UserInfo sharedInstance] setUserId:userId];
    [[UserInfo sharedInstance] setUserName:userName];
    [[UserInfo sharedInstance] setGender:gender];
    [[FBSingleton sharedInstance] RequestMe];
}

-(void) FBSIngletonUserFriendsDidLoaded:(NSArray *)friends{
    //friendVC.resultData = friends;
    //[friendVC.spinner removeSpinner];
    //[friendVC.friendTable reloadData];
}


-(void) FbMeLoaded:(NSString *)userId :(NSString *)userName : (NSString *)gender{
    if (userId != nil){
        [[UserInfo sharedInstance] setUserId:userId];
        [[UserInfo sharedInstance] setUserName:userName];
        [[UserInfo sharedInstance] setGender:gender];
        NSLog(@"my Facebook: {ID: %@, Name: %@, gender: %@",userId,userName,gender);
        
        //NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", userId];
        //[LoginAccountImageView setImageWithURL:[NSURL URLWithString:formatting]];
        //NSLog(@"Facebook profile picture loaded");
        
        NSLog(@"Fetch/Create Database record: starting...");
        
        [self performSelectorInBackground:@selector(connToDB) withObject:nil];
        //test upload image
        //[self testUploadImage];
    }
    
    if ([self.navigationController topViewController] != self)
        [self.navigationController popToRootViewControllerAnimated:YES];

}

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
/*
 -(void)testUploadImage{
 ///////////////////////testing... uploading a picture
 UIImage *testProfileImage = [UIImage imageNamed:@"hammer.png"];
 RKParams* params = [RKParams params];
 
 NSData* imageData = UIImagePNGRepresentation(testProfileImage);
 [params setData:imageData MIMEType:@"image/png" forParam:@"image1"];
 
 // Log info about the serialization
 NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
 
 // Send it for processing!
 [[RKObjectManager sharedManager].client post:@"/userImage" params:params delegate:self];
 }
 
 */

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
    if(usr->usrImg == nil){
        UIAlertView *takePicAlert = [[UIAlertView alloc] initWithTitle:@"Newbie?" message:@"Take a photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        takePicAlert.tag = newbieAlert;
        [takePicAlert show];
    } else {
        [myLabel setText:@"Loading Complete!"];
        [self performSelector:@selector(goToMenu) withObject:nil afterDelay:1.5];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Loading Error" message:@"Database Connection Failed: unable to pull out your profile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == networkErrorAlert){
        
    }
    else if (alertView.tag == newbieAlert){
        if (buttonIndex == 0){
            [self performSegueWithIdentifier:@"LoadToAvatar" sender:self];
        }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
