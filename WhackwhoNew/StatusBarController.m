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
    self.navigationController.navigationBarHidden = YES;
    //photoView.image = [[UserInfo sharedInstance] exportImage];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    [director resume];
    
    [director.view setFrame:CGRectMake(0, 0, 190, 250)];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    [self.containerView addSubview:director.view];
    [self.containerView bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    if (director.runningScene) {
        [director replaceScene:[StatusViewLayer scene]];
    } else {
        [director runWithScene:[StatusViewLayer scene]];
    }
    
    //UserInfo *usr = [UserInfo sharedInstance];
    /*
     if (usr.usrImg != nil) {
     photoView.image = usr.usrImg;
     }
     */
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    //photoView.image = [[UserInfo sharedInstance] exportImage];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    [director resume];
    
    [director.view setFrame:CGRectMake(0, 0, 190, 250)];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    [self.containerView addSubview:director.view];
    [self.containerView bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    if (director.runningScene) {
        [director replaceScene:[StatusViewLayer scene]];
    } else {
        [director runWithScene:[StatusViewLayer scene]];
    }

}

- (void) viewDidDisappear:(BOOL)animated {
    [[CCDirector sharedDirector] pause];
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

//- (IBAction)Back_Touched:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
@end
