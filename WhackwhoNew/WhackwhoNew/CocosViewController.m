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
    
    //mainMenu.hidden = YES;
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if([director isViewLoaded] == NO)
    {
        // Create the OpenGL view that Cocos2D will render to.
        CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, 480, 320)
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        
        [glView setMultipleTouchEnabled:YES];
        // Assign the view to the director.
        director.view = glView;
        
        // Initialize other director settings.
        [director setAnimationInterval:1.0f/60.0f];
        [director enableRetinaDisplay:YES];
        [director setDisplayStats:YES];
    }
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Add the director's OpenGL view as a subview so we can see it.
    [self.view addSubview:director.view];
    [self.view sendSubviewToBack:director.view];
    
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    // Run whatever scene we'd like to run here.
    //if(director.runningScene)
    //    [director replaceScene:[HelloWorldLayer scene]];
    //else
    //    [director runWithScene:[HelloWorldLayer scene]];
    [director runWithScene:[HelloWorldLayer sceneWithDelegate:self]];
    
}

-(void)returnToMenu {
    //UINavigationController *nav = self.navigationController;
    [self.navigationController popViewControllerAnimated:YES];
    //[[CCDirector sharedDirector] end];
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
