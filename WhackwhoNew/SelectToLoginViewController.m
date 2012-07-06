//
//  SelectToLoginViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-27.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "SelectToLoginViewController.h"
#import "ImageConstants.h"
#import "FBSingleton.h"
#import "GlobalMethods.h"


@interface SelectToLoginViewController ()

@end

@implementation SelectToLoginViewController
@synthesize FBBut,RRBut,EMBut;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

*/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    [gmethods setViewBackground:SelectToLogIn_bg viewSender:self.view];
    
    [[FBSingleton sharedInstance] setDelegate:self];
    //setup FBBut Image;
    [FBBut setImage:[UIImage imageNamed:AccessFacebookIcon] forState:UIControlStateNormal];
    [FBBut setImage:[UIImage imageNamed:AccessFacebookIcon_HL] forState:UIControlStateHighlighted];
    //setup RRBut Image
    [RRBut setImage:[UIImage imageNamed:AccessRenrenIcon] forState:UIControlStateNormal];
    [RRBut setImage:[UIImage imageNamed:AccessRenrenIcon_HL] forState:UIControlStateHighlighted];
    
    //setup EMBut Image
    //[FBBut setImage:[UIImage imageNamed:AccessFacebookIcon forState:UIControlStateNormal]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

-(IBAction)FBTouched:(id)sender{
    [[FBSingleton sharedInstance] login];
}
-(IBAction)RRTouched:(id)sender{
    
}
-(IBAction)EMTouched:(id)sender{
    
}

-(void)FBSingletonDidLogin{
    //!!check if it is a registered user
    //code.....
    
    //for testing, push back to the main page
    
    [self.navigationController popViewControllerAnimated:YES];
    //[BUG!!!!!!!!!]
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
