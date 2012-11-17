//
//  StoreViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StoreViewController.h"
#import "cocos2d.h"
#import "StatusViewLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface StoreViewController ()

@end

@implementation StoreViewController
@synthesize mainItemsScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupMainItemsScroll
{
    mainItemsScroll.delegate = self;
    
    [self.mainItemsScroll setBackgroundColor:[UIColor clearColor]];
    [mainItemsScroll setCanCancelContentTouches:NO];
    //[mainItemsScroll showsHorizontalScrollIndicator:NO];
    //mainItemsScroll.indicatorStyle = nil;
    //mainItemsScroll.frame =
    mainItemsScroll.clipsToBounds = NO;
    mainItemsScroll.scrollEnabled = YES;
    mainItemsScroll.pagingEnabled = YES;
    
    NSUInteger nimages = 0;
    NSInteger tot=0;
    CGFloat cx = 0;
    for (; ; nimages++) {
        NSString *imageName = [NSString stringWithFormat:@"HA00%d.png", (nimages + 1)];
        UIImage *image = [UIImage imageNamed:imageName];
        if (tot==15) {
            break;
        }
        if (4==nimages) {
            nimages=0;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect rect = imageView.frame;
        rect.size.height = 60;
        rect.size.width = 60;
        rect.origin.x = cx;
        rect.origin.y = 0;
        
        imageView.frame = rect;
        //imageView.transform = CGAffineTransformMakeRotation(30*3.14159/100);
        [imageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [imageView.layer setBorderWidth:2.5];
        [mainItemsScroll addSubview:imageView];
        cx += imageView.frame.size.width;//+5;
        tot++;
    }
    //self.pageControl.numberOfPages = nimages;
    //[mainItemsScroll setContentSize:CGSizeMake(cx, [mainItemsScroll bounds].size.height)];
    CGRect frame = mainItemsScroll.frame;
    frame.size = CGSizeMake(380,67);
    mainItemsScroll.frame = frame;
    mainItemsScroll.contentSize = CGSizeMake(cx, 67);
    mainItemsScroll.clipsToBounds = YES;
    
    //[mainItemsScroll setContentOffset:CGPointMake(mainItemsScroll.frame.size.width, mainItemsScroll.frame.size.height)];//[mainItemsScroll bounds].size.height)];
}

/*

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(oldX,aScrollView.contentOffset.y)];
    // or if you are sure you wanna it always on left:
    // [aScrollView setContentOffset: CGPointMake(0, aScrollView.contentOffset.y)];
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupMainItemsScroll];
}

- (void)viewDidUnload
{
    [self setMainItemsScroll:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
