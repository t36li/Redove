//
//  StoreViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StoreViewController.h"
#import "cocos2d.h"
#import "StatusViewLayer.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

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
	// Do any additional setup after loading the view.
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

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
