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
    CCGLView *glView = [CCGLView viewWithFrame:self.view.bounds
                                   pixelFormat:kEAGLColorFormatRGB565
                                   depthFormat:0
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    [glView setMultipleTouchEnabled:YES];
    director.view = glView;
    
    [[CCDirector sharedDirector] setDelegate:self];

    // Set the view controller as the director's delegate, so we can respond to certain events.
    [director setAnimationInterval:1.0f/60.0f];
    if (![director enableRetinaDisplay:YES])
        CCLOG(@"retina not supported");
    [director setDisplayStats:YES];
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    [self.view addSubview:director.view];
    [director didMoveToParentViewController:self];
    
    if (![director runningScene]) {
        HelloWorldScene *newScene = [HelloWorldScene node];
        [HelloWorldScene setGameOverDelegate:self];
        [director runWithScene:newScene];
    } else {
        HelloWorldScene *newScene = [HelloWorldScene node];
        [director replaceScene:newScene];
    }
}

-(void)viewWillAppear:(BOOL)animated {
//    CCScene *runningScene = [[CCDirector sharedDirector] runningScene];
//    if (runningScene != nil && [runningScene isKindOfClass:[HelloWorldScene class]]) {
//        HelloWorldScene *scene = (HelloWorldScene *)[[CCDirector sharedDirector] runningScene];
//        scene.gameOverDelegate = self;
//    }
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
//    CCDirector *director = [CCDirector sharedDirector];
//    HelloWorldScene *newScene = [HelloWorldScene node];
//    newScene.layer.gameOverDelegate = self;
//    [director replaceScene:newScene];
}

- (void)returnToMenu {
    int total_stack = [self.navigationController.viewControllers count];
    [[Game sharedGame] resetGameState];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(total_stack - 4)] animated:YES];
//    CCDirector *director = [CCDirector sharedDirector];
//    HelloWorldScene *newScene = [HelloWorldScene node];
//    newScene.layer.gameOverDelegate = self;
//    [director replaceScene:newScene];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}


@end
