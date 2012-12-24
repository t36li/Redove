//
//  AppDelegate.m
//  Test
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "AppDelegate.h"
#import "cocos2d.h"
#import <RestKit/RestKit.h>
#import "User.h"
#import "Friend.h"
#import "FBSingletonNew.h"

@implementation AppDelegate

@synthesize window = _window, usr;
@synthesize appUsageCheckEnabled = _appUsageCheckEnabled;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    usr = [UserInfo sharedInstance];
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:BaseURL];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    //objectManager.client.requestQueue.delegate = self;
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    [User objectMappingLoader];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    [director setAnimationInterval:1.0f/60.0f];
    [director enableRetinaDisplay:YES];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // We will remember the user's setting if they do not wish to
    // send any more invites.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.appUsageCheckEnabled = YES;
    if ([defaults objectForKey:@"AppUsageCheck"]) {
        self.appUsageCheckEnabled = [defaults boolForKey:@"AppUsageCheck"];
    }
    return YES;
}

//facebook connection
//pre 4.2 support

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [[[FBSingleton sharedInstance] facebook] handleOpenURL:url];
//}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[FBSingletonNew sharedInstance] setOpenedURL:url];
    return [FBSession.activeSession handleOpenURL:url];//[[[FBSingleton sharedInstance] facebook] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[[CCDirector sharedDirector] pause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[[CCDirector sharedDirector] resume];
    [FBSession.activeSession handleDidBecomeActive];
    
    if (FBSession.activeSession.isOpen) {
        // Check for any incoming notifications
        [[FBSingletonNew sharedInstance] checkIncomingNotification];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"Out of Memory!");
}

@end
