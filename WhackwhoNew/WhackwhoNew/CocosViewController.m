//
//  CocosViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CocosViewController.h"

@implementation CocosViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //do anything else that only needs to load once
    CCDirector *director = [CCDirector sharedDirector];
    
    [director resume];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Add the director's OpenGL view as a subview so we can see it.
    [self.view addSubview:director.view];
    [director.view setFrame:CGRectMake(0, 0, 480, 320)];
    [self.view bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    // Run whatever scene we'd like to run here.
    //[[CCDirector sharedDirector] resume];
    
    if(director.runningScene)
        [director replaceScene:[HelloWorldLayer sceneWithDelegate:self]];
    else
        [director runWithScene:[HelloWorldLayer sceneWithDelegate:self]];
}

- (void) viewWillAppear:(BOOL)animated {
    //do anything else that only needs to load once
    CCDirector *director = [CCDirector sharedDirector];
    
    [director resume];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Add the director's OpenGL view as a subview so we can see it.
    [self.view addSubview:director.view];
    [director.view setFrame:CGRectMake(0, 0, 480, 320)];
    [self.view bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    // Run whatever scene we'd like to run here.
    //[[CCDirector sharedDirector] resume];
    
    if(director.runningScene)
        [director replaceScene:[HelloWorldLayer sceneWithDelegate:self]];
    else
        [director runWithScene:[HelloWorldLayer sceneWithDelegate:self]];
}

- (void)returnToMenu {
    //UINavigationController *nav = self.navigationController;
    if (![CCDirector sharedDirector].isPaused) {
        [[CCDirector sharedDirector] pause];
    }
    [self performSegueWithIdentifier:@"CocosToSelectionSegue" sender:nil];
}

/*- (void) viewWillDisappear:(BOOL)animated {
    if (![CCDirector sharedDirector].isPaused) {
        [[CCDirector sharedDirector] pause];
    }
}*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[CCDirector sharedDirector] setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
