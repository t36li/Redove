//
//  CustomDrawViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-11-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CustomDrawViewController.h"

@interface CustomDrawViewController ()

@end

@implementation CustomDrawViewController

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
    
    [(CustomDrawView *)(self.view) setPrePreviousPoint:CGPointZero];
    [(CustomDrawView *)(self.view) setPreviousPoint:CGPointZero];
    [(CustomDrawView *)(self.view) setLineWidth:1.0f];
    [(CustomDrawView *)(self.view) setCurrentColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(IBAction)backTouched:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)resetPaths:(id)sender {
    [(CustomDrawView *)self.view resetPaths];
}

-(IBAction)done:(id)sender {
    [(CustomDrawView *)self.view commitPaths];
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
