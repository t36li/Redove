//
//  GameViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-10-23.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "GameViewController.h"
#import "Game.h"
#import "HelloWorldLayer.h"
#import "ReviewViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        Game *game = [Game sharedGame];
        if (game.gameView == nil)
            game.gameView = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CCGLView *glView = [CCGLView viewWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]
                                   pixelFormat:kEAGLColorFormatRGB565
                                   depthFormat:0
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    director.view = glView;
    
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    [director setAnimationInterval:1.0f/60.0f];
    [director enableRetinaDisplay:YES];
    [director setDisplayStats:YES];
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    [self.view addSubview:director.view];
    [director didMoveToParentViewController:self];
    
    if (![director runningScene]) {
        HelloWorldScene *newScene = [HelloWorldScene node];
        newScene.layer.gameOverDelegate = self;
        [director runWithScene:newScene];
    } else {
        //[director replaceScene:scene];
        //[scene.layer reset];
        //scene.layer.gameOverDelegate = self;
        HelloWorldScene *newScene = [HelloWorldScene node];
        newScene.layer.gameOverDelegate = self;
        [director replaceScene:newScene];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)proceedToReview {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ReviewViewController *rvController = [storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    [self.navigationController pushViewController:rvController animated:YES];
    CCDirector *director = [CCDirector sharedDirector];
    HelloWorldScene *newScene = [HelloWorldScene node];
    newScene.layer.gameOverDelegate = self;
    [director replaceScene:newScene];
}

- (void)returnToMenu {
    int total_stack = [self.navigationController.viewControllers count];
    //how to pop to status view?
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(total_stack - 4)] animated:YES];
    CCDirector *director = [CCDirector sharedDirector];
    HelloWorldScene *newScene = [HelloWorldScene node];
    newScene.layer.gameOverDelegate = self;
    [director replaceScene:newScene];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
}

@end
