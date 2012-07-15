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
@synthesize portrait;

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
    
   /* CCGLView *glview = [CCGLView viewWithFrame:CGRectMake(0, 0, 160,200)];
    [portrait addSubview:glview];
    
    CCDirector *director = [CCDirector sharedDirector];
    [director setView:glview];
    
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseWhoLayer *layer = [ChooseWhoLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer z:0];
    
    [director runWithScene:scene];*/
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

-(void) handleTapOnFriend: (NSString *) friend {
    //int indexOfLast = [selectedHits count] - 1;
    
    UIImage *tempImage = [UIImage imageNamed:friend];
    BOOL allImageViewOccupied = TRUE;
    for (UIImageView *temp in selectedHits) {
        if ([temp.image isEqual:nil]) {
            
            //set little circle image
            temp.image = tempImage;
            
            //set up big portraint image glview
            //chooseWholayer has to obtain image from Game.h
            // do something like [[game sharedgame] setHead: tempImage];
            
            //add swipe to cancel gesture (little cancel mark)
            UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnImage:)];
            [recognizer setNumberOfTouchesRequired:1];
            [temp addGestureRecognizer:recognizer];
            
            allImageViewOccupied = FALSE;
        }
    }
    
    if (allImageViewOccupied) {
        //reached maximum pick... click Whack to continue or deselect someone
        //show an UIAlertView
        return;
    }

}

-(void) handleSwipeOnImage: (UISwipeGestureRecognizer *) swipe {
    //first set the image of the imageview tapped to nil
    UIImageView *temp = (UIImageView *) swipe;
    temp.image = nil;

}

//-(void) scrollview method... {
    // .... add the friend name to the list of strings
//}

@end
