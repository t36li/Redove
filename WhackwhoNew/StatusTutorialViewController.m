//
//  StatusTutorialViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2013-01-03.
//  Copyright (c) 2013 Waterloo. All rights reserved.
//

#import "StatusTutorialViewController.h"

@interface StatusTutorialViewController ()

@end

@implementation StatusTutorialViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
