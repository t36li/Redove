//
//  FBSingletonNew.m
//  WhackwhoNew
//
//  Created by chun su on 2012-11-19.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FBSingletonNew.h"

@implementation FBSingletonNew
@synthesize delegate;

static FBSingletonNew *singletonDelegate = nil;

-(id)init{
    if ((self = [super init])){
        userInfo = [UserInfo sharedInstance];
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
            [self openSession];
        }
    }
    return self;
}

+ (FBSingletonNew *)sharedInstance{
    @synchronized(self){
        if (singletonDelegate == nil){
            singletonDelegate = [[self alloc] init];
        }
    }
    return singletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (singletonDelegate == nil) {
			singletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return singletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}


- (id)copyWithZone:(NSZone *)zone {
	return self;
}


//Facebook status
-(BOOL)isLogin{
    [self performLogin];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
        NSLog(@"FB status: on");
        return YES;
        
    }else {
        NSLog(@"FB status: not logged in");
        return NO;
    }
}
/***********
****Facebook Requests
************/
//Facebook perform login:
-(void)performLogin{
    [self openSession];
}

-(void)performLogout{
    NSLog(@"FB Logout");
    if ([self isLogin] == YES)
        [FBSession.activeSession closeAndClearTokenInformation];
    
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 
                 //populate userInfo:
                 [userInfo setCurrentLogInType:LogInFacebook];
                 [userInfo setUserId:user.id];
                 [userInfo setUserName:user.name];
                 [userInfo setGender:[user objectForKey:@"gender"]];
                 NSLog(@"UserInfo:[id:%@, name:%@, gender:%@]",user.id,user.username,[user objectForKey:@"gender"]);
                 [delegate FBLogInUserLoadedSuccess];
             }
         }];
    }
}

-(void)RequestFriendsAll{
    
}

//FB Login:
- (void)openSession
{
    if (!FBSession.activeSession.isOpen)
        [FBSession.activeSession openWithCompletionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"Facebook Login Response: success");
            //set up login type:
            [[NSUserDefaults standardUserDefaults] setInteger:LogInFacebook forKey:LogInAs];
            [userInfo setCurrentLogInType:LogInFacebook];
            [self populateUserDetails];
            //[delegate FBperformLogInSuccess];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            //            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

@end
