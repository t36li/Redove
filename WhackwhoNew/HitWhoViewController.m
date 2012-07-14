//
//  ModeSelectionViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HitWhoViewController.h"

@implementation HitWhoViewController

@synthesize selectedHits;
@synthesize hit1, hit2, hit3;

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

    selectedHits = [[NSMutableArray alloc] initWithObjects:hit1, hit2, hit3, nil];
    
    for (UIImageView *temp in selectedHits) {
        temp.userInteractionEnabled = YES;
    }

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

-(void) handleTapOnFriend: (NSString *) hit {
    //int indexOfLast = [selectedHits count] - 1;
    
    BOOL allImageViewOccupied = TRUE;
    for (UIImageView *temp in selectedHits) {
        if ([temp.image isEqual:nil]) {
            temp.image = [UIImage imageNamed:hit];
            allImageViewOccupied = FALSE;
        }
    }
    
    if (allImageViewOccupied) {
        //reached maximum pick... click Whack to continue or deselect someone
        //show an UIAlertView
        return;
    }

}

-(void) handleTapOnImage: (UITapGestureRecognizer *) tap {
    //first set the image of the imageview tapped to nil
    UIImageView *temp = (UIImageView *) tap;
    temp.image = nil;

}

//-(void) scrollview method... {
    // .... add the friend name to the list of strings
//}

@end
