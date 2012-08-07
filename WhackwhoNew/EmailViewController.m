//
//  EmailViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "EmailViewController.h"
#import "cocos2d.h"
#import "StatusViewLayer.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)confirm_pressed:(id)sender {
    [self performSegueWithIdentifier:@"EmailToStatusSegue" sender:sender];
    [[CCDirector sharedDirector].view setFrame:CGRectMake(0, 0, 190, 250)];
    [[CCDirector sharedDirector] replaceScene:[StatusViewLayer scene]];
}

@end
