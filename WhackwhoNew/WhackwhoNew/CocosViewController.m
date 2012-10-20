//
//  CocosViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CocosViewController.h"

@implementation CocosViewController

@synthesize goingBackToMenu;
@synthesize myglview;

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
    //goingBackToMenu = NO;
    
    CCDirector *director = [CCDirector sharedDirector];
    
    //if ([director isPaused]) {
      //  [director resume];
    //}
    
    //CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, 480, 320)
      //                             pixelFormat:kEAGLColorFormatRGB565   //kEAGLColorFormatRGBA8
        //                           depthFormat:0    //GL_DEPTH_COMPONENT24_OES
          //                  preserveBackbuffer:NO
            //                        sharegroup:nil
              //                   multiSampling:NO
                //               numberOfSamples:0];
    
    // HERE YOU CHECK TO SEE IF THERE IS A SCENE RUNNING IN THE DIRECTOR ALREADY
    if(![director runningScene]){
        if (!director.view) {
            [director setDisplayStats:NO];
            [director setView:myglview];
        }
         // SET THE DIRECTOR VIEW
        if( ! [director enableRetinaDisplay:YES] ) // ENABLE RETINA
            CCLOG(@"Retina Display Not supported");
                
        [director runWithScene:[HelloWorldLayer sceneWithDelegate:self]]; // RUN THE SCENE
        
    } else {
        if (!director.view) {
            [director setDisplayStats:NO];
            [director setView:myglview];
        }
        // THERE IS A SCENE, START SINCE IT WAS STOPPED AND REPLACE TO RESTART
        [director startAnimation];
        [director.view setFrame:CGRectMake(0, 0, 480, 320)];
        
        [director replaceScene:[HelloWorldLayer sceneWithDelegate:self]];
    }
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    [self.view addSubview: director.view];
    [self.view bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
}

-(void)proceedToReview {
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
    
    [director end];
    goingBackToMenu = YES;
    [self performSegueWithIdentifier:@"CocosToReview" sender:nil];
}

- (void)returnToMenu {    
    CCDirector *director = [CCDirector sharedDirector];
    
    [director willMoveToParentViewController:nil];
    [director.view removeFromSuperview];
    [director removeFromParentViewController];
    [director willMoveToParentViewController:self];
    [director end];
    
    int total_stack = [self.navigationController.viewControllers count];
    //how to pop to status view?
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(total_stack - 3)] animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
