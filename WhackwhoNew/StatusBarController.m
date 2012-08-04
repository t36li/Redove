//
//  StatusBarController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusBarController.h"
#import "UserInfo.h"
#import "StatusViewLayer.h"
#import "TestLayer.h"

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
    //[self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view, this will only load once.
    
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

-(void)viewDidDisappear:(BOOL)animated {
    //[[CCDirector sharedDirector] popScene];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    CCDirector *director = [CCDirector sharedDirector];
    
    [director.view setFrame:CGRectMake(0, 0, 190, 250)];
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    [self.containerView addSubview:director.view];
    [self.containerView bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    if ([[CCDirector sharedDirector] runningScene]) {
        [[CCDirector sharedDirector] replaceScene:[StatusViewLayer scene]];
    } else {
        [[CCDirector sharedDirector] runWithScene:[StatusViewLayer scene]];
    }


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
