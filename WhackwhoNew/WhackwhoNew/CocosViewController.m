//
//  CocosViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CocosViewController.h"
#import "GameViewController.h"

@implementation CocosViewController

@synthesize goingBackToMenu;

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
}

-(void)viewWillAppear:(BOOL)animated {
    if (goingBackToMenu) {
        goingBackToMenu = NO;
        return;
    }
    
    Game *game = [Game sharedGame];
    if (game.gameView == nil) {
        GameViewController *gvController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
        [self.navigationController pushViewController:gvController animated:NO];
    } else {        
        [self.navigationController pushViewController:game.gameView animated:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}


@end
