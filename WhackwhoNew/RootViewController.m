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


@interface RootViewController (){
    @private
    UserInfo *usr;
    FBSingleton *fbs;
    GlobalMethods *gmethods;
}
@end

@implementation RootViewController
@synthesize LoginAccountImageView;
@synthesize play_but,opt_but, friendVC;

-(void) viewDidLoad
{
    //NSLog(@"RootViewController viewDidLoad");
    [super viewDidLoad];
    
    gmethods = [[GlobalMethods alloc] init];
    usr = [UserInfo sharedInstance];
    fbs = [FBSingleton sharedInstance];
    
    if (LoginAccountImageView.image == nil) {
        NSLog(@"Load/set currentLogInType");
        int loginId =((int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs] == 0)? 0 : (int)[[NSUserDefaults standardUserDefaults] integerForKey:LogInAs];
        [usr setCurrentLogInType:loginId];
        NSLog(@"login type ID: %i", loginId);
        if (loginId == 0){
            [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"login type : Not Login");
        }
        
        NSLog(@"load UserInfo");
        switch ((int)[usr currentLogInType]) {
            case LogInFacebook:
                [[FBSingleton sharedInstance] setDelegate:self];
                fbs = [FBSingleton sharedInstance];
                if ([fbs isLogIn])[fbs RequestMe];
                break;
            default:
                break;
        }
    }
    
    NSLog(@"load Background");
    [gmethods setViewBackground:MainPage_bg viewSender:self.view];
    
    NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[UserInfo sharedInstance] userId]];
    [LoginAccountImageView setImageWithURL:[NSURL URLWithString:formatting]];
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
        /********
        [[FBSingleton sharedInstance] RequestFriendList];
        [self performSegueWithIdentifier:PlayToFriendSegue sender:friend_but];
         ********/
        
    }
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
        
        [[RKObjectManager sharedManager].client post:@"/uploadImage" params:params delegate:self];
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
    //[self.navigationController popViewControllerAnimated:YES];
    [[FBSingleton sharedInstance] RequestMe];
    
    
}

-(void) FBSIngletonUserFriendsDidLoaded:(NSArray *)friends{
    friendVC.resultData = friends;
    [friendVC.spinner removeSpinner];
    [friendVC.friendTable reloadData];
}


-(void) FbMeLoaded:(NSString *)userId :(NSString *)userName : (NSString *)gender{
    if (userId != nil){
        [[UserInfo sharedInstance] setUserId:userId];
        [[UserInfo sharedInstance] setUserName:userName];
        [[UserInfo sharedInstance] setGender:gender];
        NSLog(@"my Facebook: {ID: %@, Name: %@, gender: %@",userId,userName,gender);
        
        NSLog(@"Setting profile picture...");
        NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[UserInfo sharedInstance] userId]];
        [LoginAccountImageView setImageWithURL:[NSURL URLWithString:formatting]];
        
        NSLog(@"Fetch/Create Database record: starting...");
        
        [self performSelectorInBackground:@selector(connToDB) withObject:nil];
        //test upload image
        //[self testUploadImage];
    }
}

//////////////////////Database REST:

-(void)connToDB{
    //User: a static class for loading userInfo
    User *user = [User alloc];
    [user getFromUserInfo];
    //[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@""];
    [[RKObjectManager sharedManager] postObject:user usingBlock:^(RKObjectLoader *loader){
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
    if(usr.usrImg == nil){
        UIAlertView *takePicAlert = [[UIAlertView alloc] initWithTitle:@"Newbie?" message:@"Take a photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        takePicAlert.tag = newbieAlert;
        [takePicAlert show];
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
            [self performSegueWithIdentifier:SelectToLoginToAvatar sender:self];
        }
    }
}

///////////////////////////
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PlayToSelectLogInSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToStatusSegue]){
    }
    else if ([segue.identifier isEqualToString:PlayToFriendSegue]){
        self.friendVC = segue.destinationViewController;
        //[(FriendsViewController *)segue.destinationViewController   setResultData:FriendsData];
        //FriendsData = nil;
        //FriendsViewController *fvc = (FriendsViewController *)segue.destinationViewController;
        //fvc.resultData = [[NSMutableArray alloc] initWithArray:FriendsData copyItems:YES];
    }
    else if ([segue.identifier isEqualToString:SelectToLoginToAvatar]){
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
