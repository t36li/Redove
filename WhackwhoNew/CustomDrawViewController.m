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

@synthesize containerView;
@synthesize leftEarButton, leftEyeButton, lipsButton, noseButton, rightEarButton, rightEyeButton;
@synthesize buttonSet;

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
    
    [containerView setPrePreviousPoint:CGPointZero];
    [containerView setPreviousPoint:CGPointZero];
    [containerView setLineWidth:1.0f];
    [containerView setCurrentColor:[UIColor blackColor]];
    
    buttonSet = [[NSMutableSet alloc] init];
    [buttonSet addObject:leftEyeButton];
    [buttonSet addObject:rightEyeButton];
    [buttonSet addObject:noseButton];
    [buttonSet addObject:lipsButton];
    [buttonSet addObject:leftEarButton];
    [buttonSet addObject:rightEarButton];
    
    for (UIButton *btn in buttonSet) {
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanButton:)];
        [btn addGestureRecognizer:gestureRecognizer];
    }
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
    CGPoint location = [recognizer locationInView:containerView];
    markView.center = location;
    [containerView addSubview:markView];
    
    UserInfo *user = [UserInfo sharedInstance];
    if (CGPointEqualToPoint(user.leftEyePosition, CGPointZero)) {
        user.leftEyePosition = location;
    } else if (CGPointEqualToPoint(user.rightEyePosition, CGPointZero)) {
        user.rightEyePosition = location;
    } else if (CGPointEqualToPoint(user.mouthPosition, CGPointZero)) {
        user.mouthPosition = location;
    }
    
    [containerView removeGestureRecognizer:recognizer];
    [self setUserPoint];
}

-(void) setUserPoint {
    UserInfo *user = [UserInfo sharedInstance];
    if (CGPointEqualToPoint(user.leftEyePosition, CGPointZero)) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedLocation:)];
        [containerView addGestureRecognizer:gesture];
    } else if (CGPointEqualToPoint(user.rightEyePosition, CGPointZero)) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedLocation:)];
        [containerView addGestureRecognizer:gesture];
    } else if (CGPointEqualToPoint(user.mouthPosition, CGPointZero)) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedLocation:)];
        [containerView addGestureRecognizer:gesture];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)backTouched:(id)sender {
    [containerView resetPaths];
}

-(IBAction)crop:(id)sender {
    [containerView commitPaths];
}

-(IBAction)done:(id)sender {
    UserInfo *user = [UserInfo sharedInstance];
    [user setLeftEyePosition:CGPointZero];
    [user setRightEyePosition:CGPointZero];
    [user setMouthPosition:CGPointZero];
    
    [self setUserPoint];
}

-(void)didPanButton:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
@end
