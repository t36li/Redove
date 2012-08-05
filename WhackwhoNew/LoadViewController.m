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
    
    //[director runWithScene:[ChooseWhoLayer scene]];
    [director runWithScene:[LoadLayer sceneWithDelegate:self]];
}

- (void) viewDidDisappear:(BOOL)animated {
    //[[CCDirector sharedDirector] pause];
}

-(void) goToMenu {
    
    [self performSegueWithIdentifier:@"GoToMenuSegue" sender:nil];
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
