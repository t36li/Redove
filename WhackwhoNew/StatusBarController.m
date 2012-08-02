//
//  StatusBarController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusBarController.h"
#import "UserInfo.h"


@implementation StatusBarController
@synthesize containerView;

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view, typically from a nib.
    
    avatarView.frame = containerView.bounds;
    [containerView addSubview:avatarView];
    //[containerView setBackgroundColor:[UIColor clearColor]];
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

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    //UserInfo *usr = [UserInfo sharedInstance];
    /*
    if (usr.usrImg != nil) {
        photoView.image = usr.usrImg;
    }
     */
}

//- (IBAction)Back_Touched:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
@end
