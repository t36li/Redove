//
//  FBSingleton.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-03.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FBSingleton.h"
#import "UserInfo.h"


static NSString* kAppId = @"442728025757863"; // Facebook app ID here

@implementation FBSingleton
@synthesize facebook = _facebook;
@synthesize delegate, isLogIn;

#pragma mark -
#pragma mark Singleton Variables
static FBSingleton *singletonDelegate = nil;

#pragma mark -
#pragma mark Singleton Methods
- (id)init {
    if (!kAppId) {
        NSLog(@"MISSING APP ID!!!");
        exit(1);
        return nil;
    }
    if ((self = [super init])) {
        // Initialize Facebook
        _facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
        
        // Check and retrieve authorization information

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults objectForKey:FBAccessToken] && [defaults objectForKey:FBExpirationDateKey] && [defaults integerForKey:LogInAs] == LogInFacebook) {
            _facebook.accessToken = [defaults objectForKey:FBAccessToken];
            _facebook.expirationDate = [defaults objectForKey:FBExpirationDateKey];
            NSLog(@"FB AccessToken and EDate Initialized: '%@' and '%@'",_facebook.accessToken,_facebook.expirationDate);
        }
        
        
        //_permissions =  [[NSArray arrayWithObjects: @"read_stream", @"publish_stream", @"offline_access",nil] retain];
        _permissions =  [NSArray arrayWithObjects: @"read_stream", @"publish_stream", nil];
        
        //_permissions =  [NSArray arrayWithObjects:@"publish_stream", nil];
        
        if ([_facebook isSessionValid]){
            [self setIsLogIn:YES];
        }else {
            [self setIsLogIn:NO];
        }
    }
    
    return self;
}

+ (FBSingleton *)sharedInstance {
	@synchronized(self) {
		if (singletonDelegate == nil) {
			singletonDelegate = [[self alloc] init]; // assignment not done here
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

#pragma mark - Private Methods


-(NSMutableDictionary*) buildPostParamsWithHighscore:(int)highscore {
    NSString *customMessage = [NSString stringWithFormat:kCustomMessage, highscore, kAppName]; 
    NSString *postName = kAppName; 
    NSString *serverLink = [NSString stringWithFormat:kServerLink];
    NSString *imageSrc = kImageSrc;
    
    // Final params build.
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   //@"message", @"message",
                                   imageSrc, @"picture",
                                   
                                   serverLink, @"link",
                                   postName, @"name",
                                   @" ", @"caption",
                                   customMessage, @"description",
                                   nil];
    
    return params;
}

-(void) postToWallWithDialogNewHighscore {
    NSMutableDictionary* params = [self buildPostParamsWithHighscore:score];
    
    // Post on Facebook.
    [_facebook dialog:@"feed" andParams:params andDelegate:self];
}

/*
 * Helper method to return the picture endpoint for a given Facebook
 * object. Useful for displaying user, friend, or location pictures.
 */
- (UIImage *)imageForObject:(NSString *)objectID {
    // Get the object image
    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return image;
}


#pragma mark - Public Methods

-(void) postToWallWithDialogNewHighscore:(int)highscore {
    score = highscore;
    
    if ([_facebook isSessionValid]) {
        [self postToWallWithDialogNewHighscore];
    }
}

-(void) login {
    // Check if there is a valid session
    if (!self.isLogIn) {
        [_facebook authorize:nil];
    }
    //else {
    //    [_facebook requestWithGraphPath:@"me" andDelegate:self];
    //}
    
    //[self postToWallWithDialogNewHighscore];
}

-(void) logout{
    [_facebook logout]; 
}

/*
 * --------------------------------------------------------------------------
 * Graph API
 * --------------------------------------------------------------------------
 */

/*
 * Graph API: Get the user's basic information, picking the name and picture fields.
 */


-(void) RequestMe{
    // Check if there is a valid session
    if (self.isLogIn){
        
        currentAPICall = kAPIGraphMe;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"name,picture",  @"fields",
                                       nil];
        [_facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
    }
}

-(void) RequestMeLogIn{
    if (self.isLogIn){
        currentAPICall = kAPIGraphMeLogIn;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"name,picture",  @"fields",
                                       nil];
        [_facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
    }
}

-(void) RequestFriendList{
    // Check if there is a valid session
    if (self.isLogIn){
        currentAPICall = kAPIGraphUserFriends;
        [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
    }
}

#pragma mark - FBDelegate Methods

- (void)fbDidLogin {
    NSLog(@"FB login OK");
    
    // Store session info.
    [[NSUserDefaults standardUserDefaults] setObject:_facebook.accessToken forKey:FBAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:_facebook.expirationDate forKey:FBExpirationDateKey];
    [[NSUserDefaults standardUserDefaults] setInteger:LogInFacebook forKey:LogInAs];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setIsLogIn:YES];
    [[UserInfo sharedInstance] setCurrentLogInType:LogInFacebook];
    NSLog(@"FBDidLogin AccessToken and EDate: '%@' and '%@'",_facebook.accessToken, _facebook.expirationDate);
    
    [self RequestMeLogIn];
    
    NSLog(@" FB set AccessToken and Expiration Date");
}


/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"FB did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    NSLog(@"FB logout OK");
    
    // Release stored session.
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FBAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FBExpirationDateKey];
    [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setIsLogIn:NO];
    
    
    NSLog(@"FBDidLogout AccessToken and EDate: '%@' and '%@'",_facebook.accessToken, _facebook.expirationDate);
    
    [delegate FBSingletonDidLogout];
    
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated {
    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    switch (currentAPICall) {
            
        case kAPIGraphMe:{
            //show profile result;
            NSLog(@"Me result loaded ");
            [delegate FbMeLoaded:[result objectForKey:@"id"]:[result objectForKey:@"name"]];
            break;       
        }
        case kAPIGraphMeLogIn:{
            //show profile result;
            NSLog(@"Me LogIn result loaded ");
            [delegate FBSingletonDidLogin:[result objectForKey:@"id"]:[result objectForKey:@"name"]];
            break;       
        }
        case kAPIGraphUserFriends:{
            
            NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] > 0) {
                for (NSUInteger i=0; i<[resultData count] /*&& i < 25*/; i++) {
                    [friends addObject:[resultData objectAtIndex:i]];
                }
                // Show the friend information in a new view controller with FBSingleton Delegate
                [delegate FBSIngletonUserFriendsDidLoaded:friends];
            } else {
                [delegate FBSIngletonUserFriendsDidLoaded:nil];
            }
            break;
        }
    }
}


/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"FB error: %@", [error localizedDescription]);
}

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"published successfully on FB");
}


@end
