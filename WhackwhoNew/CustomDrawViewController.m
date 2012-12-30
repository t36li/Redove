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
    [user clearUserFacialFeaturePositions];
    
    for (UIButton *btn in buttonSet) {
        switch (btn.tag) {
            case LEFT_EYE:
                [user setLeftEyePosition:[btn convertPoint:btn.center toView:containerView]];
                break;
            case RIGHT_EYE:
                [user setRightEyePosition:[btn convertPoint:btn.center toView:containerView]];
                break;
            case LIPS:
                [user setMouthPosition:[btn convertPoint:btn.center toView:containerView]];
                break;
            case NOSE:
                [user setNosePosition:[btn convertPoint:btn.center toView:containerView]];
                break;
            case LEFT_EAR:
                [user setLeftEarPosition:[btn convertPoint:btn.center toView:containerView]];
                break;
            case RIGHT_EAR:
                [user setRightEarPosition:[btn convertPoint:btn.center toView:containerView]];
                break;
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)didPanButton:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void) viewDidUnload {
    for (UIButton *btn in buttonSet) {
        while ([btn.gestureRecognizers count] > 0) {
            [btn removeGestureRecognizer:[btn.gestureRecognizers objectAtIndex:0]];
        }
    }
    
    [buttonSet removeAllObjects];
    buttonSet = nil;
    
    [super viewDidUnload];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error.description);
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"request: '%@'",[request HTTPBodyString]);
    NSLog(@"request Params: %@", [request params]);
    NSLog(@"response code: %d",[response statusCode]);
    
    if ([request isPUT]) {
        if ([response isOK]){
            NSLog(@"image stored.");
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
