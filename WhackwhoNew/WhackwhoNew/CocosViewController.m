//
//  CocosViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CocosViewController.h"
#import "StatusViewLayer.h"

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
}

- (void) viewWillAppear:(BOOL)animated {
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if (director.isPaused) {
        [director resume];
    }
    
    //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    //[director.view setFrame:[self.view bounds]];
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Add the director's OpenGL view as a subview so we can see it.
    [self.view addSubview:director.view];
    [self.view bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    // Run whatever scene we'd like to run here.
    [[CCDirector sharedDirector].view setFrame:CGRectMake(0, 0, 480, 320)];
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer sceneWithDelegate:self]];
}

- (void)returnToMenu {
    //UINavigationController *nav = self.navigationController;
    //if (![CCDirector sharedDirector].isPaused) {
       // [[CCDirector sharedDirector] pause];
    //}
    
    //[[CCDirector sharedDirector] popScene];    
    int totalStack = [self.navigationController.viewControllers count];
    
    if (totalStack == 8) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:5] animated:YES];
    } else {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    }
    
    //[[CCDirector sharedDirector].view setFrame:CGRectMake(0, 0, 190, 250)];
    //[[CCDirector sharedDirector] replaceScene:[StatusViewLayer scene]];
}

- (void) viewDidDisappear:(BOOL)animated {
    //[[CCDirector sharedDirector] popScene];
    //[[CCDirector sharedDirector] setDelegate:nil];
}

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
