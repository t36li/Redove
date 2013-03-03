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
#import "Game.h"

@implementation AppDelegate

@synthesize window = _window, usr;
@synthesize appUsageCheckEnabled = _appUsageCheckEnabled;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Set up the audio session
	// See handy chart on pg. 55 of the Audio Session Programming Guide for what the categories mean
	// Not absolutely required in this example, but good to get into the habit of doing
	// See pg. 11 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
	
	// Create audio player with background music
	NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"background_music" ofType:@"mp3"];
	NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
	NSError *error;
	_backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
	[_backgroundMusicPlayer setDelegate:self];  // We need this so we can restart after interruptions
	[_backgroundMusicPlayer setNumberOfLoops:-1];	// Negative number means loop forever
    
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
    
    // We will remember the user's setting if they do not wish to send any more invites
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
    //[[FBSingletonNew sharedInstance] closeSession];
    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[CCDirector sharedDirector] pause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[[FBSingletonNew sharedInstance] openSession];
    [FBSession.activeSession handleDidBecomeActive];
    [[CCDirector sharedDirector] resume];
    /*
    if (FBSession.activeSession.isOpen) {
        // Check for any incoming notifications
        [[FBSingletonNew sharedInstance] checkIncomingNotification];
    }
     */
    [self tryPlayMusic];

}

- (void)tryPlayMusic {
	
	// Check to see if iPod music is already playing
	UInt32 propertySize = sizeof(_otherMusicIsPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &_otherMusicIsPlaying);
	
	// Play the music if no other music is playing and we aren't playing already
	if (_otherMusicIsPlaying != 1 && !_backgroundMusicPlaying) {
		[_backgroundMusicPlayer prepareToPlay];
		[_backgroundMusicPlayer play];
		_backgroundMusicPlaying = YES;
	}
}

- (void)switchToBGM {
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"Ingame_bgm" ofType:@"wav"];
	NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: backgroundMusicURL error: nil];
    [_backgroundMusicPlayer stop];
    _backgroundMusicInterrupted = YES;
	_backgroundMusicPlaying = NO;
    
    _backgroundMusicPlayer = newPlayer;
    [_backgroundMusicPlayer setDelegate:self];  // We need this so we can restart after interruptions
	[_backgroundMusicPlayer setNumberOfLoops:-1];
    [self tryPlayMusic];
}

- (void)switchToNormalBGM {
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"background_music" ofType:@"mp3"];
	NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: backgroundMusicURL error: nil];
    [_backgroundMusicPlayer stop];
    _backgroundMusicInterrupted = YES;
	_backgroundMusicPlaying = NO;
    
    _backgroundMusicPlayer = newPlayer;
    [_backgroundMusicPlayer setDelegate:self];  // We need this so we can restart after interruptions
	[_backgroundMusicPlayer setNumberOfLoops:-1];
    [self tryPlayMusic];
}

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
	_backgroundMusicInterrupted = YES;
	_backgroundMusicPlaying = NO;
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
	if (_backgroundMusicInterrupted) {
		[self tryPlayMusic];
		_backgroundMusicInterrupted = NO;
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[FBSession.activeSession close];
    [[FBSingletonNew sharedInstance] closeSession];

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [[CCDirector sharedDirector] purgeCachedData];
    
    NSLog(@"Out of Memory!");
}

@end
