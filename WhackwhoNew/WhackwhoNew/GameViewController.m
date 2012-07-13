//
//  GameViewController.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

@synthesize leftButton, rightButton, background, bg_list;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    bg_list = [[NSMutableArray alloc] initWithObjects: @"hills_finalView.png", @"background 2.png", nil];
    index = 0;
    background.image = [UIImage imageNamed:[bg_list objectAtIndex:index]];
    
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

-(void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)leftButton_touched:(id)sender {
    index--;
    if (index < 0 ) {
        index = 0;
    }
    background.image = [UIImage imageNamed:[bg_list objectAtIndex:index]];
}

- (IBAction)rightButton_touched:(id)sender {
    index++;
    if (index >= 1 ) {
        index = 1;
    }
    background.image = [UIImage imageNamed:[bg_list objectAtIndex:index]];
}

@end
