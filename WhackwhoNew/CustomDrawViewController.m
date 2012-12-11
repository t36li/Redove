//
//  CustomDrawViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-11-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CustomDrawViewController.h"
#import "UserInfo.h"

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

-(void) touchedLocation:(UITapGestureRecognizer *)recognizer {
    UIImageView *markView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel.png"]];
    markView.frame = CGRectMake(0, 0, 40, 40);
    CGPoint location = [recognizer locationInView:self.view];
    markView.center = location;
    [self.view addSubview:markView];
    
    UserInfo *user = [UserInfo sharedInstance];
    if (CGPointEqualToPoint(user.leftEyePosition, CGPointZero)) {
        user.leftEyePosition = location;
    } else if (CGPointEqualToPoint(user.rightEyePosition, CGPointZero)) {
        user.rightEyePosition = location;
    } else if (CGPointEqualToPoint(user.mouthPosition, CGPointZero)) {
        user.mouthPosition = location;
    }
    
    [self.view removeGestureRecognizer:recognizer];
    [self setUserPoint];
}

-(void) setUserPoint {
    UserInfo *user = [UserInfo sharedInstance];
    if (CGPointEqualToPoint(user.leftEyePosition, CGPointZero)) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedLocation:)];
        [self.view addGestureRecognizer:gesture];
    } else if (CGPointEqualToPoint(user.rightEyePosition, CGPointZero)) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedLocation:)];
        [self.view addGestureRecognizer:gesture];
    } else if (CGPointEqualToPoint(user.mouthPosition, CGPointZero)) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedLocation:)];
        [self.view addGestureRecognizer:gesture];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)backTouched:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)resetPaths:(id)sender {
    [(CustomDrawView *)self.view resetPaths];
}

-(IBAction)done:(id)sender {
    [(CustomDrawView *)self.view commitPaths];
    UserInfo *user = [UserInfo sharedInstance];
    [user setLeftEyePosition:CGPointZero];
    [user setRightEyePosition:CGPointZero];
    [user setMouthPosition:CGPointZero];
    
    [self setUserPoint];
}
@end
