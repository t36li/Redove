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

@synthesize ccglView;

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
    
    director.view = ccglView;
    [director.view setFrame:CGRectMake(0, 0, 480, 320)];
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    [self.view addSubview:director.view];
    
    
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


@end
