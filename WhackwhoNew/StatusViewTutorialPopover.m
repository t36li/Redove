//
//  StatusBarTutorialPopover.m
//  WhackwhoNew
//
//  Created by Peter on 2013-01-14.
//  Copyright (c) 2013 Waterloo. All rights reserved.
//

#import "StatusViewTutorialPopover.h"


@implementation StatusViewTutorialPopover

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
    
    [self.view setBackgroundColor:[UIColor blackColor]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
