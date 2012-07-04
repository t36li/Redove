//
//  RootViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "RootViewController.h"
#import "FBSingleton.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize LoginAccountImageView;

 

-(void) viewDidLoad
{
    NSLog(@"RootViewController viewDidLoad");
    [[FBSingleton sharedInstance] setDelegate:self];
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated{
    if ([[FBSingleton sharedInstance] isLogin]){
        [[FBSingleton sharedInstance] RequestMeProfileImage];
    }
    else {
        LoginAccountImageView.image = nil;
    }
}

-(void) FBProfilePictureLoaded:(UIImage *)img{
    LoginAccountImageView.image = img;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



@end
