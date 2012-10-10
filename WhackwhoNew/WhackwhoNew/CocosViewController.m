//
//  CocosViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CocosViewController.h"

@implementation CocosViewController
@synthesize delegate;

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
    
    if ([director isPaused]) {
        [director resume];
    }
    
    CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, 480, 320)
                                   pixelFormat:kEAGLColorFormatRGB565   //kEAGLColorFormatRGBA8
                                   depthFormat:0    //GL_DEPTH_COMPONENT24_OES
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    // HERE YOU CHECK TO SEE IF THERE IS A SCENE RUNNING IN THE DIRECTOR ALREADY
    if(![director runningScene]){
        [director setView:glView]; // SET THE DIRECTOR VIEW
        if( ! [director enableRetinaDisplay:YES] ) // ENABLE RETINA
            CCLOG(@"Retina Display Not supported");
        
        //[director runWithScene:[LoadLayer sceneWithDelegate:self]]; // RUN THE SCENE

        [director runWithScene:[HelloWorldLayer sceneWithDelegate:self]]; // RUN THE SCENE
        
    } else {
        // THERE IS A SCENE, START SINCE IT WAS STOPPED AND REPLACE TO RESTART
        [director startAnimation];
        [director.view setFrame:CGRectMake(0, 0, 480, 320)];
        //[director runWithScene:[LoadLayer sceneWithDelegate:self]]; // RUN THE SCENE

        [director runWithScene:[HelloWorldLayer sceneWithDelegate:self]];
    }
    
    [director willMoveToParentViewController:nil];
    [director.view removeFromSuperview];
    [director removeFromParentViewController];
    [director willMoveToParentViewController:self];
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    [self.view addSubview: director.view];
    [self.view sendSubviewToBack:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
}

-(void)proceedToReview {
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
    
    [director end];
    director.delegate = nil;
    [self performSelector:@selector(goToReview) withObject:nil afterDelay:1.5];
    /*
    [self performSegueWithIdentifier:@"GoToMenuSegue" sender:nil];
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
    
    [director popToRootScene];
     */
}

-(void) goToReview {
    [self performSegueWithIdentifier:@"CocosToReview" sender:nil];
}

- (void)returnToMenu {    
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
    
    [director end];
    director.delegate = nil;
    int total_stack = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(total_stack - 2)] animated:YES];
    //int totalStack = [self.navigationController.viewControllers count];
    
    /*if (totalStack == 8) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:5] animated:YES];
    } else {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    }*/
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
