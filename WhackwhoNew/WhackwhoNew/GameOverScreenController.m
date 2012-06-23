//
//  GameOverScreenController.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "GameOverScreenController.h"
#import "StatusBarController.h"

@interface GameOverScreenController ()

@end

@implementation GameOverScreenController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction) revertToStart:(id)sender {
    for (UIViewController *vController in self.navigationController.viewControllers) {
        if ([vController isKindOfClass:[StatusBarController class]])
            [self.navigationController popToViewController:vController animated:YES];
    }
}

@end
