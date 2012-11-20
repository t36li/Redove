 //
//  FBSingleton.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-03.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

//#import "FBSingleton.h"
//#import "UserInfo.h"
//
//
//static NSString* kAppId = @"442728025757863"; // Facebook app ID here
//
//@implementation FBSingleton
//@synthesize facebook = _facebook;
//@synthesize delegate, isLogIn, friendsDictionary,savedFriendsUsingApp;
//
//#pragma mark -
//#pragma mark Singleton Variables
//static FBSingleton *singletonDelegate = nil;

////#pragma mark -
//#pragma mark Singleton Methods
////- (id)init {
//    isLogIn = NO;
//    if (!kAppId) {
//        NSLog(@"MISSING APP ID!!!");
//        exit(1);
//        return nil;
//    }
//    if ((self = [super init])) {
//        friendsDictionary = [[NSMutableDictionary alloc] init];
//        
//        // Initialize Facebook
//        _facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
//        
//        // Check and retrieve authorization information
//
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        if ([defaults objectForKey:FBAccessToken] && [defaults objectForKey:FBExpirationDateKey] && [defaults integerForKey:LogInAs] == LogInFacebook) {
//            _facebook.accessToken = [defaults objectForKey:FBAccessToken];
//            _facebook.expirationDate = [defaults objectForKey:FBExpirationDateKey];
//            NSLog(@"FB AccessToken and FB ExpirationDateKey exist");
//        }
//        
//        
//        //_permissions =  [[NSArray arrayWithObjects: @"read_stream", @"publish_stream", @"offline_access",nil] retain];
//        _permissions =  [NSArray arrayWithObjects: @"read_stream", @"publish_stream", nil];
//        
//        //_permissions =  [NSArray arrayWithObjects:@"publish_stream", nil];
//        
//        if ([_facebook isSessionValid]){
//            isLogIn = YES;
//        }
//    }
//    
//    return self;
//}
//
//+ (FBSingleton *)sharedInstance {
//	@synchronized(self) {
//		if (singletonDelegate == nil) {
//			singletonDelegate = [[self alloc] init]; // assignment not done here
//		}
//	}
//	return singletonDelegate;
//}
//
//
//+ (id)allocWithZone:(NSZone *)zone {
//	@synchronized(self) {
//		if (singletonDelegate == nil) {
//			singletonDelegate = [super allocWithZone:zone];
//			// assignment and return on first allocation
//			return singletonDelegate;
//		}
//	}
//	// on subsequent allocation attempts return nil
//	return nil;
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//	return self;
//}
//
//#pragma mark - Private Methods
//
//
//-(NSMutableDictionary*) buildPostParamsWithHighscore:(int)highscore {
//    NSString *customMessage = [NSString stringWithFormat:kCustomMessage, highscore, kAppName]; 
//    NSString *postName = kAppName; 
//    NSString *serverLink = [NSString stringWithFormat:kServerLink];
//    NSString *imageSrc = kImageSrc;
//    
//    // Final params build.
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   //@"message", @"message",
//                                   imageSrc, @"picture",
//                                   
//                                   serverLink, @"link",
//                                   postName, @"name",
//                                   @" ", @"caption",
//                                   customMessage, @"description",
//                                   nil];
//    
//    return params;
//}
//
//-(void) postToWallWithDialogNewHighscore {
//    NSMutableDictionary* params = [self buildPostParamsWithHighscore:score];
//    
//    // Post on Facebook.
//    [_facebook dialog:@"feed" andParams:params andDelegate:self];
//}
//
///*
// * Helper method to return the picture endpoint for a given Facebook
// * object. Useful for displaying user, friend, or location pictures.
// */
//- (UIImage *)imageForObject:(NSString *)objectID {
//    // Get the object image
//    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//    return image;
//}
//
//
//#pragma mark - Public Methods
//
//-(void) postToWallWithDialogNewHighscore:(int)highscore {
//    score = highscore;
//    
//    if ([_facebook isSessionValid]) {
//        [self postToWallWithDialogNewHighscore];
//    }
//}
//
//-(void) login {
//    // Check if there is a valid session
//    if (!isLogIn) {
//        _permissions =  [NSArray arrayWithObjects: @"read_stream", @"publish_stream", nil];
//        [_facebook authorize:_permissions];
//    }
//    //else {
//    //    [_facebook requestWithGraphPath:@"me" andDelegate:self];
//    //}
//    
//    //[self postToWallWithDialogNewHighscore];
//}
//
//-(void) logout{
//    [_facebook logout];
//}
//
//-(void) unauthorized{
//    currentAPICall = kAPIGraphUserPermissionsDelete;
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
//    [_facebook requestWithGraphPath:@"me/permissions"
//                                    andParams:params
//                                andHttpMethod:@"DELETE"
//                                  andDelegate:self];
//}
//
///*
// * --------------------------------------------------------------------------
// * Graph API
// * --------------------------------------------------------------------------
// */
//
///*
// * Graph API: Get the user's basic information, picking the name and picture fields.
// */
//
//
//-(void) RequestMe{
//    // Check if there is a valid session
//    if (isLogIn){
//        currentAPICall = kAPIGraphMe;
//        //NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"name,picture,gender",  @"fields", nil];
//        [_facebook requestWithGraphPath:@"me" andDelegate:self];
//    }
//}
//
//-(void) RequestMeLogIn{
//    if (isLogIn){
//        currentAPICall = kAPIGraphMeLogIn;
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"name,picture,gender",  @"fields",
//                                       nil];
//        [_facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
//    }
//}
//
//-(void) RequestFriendList{
//    // Check if there is a valid session
//    if (isLogIn){
//        if (!friendsDictionary.count){
//        currentAPICall = kAPIGraphUserFriends;
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"id,name,picture,gender",  @"fields",
//                                       nil];
//        [_facebook requestWithGraphPath:@"me/friends" andParams:params andDelegate:self];
//        }else{
//            [delegate FBSIngletonFriendsDidLoaded:friendsDictionary];
//        }
//        //if (friendsDictionary.count) {
//        //    [delegate FBSIngletonUserFriendsDidLoaded:[friendsDictionary allValues]];
//        //}
//    }
//}
//
//-(void) RequestFriendsNotUsing{
//    [self RequestFriendUsing];
//    /*
//    if (isLogIn){
//        currentAPICall = kAPIGetAppUsersFriendsNotUsing; ///testing ...correct : kAPIGetAppUsersFriendsUsing
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"friends.getAppUsers", @"method",
//                                       nil];
//        [_facebook requestWithParams:params andDelegate:self];
//        
//    }*/
//}
//
//-(void) RequestHitWhoList{
//    if (isLogIn){
//        if (savedFriendsUsingApp != nil){
//            [delegate FBSingletonHitWhoIDListLoaded:savedFriendsUsingApp];
//        }else{
//            currentAPICall = kAPIGetAppUsersHitWhoList;
//            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                           @"friends.getAppUsers", @"method",
//                                           nil];
//            [_facebook requestWithParams:params andDelegate:self];
//        }
//            
//    }
//}
//
//-(void) RequestFriendUsing{
//    if (isLogIn){
//        if (savedAllFriends == nil){
//            [self RequestFriendList];
//        }else{
//        currentAPICall = kAPIGetAppUsersFriendsUsing;
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"friends.getAppUsers", @"method",
//                                       nil];
//        [_facebook requestWithParams:params andDelegate:self];
////        }
////    }
////}
////
////-(void) InviteYou:(NSString *)fbID{
////    if (isLogIn){
////        //currentAPICall = kDialogRequestsSendToTarget;
////        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
////                                      @"Come and join me to WHACK! download WhackWho.",  @"message",
////                                      @"841183328", @"to",
////                                      nil];
//        [_facebook dialog:@"apprequests" andParams:params andDelegate:nil];
//    }
//}
//
//#pragma mark - FBDelegate Methods
//
//- (void)fbDidLogin {
//    NSLog(@"FB login OK");
//    
//    // Store session info.
//    [[NSUserDefaults standardUserDefaults] setObject:_facebook.accessToken forKey:FBAccessToken];
//    [[NSUserDefaults standardUserDefaults] setObject:_facebook.expirationDate forKey:FBExpirationDateKey];
//    [[NSUserDefaults standardUserDefaults] setInteger:LogInFacebook forKey:LogInAs];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self setIsLogIn:YES];
//    NSLog(@"FBDidLogin AccessToken and EDate: '%@' and '%@'",_facebook.accessToken, _facebook.expirationDate);
//    
//    [self RequestMeLogIn];
//    
//    NSLog(@" FB set AccessToken and Expiration Date");
//}
//
//
///**
// * Called when the user canceled the authorization dialog.
// */
//-(void)fbDidNotLogin:(BOOL)cancelled {
//    NSLog(@"FB did not login");
//}
//
///**
// * Called when the request logout has succeeded.
// */
//- (void)fbDidLogout {
//    NSLog(@"FB logout OK");
//    
//    // Release stored session.
//    
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FBAccessToken];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FBExpirationDateKey];
//    [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self setIsLogIn:NO];
//    
//    
//    NSLog(@"FBDidLogout AccessToken and EDate: '%@' and '%@'",_facebook.accessToken, _facebook.expirationDate);
//    
//    [delegate FBSingletonDidLogout];
//    
//}
//
///**
// * Called after the access token was extended. If your application has any
// * references to the previous access token (for example, if your application
// * stores the previous access token in persistent storage), your application
// * should overwrite the old access token with the new one in this method.
// * See extendAccessToken for more details.
// */
//- (void)fbDidExtendToken:(NSString*)accessToken
//               expiresAt:(NSDate*)expiresAt {
//    
//}
//
///**
// * Called when the current session has expired. This might happen when:
// *  - the access token expired
// *  - the app has been disabled
// *  - the user revoked the app's permissions
// *  - the user changed his or her password
// */
//- (void)fbSessionInvalidated {
//    
//}
//
//
//- (void)parseFriendList:(NSArray *)AllFriends : (NSArray *)FriendsInApp{
//    if (!friendsDictionary.count){
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//        
//    for (NSDictionary *diction in AllFriends) {
//        NSString *userID = (NSString *)[diction objectForKey:@"id"];
//        NSString *name = (NSString *)[diction objectForKey:@"name"];
//        NSString *gender = (NSString *)[diction objectForKey:@"gender"];
//        Friend *friend = [[Friend alloc] init];
//        friend.user_id = userID;
//        friend.name = name;
//        friend.gender = gender;
//        friend.isPlayer = [FriendsInApp containsObject:[[NSDecimalNumber alloc] initWithString:userID]];
//        [dictionary setObject:friend forKey:userID];
//    }
//        [friendsDictionary addEntriesFromDictionary:dictionary];
//    }else {
//        for (NSString *userID in friendsDictionary){
//            BOOL isPlayer = [FriendsInApp containsObject:[[NSDecimalNumber alloc] initWithString:userID]];
//            Friend *f = [friendsDictionary objectForKey:userID];
//            if (f.isPlayer != isPlayer){//new player
//                [friendsDictionary removeObjectForKey:f.user_id];
//                f.isPlayer = isPlayer;
//                [friendsDictionary setObject:f forKey:f.user_id];
//            }
//        }
//    }
//    
//}
///**
// * Called when a request returns and its response has been parsed into
// * an object.
// *
// * The resulting object may be a dictionary, an array, a string, or a number,
// * depending on thee format of the API response.
// */
//
//- (void)request:(FBRequest *)request didLoad:(id)result {
//    
//    //if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
//    //    result = [result objectAtIndex:0];
//    //}
//    switch (currentAPICall) {
//        case kAPIGraphMe:{
//            //show profile result;
//            NSLog(@"Me result loaded ");
//            [delegate FbMeLoaded:[result objectForKey:@"id"]:[result objectForKey:@"name"]:[result objectForKey:@"gender"]];
//            break;       
//        }
//        case kAPIGraphMeLogIn:{
//            //show profile result;
//            NSLog(@"Me LogIn result loaded ");
//            [delegate FBSingletonDidLogin:[result objectForKey:@"id"]:[result objectForKey:@"name"]:[result objectForKey:@"gender"]];
//            break;
//        }
//        case kAPIGraphUserFriends:{
//            NSArray *resultData = [result objectForKey:@"data"];
//            if ([resultData count] >0){
//                savedAllFriends = [[NSArray alloc] initWithArray:resultData];
//                [self RequestFriendUsing];
//            }else{
//                savedAllFriends = nil;
//            }
//            
//            break;
//            /*
//            
//            NSArray *resultData = [result objectForKey:@"data"];
//            if ([resultData count] > 0) {
//                [self parseFriendList:resultData];
//                [delegate FBSIngletonUserFriendsDidLoaded:[friendsDictionary allValues]];
//                *
//                for (NSUInteger i=0; i<[resultData count] && i < 25; i++) {
//                    [friends addObject:[resultData objectAtIndex:i]];
//                }
//                // Show the friend information in a new view controller with FBSingleton Delegate
//                [delegate FBSIngletonUserFriendsDidLoaded:friends];
//                 *
//            } else {
//                [delegate FBSIngletonUserFriendsDidLoaded:nil];
//            }
//            break;
//            */
//        }
//        case kAPIGetAppUsersFriendsNotUsing:{
//            /*
//            //saveAPIResult is friendsUsingApp
//            if (savedAPIResult ==nil){
//                if ([result isKindOfClass:[NSArray class]]) {
//                    savedAPIResult = [[NSMutableArray alloc] initWithArray:result copyItems:YES];
//                } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
//                    savedAPIResult = [[NSMutableArray alloc] initWithObjects:[result stringValue], nil];
//                }
//            }
//            if (!friendsDictionary.count){
//                currentAPICall = kAPIRequestFriendDic_AtFriendNotUsing;
//                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                               @"id,name,gender",  @"fields",
//                                               nil];
//                [_facebook requestWithGraphPath:@"me/friends" andParams:params andDelegate:self];
//            }
//            else {
//                
//                
//                NSArray *resultData = [result objectForKey:@"data"];
//                if ([resultData count]){
//                    //NSMutableArray *friendsWithoutApp = [[NSMutableArray alloc] initWithCapacity:1];
//                    [self parseFriendList:resultData];
//                    
//                    NSMutableArray *friendsWithApp = [[NSMutableArray alloc] init];
//                    for (NSString *friendObject in savedAPIResult) {
//                        Friend *friend = [friendsDictionary objectForKey:friendObject];
//                        if (friend) {
//                            friend.isPlayer = YES;
//                            [friendsWithApp addObject:friend.user_id];
//                        }
//                    }
//                    NSMutableDictionary *friendsWithoutAppDictionary = [[NSMutableDictionary alloc] initWithDictionary:friendsDictionary ];
//                    [friendsWithoutAppDictionary removeObjectsForKeys:friendsWithApp];
//                    
//                    *
//                    for (NSDictionary *friendObject in resultData){
//                        BOOL foundFriend = NO;
//                        for (NSString *friendWithApp in savedAPIResult){
//                            if ([[friendObject objectForKey:@"id"] isEqualToString:friendWithApp]) {
//                                foundFriend = YES;
//                                break;
//                            }
//                        }
//                        if (!foundFriend) {
//                            [friendsWithoutApp addObject:friendObject];
//                        }
//                    }*
//                    if ([friendsWithoutAppDictionary count] > 0) {
//                        [delegate FBUserFriendsAppNotUsing:[friendsWithoutAppDictionary allValues]];
//                    }
//                    else {
//                        [delegate FBUserFriendsAppNotUsing:nil];
//                    }
//                }
//                else {
//                    [delegate FBUserFriendsAppNotUsing:nil];
//                }
//                savedAPIResult = nil;             }
//            break;
//    */
//        }
//        case kAPIGetAppUsersFriendsUsing:{
//                if ([result isKindOfClass:[NSArray class]]) {
//                    savedFriendsUsingApp = [[NSArray alloc] initWithArray:result copyItems:YES];
//                }else if ([result isKindOfClass:[NSDecimalNumber class]]) {
//                    savedFriendsUsingApp = [[NSArray alloc] initWithObjects:[result stringValue], nil];
//                }
//                //[self ParseFriendsDicUsingBlock];
//                [self parseFriendList:savedAllFriends :savedFriendsUsingApp];
//            
//                [delegate FBSIngletonFriendsDidLoaded:friendsDictionary];
//            break;
//        }
//        case kAPIGetAppUsersHitWhoList:{
//            if ([result isKindOfClass:[NSArray class]]) {
//                savedFriendsUsingApp = [[NSArray alloc] initWithArray:result copyItems:YES];
//            }else if ([result isKindOfClass:[NSDecimalNumber class]]) {
//                savedFriendsUsingApp = [[NSArray alloc] initWithObjects:[result stringValue], nil];
//            }
//            [self RequestHitWhoList];
//            break;
//        }
//        case kAPIGraphUserPermissionsDelete:{
//            // Nil out the session variables to prevent
//            // the app from thinking there is a valid session
//            _facebook.accessToken = nil;
//            _facebook.expirationDate = nil;
//            isLogIn = NO;
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FBAccessToken];
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FBExpirationDateKey];
//            [[NSUserDefaults standardUserDefaults] setInteger:NotLogIn forKey:LogInAs];
//            [delegate FBSingletonDidLogout];
//        }
//    }
//}
//
//
///**
// * Called when an error prevents the Facebook API request from completing
// * successfully.
// */
//- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
//    NSLog(@"FB error: %@", [error localizedDescription]);
//}
//
///**
// * Called when a UIServer Dialog successfully return.
// */
//- (void)dialogDidComplete:(FBDialog *)dialog {
//    NSLog(@"published successfully on FB");
//}
//
//#pragma mark - FBDialogDelegate Methods
//
///**
// * Called when a UIServer Dialog successfully return. Using this callback
// * instead of dialogDidComplete: to properly handle successful shares/sends
// * that return ID data back.
// */
//- (void)dialogCompleteWithUrl:(NSURL *)url {
//    if (![url query]) {
//        NSLog(@"User canceled dialog or there was an error");
//        return;
//    }
//    
//    NSDictionary *params = [self parseURLParams:[url query]];
//    switch (currentAPICall) {
//        case kDialogFeedUser:
//        case kDialogFeedFriend:
//            /*
//             {
//             // Successful posts return a post_id
//             if ([params valueForKey:@"post_id"]) {
//             [self showMessage:@"Published feed successfully."];
//             NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
//             }
//             break;
//             }*/
//        case kDialogRequestsSendToMany:
//        case kDialogRequestsSendToSelect:
//        case kDialogRequestsSendToTarget:
//        {
//            // Successful requests return the id of the request
//            // and ids of recipients.
//            NSMutableArray *recipientIDs = [[NSMutableArray alloc] init];
//            for (NSString *paramKey in params) {
//                if ([paramKey hasPrefix:@"to["]) {
//                    [recipientIDs addObject:[params objectForKey:paramKey]];
//                }
//            }
//            if ([params objectForKey:@"request"]){
//                NSLog(@"Request ID: %@", [params objectForKey:@"request"]);
//            }
//            if ([recipientIDs count] > 0) {
//                [delegate FBSingletonInviteYouCompleted:YES :recipientIDs];
//                NSLog(@"Recipient ID(s): %@", recipientIDs);
//            }
//            [delegate FBSingletonInviteYouCompleted:NO :recipientIDs];
//            
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (void)dialogDidNotComplete:(FBDialog *)dialog {
//    NSLog(@"Dialog dismissed.");
//}
//
//- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
//    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
//    //[self showMessage:@"Oops, something went haywire."];
//}
//
//
///**
// * Helper method to parse URL query parameters
// */
//- (NSDictionary *)parseURLParams:(NSString *)query {
//	NSArray *pairs = [query componentsSeparatedByString:@"&"];
//	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//	for (NSString *pair in pairs) {
//		NSArray *kv = [pair componentsSeparatedByString:@"="];
//        
//		[params setObject:[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//                   forKey:[[kv objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//	}
//    return params;
//}
//

//@end