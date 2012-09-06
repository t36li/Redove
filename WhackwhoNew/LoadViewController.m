//
//  LoadViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "LoadViewController.h"
#import "LoadLayer.h"
#import "HelloWorldLayer.h"
#import "StatusViewLayer.h"

@implementation LoadViewController


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
    
    //mainMenu.hidden = YES;
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if([director isViewLoaded] == NO)
    {
        // Create the OpenGL view that Cocos2D will render to.
        CCGLView *glView = [CCGLView viewWithFrame:[self.view bounds]
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        
        //[glView setMultipleTouchEnabled:YES];
        // Assign the view to the director.
        [director setView:glView];
        
        // Initialize other director settings.
        [director setAnimationInterval:1.0f/60.0f];
        [director enableRetinaDisplay:YES];
        [director setDisplayStats:YES];
    }
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    [director willMoveToParentViewController:self];
    [self addChildViewController:director];
    [self.view addSubview:director.view];
    [self.view sendSubviewToBack:director.view];
    [director didMoveToParentViewController:self];
    
    [director runWithScene:[LoadLayer sceneWithDelegate:self]];
}
/*
- (void) viewDidDisappear:(BOOL)animated {
    //[[CCDirector sharedDirector].view setFrame:CGRectMake(0, 0, 190, 250)];
    //[[CCDirector sharedDirector] replaceScene:[StatusViewLayer scene]];
    //[[CCDirector sharedDirector] pause];
    //[[CCDirector sharedDirector] stopAnimation];
    //[[CCDirector sharedDirector] setDelegate:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[[CCDirector sharedDirector] pause];
    //[[CCDirector sharedDirector] stopAnimation];
    //[[CCDirector sharedDirector] setDelegate:nil];
}*/

-(void) goToMenu {
    [self performSegueWithIdentifier:@"GoToMenuSegue" sender:nil];
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
    
    [director popToRootScene];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
