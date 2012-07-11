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

@synthesize Bobhead;

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view, typically from a nib.
    Bobhead.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"bob1.png"], [UIImage imageNamed:@"bob2.png"], [UIImage imageNamed:@"bob3.png"], nil];
    Bobhead.animationDuration = 0.5;
    Bobhead.animationRepeatCount = 0;
    
    [Bobhead setContentMode:UIViewContentModeScaleAspectFit];
    [Bobhead setBackgroundColor:[UIColor clearColor]];
    [Bobhead startAnimating];
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
    UserInfo *usr = [UserInfo sharedInstance];
    if (usr.usrImg != nil) {
        Bobhead.image = usr.croppedImage;
        [Bobhead stopAnimating];
    }
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
