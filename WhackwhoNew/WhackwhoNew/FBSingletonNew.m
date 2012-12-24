//
//  FBSingletonNew.m
//  WhackwhoNew
//
//  Created by chun su on 2012-11-19.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FBSingletonNew.h"
#import "FBSBJSON.h"

@implementation FBSingletonNew
@synthesize delegate;
@synthesize facebook,openedURL;

static FBSingletonNew *singletonDelegate = nil;

-(id)init{
    if ((self = [super init])){
        //if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
       //     [self openSession];
        //}
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
    if (FBSession.activeSession.state == FBSessionStateOpen){
        NSLog(@"FB status: on");
        return YES;
        
    }else {
        NSLog(@"FB status: not logged in");
        return NO;
    }
}

///***********
//****Facebook Requests
//************/
//- (void)sendRequest {
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"Check out this awesome app.",  @"message",
//                                   nil];
//    
//    [self.facebook dialog:@"apprequests"
//                andParams:params
//              andDelegate:nil];
//}


//Facebook perform login:
-(void)performLogin{
    [self openSession];
}

-(void)performLogout{
    NSLog(@"FB Logout");
    [FBSession.activeSession closeAndClearTokenInformation];
    [[UserInfo sharedInstance] closeInstance];
    [delegate FBLogOutSuccess];
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
                 [[UserInfo sharedInstance] setCurrentLogInType:LogInFacebook];
                 [[UserInfo sharedInstance] setUserId:user.id];
                 [[UserInfo sharedInstance] setUserName:user.name];
                 [[UserInfo sharedInstance] setGender:[user objectForKey:@"gender"]];
                 //profileImageView.profileID = user.id;
                 NSLog(@"facebook user loaded: UserInfo:[id:%@, name:%@, gender:%@]",user.id,user.username,[user objectForKey:@"gender"]);
                 [delegate FBUserProfileLoaded];
             }else{
                 [delegate FBUserProfileLoadFailed:error];
             }
         }];
    }else{
        [self openSession];
    }
}

-(void)RequestAllFriends{
    if ([self isLogin] == YES){
        
    }
}

//FB Login:
- (void)openSession
{
    if (FBSession.activeSession.state != FBSessionStateCreated){
        FBSession.activeSession = [[FBSession alloc] init];
    }
    if (!FBSession.activeSession.isOpen){
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
        }];
    }
        //if (Session.state == FBSessionStateCreatedTokenLoaded){
        
        //}
    
//    if (!FBSession.activeSession.isOpen)
//        [FBSession.activeSession openWithCompletionHandler:
//         ^(FBSession *session,
//           FBSessionState state, NSError *error) {
//             [self sessionStateChanged:session state:state error:error];
//         }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            if (!error){
                NSLog(@"Facebook Login Response: success");
                self.facebook = [[Facebook alloc] initWithAppId:FBSession.activeSession.appID andDelegate:nil];
                
                // Store the Facebook session information
                self.facebook.accessToken = FBSession.activeSession.accessToken;
                self.facebook.expirationDate = FBSession.activeSession.expirationDate;
                
                //set up login type:
                [[UserInfo sharedInstance] LogInTypeChanged:LogInFacebook];
                [self populateUserDetails];
                //[delegate FBperformLogInSuccess];
            }
        }
    
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            //            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            self.facebook = nil;
            
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
//
///*
// * Opens a Facebook session and optionally shows the login UX.
// */
//- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
//    return [FBSession openActiveSessionWithReadPermissions:nil
//                                              allowLoginUI:allowLoginUI
//                                         completionHandler:^(FBSession *session,
//                                                             FBSessionState state,
//                                                             NSError *error) {
//                                             [self sessionStateChanged:session
//                                                                 state:state
//                                                                 error:error];
//                                         }];
//}

/*
 *
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
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

-(void) requestFriendsUsing{
    NSMutableArray *players = [[NSMutableArray alloc] init];
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys: @"id,installed", @"fields",
                                                                      nil]
                                 HTTPMethod:nil completionHandler:^(FBRequestConnection *connection,
                                                                    id result,
                                                                    NSError *error) {
                                     if (!error) {
                                         // Get the result
                                         NSArray *resultData = [result objectForKey:@"data"];
                                         // Check we have data
                                         if ([resultData count] > 0) {
                                             // Loop through the friends returned
                                             for (NSDictionary *friendObject in resultData) {
                                                 if ([friendObject objectForKey:@"installed"]){
                                                     Friend *f = [[Friend alloc] init];
                                                     f.user_id = [friendObject objectForKey:@"id"];
                                                     f.mediaType_id = [NSString stringWithFormat:@"%d",LogInFacebook];
                                                     [players addObject:f];
                                                 }
                                             }
                                         }
                                     }
                                         FriendArray *friendArray = [[FriendArray alloc] init];
                                     friendArray.friends = players;
                                     [[UserInfo sharedInstance] setFriendArray:friendArray];
                                     [delegate loadPlayerListCompleted:friendArray];
                                 }];
    
}

/*
 * Send a request to get only iOS users. Used to target requests.
 */
- (void) requestFriendsUsingDevice:(NSString *)device {
    NSMutableArray *deviceFilteredFriends = [[NSMutableArray alloc] init];
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:[NSDictionary
                                             dictionaryWithObjectsAndKeys:
                                             @"id,devices", @"fields",
                                             nil]
                                 HTTPMethod:nil
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error) {
                                  // Get the result
                                  NSArray *resultData = [result objectForKey:@"data"];
                                  // Check we have data
                                  if ([resultData count] > 0) {
                                      // Loop through the friends returned
                                      for (NSDictionary *friendObject in resultData) {
                                          // Check if devices info available
                                          if ([friendObject objectForKey:@"devices"]) {
                                              NSArray *deviceData = [friendObject
                                                                     objectForKey:@"devices"];
                                              // Loop through list of devices
                                              for (NSDictionary *deviceObject in deviceData) {
                                                  // Check if there is a device match
                                                  if ([device isEqualToString:
                                                       [deviceObject objectForKey:@"os"]]) {
                                                      // If there is a match, add it to the list
                                                      [deviceFilteredFriends addObject:
                                                       [friendObject objectForKey:@"id"]];
                                                      break;
                                                  }
                                              }
                                          }
                                      }
                                  }
                              }
                              // Send request
                              [self sendRequest:deviceFilteredFriends];
                          }];
}

///*
// * Send a user to user requests
// */
//- (void)sendRequest {
//    FBSBJSON *jsonWriter = [FBSBJSON new];
//    NSDictionary *gift = [NSDictionary dictionaryWithObjectsAndKeys:
//                          @"5", @"social_karma",
//                          @"1", @"badge_of_awesomeness",
//                          nil];
//    
//    NSString *giftStr = [jsonWriter stringWithObject:gift];
//    NSMutableDictionary* params =
//    [NSMutableDictionary dictionaryWithObjectsAndKeys:
//     @"Learn how to make your iOS apps social.", @"message",
//     giftStr, @"data",
//     nil];
//    
//    [self.facebook dialog:@"apprequests"
//                andParams:params
//              andDelegate:self];
//}
//
//- (void)sendRequestToiOSFriends {
//    // Filter and only show friends using iOS
//    [self requestFriendsUsingDevice:@"iOS"];
//}

- (void)sendRequest {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Check out this awesome app.",  @"message",
                                   nil];
    
    [self.facebook dialog:@"apprequests"
                andParams:params
              andDelegate:nil];
}

/*
 * Send a user to user request, with a targeted list
 */
- (void)sendRequest:(NSArray *) targeted {
    FBSBJSON *jsonWriter = [FBSBJSON new];
    NSDictionary *gift = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"5", @"social_karma",
                          @"1", @"badge_of_awesomeness",
                          nil];
    
    NSString *giftStr = [jsonWriter stringWithObject:gift];
    NSMutableDictionary* params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Learn how to make your iOS apps social.",  @"message",
     giftStr, @"data",
     nil];
    
    // Filter and only show targeted friends
    if (targeted != nil && [targeted count] > 0) {
        NSString *selectIDsStr = [targeted componentsJoinedByString:@","];
        [params setObject:selectIDsStr forKey:@"suggestions"];
    }
    
    [self.facebook dialog:@"apprequests"
                andParams:params
              andDelegate:self];
}


/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


/*
 * Helper function to check incoming URL
 */
- (void) checkIncomingNotification {
    if (self.openedURL) {
        NSString *query = [self.openedURL fragment];
        if (!query) {
            query = [self.openedURL query];
        }
        NSDictionary *params = [self parseURLParams:query];
        // Check target URL exists
        NSString *targetURLString = [params valueForKey:@"target_url"];
        if (targetURLString) {
            NSURL *targetURL = [NSURL URLWithString:targetURLString];
            NSDictionary *targetParams = [self parseURLParams:[targetURL query]];
            NSString *ref = [targetParams valueForKey:@"ref"];
            // Check for the ref parameter to check if this is one of
            // our incoming news feed link, otherwise it can be an
            // an attribution link
            if ([ref isEqualToString:@"notif"]) {
                // Get the request id
                NSString *requestIDParam = [targetParams
                                            objectForKey:@"request_ids"];
                NSArray *requestIDs = [requestIDParam
                                       componentsSeparatedByString:@","];
                
                // Get the request data from a Graph API call to the
                // request id endpoint
                [self notificationGet:[requestIDs objectAtIndex:0]];
            }
        }
        // Clean out to avoid duplicate calls
        self.openedURL = nil;
    }
}

/*
 * Helper function to get the request data
 */
- (void) notificationGet:(NSString *)requestid {
    [FBRequestConnection startWithGraphPath:requestid
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error) {
                                  NSString *title;
                                  NSString *message;
                                  if ([result objectForKey:@"data"]) {
                                      title = [NSString
                                               stringWithFormat:@"%@ sent you a gift",
                                               [[result objectForKey:@"from"]
                                                objectForKey:@"name"]];
                                      FBSBJSON *jsonParser = [FBSBJSON new];
                                      NSDictionary *requestData =
                                      [jsonParser
                                       objectWithString:[result objectForKey:@"data"]];
                                      message =
                                      [NSString stringWithFormat:@"Badge: %@, Karma: %@",
                                       [requestData objectForKey:@"badge_of_awesomeness"],
                                       [requestData objectForKey:@"social_karma"]];
                                  } else {
                                      title = [NSString
                                               stringWithFormat:@"%@ sent you a request",
                                               [[result objectForKey:@"from"] objectForKey:@"name"]];
                                      message = [NSString stringWithString:
                                                 [result objectForKey:@"message"]];
                                  }
                                  UIAlertView *alert = [[UIAlertView alloc]
                                                        initWithTitle:title
                                                        message:message
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil,
                                                        nil];
                                  [alert show];
                                  
                                  // Delete the request notification
                                  [self notificationClear:[result objectForKey:@"id"]];
                              }
                          }];
}

/*
 * Helper function to delete the request notification
 */
- (void) notificationClear:(NSString *)requestid {
    // Delete the request notification
    [FBRequestConnection startWithGraphPath:requestid
                                 parameters:nil
                                 HTTPMethod:@"DELETE"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error) {
                                  NSLog(@"Request deleted");
                              }
                          }];
}

#pragma mark - Facebook Dialog delegate methods
// Handle the request call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSDictionary *params = [self parseURLParams:[url query]];
    NSString *requestID = [params valueForKey:@"request"];
    NSLog(@"Request ID: %@", requestID);
}

@end
