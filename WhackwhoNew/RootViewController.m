//
//  RootViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

-(void) viewDidLoad
{    
    //background
    /*
    UIImage *bg = [UIImage imageNamed:MainPage_bg];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.height, screenRect.size.width)];
    bgView.image = bg;
    bgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bgView];
     */
    NSLog(@"Main page background image imported.");
    
    //buttons
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



@end



