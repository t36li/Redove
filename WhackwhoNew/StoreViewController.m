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
@synthesize mainItemsScroll, purchasedItemsScroll;

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

- (void)viewWillAppear:(BOOL)animated {
    [self setupMainItemsScroll];
    
    NSString *path = [self dataFilepath];

    dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

}

- (void)setupMainItemsScroll
{
    mainItemsScroll.delegate = self;
    
    [self.mainItemsScroll setBackgroundColor:[UIColor clearColor]];
    [mainItemsScroll setCanCancelContentTouches:NO];
    
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
        if (nimages==8) {
            nimages=0;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect rect = imageView.frame;
        rect.size.height = 60;
        rect.size.width = 60;
        rect.origin.x = cx;
        rect.origin.y = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnItem:)];
        tap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tap];
        
        imageView.frame = rect;
        //imageView.transform = CGAffineTransformMakeRotation(30*3.14159/100);
        [imageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [imageView.layer setBorderWidth:2.5];
        [mainItemsScroll addSubview:imageView];
        cx += imageView.frame.size.width;//+5;
        tot++;
    }

    CGRect frame = mainItemsScroll.frame;
    frame.size = CGSizeMake(380,67);
    mainItemsScroll.frame = frame;
    mainItemsScroll.contentSize = CGSizeMake(cx, 67);
    mainItemsScroll.clipsToBounds = YES;
}

- (void) handleTapOnItem: (UITapGestureRecognizer *)gesture {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
    UIImageView *item = ((UIImageView *)(tap.view));
    
    NSLog(@"TOUCHED!");
    
    [item setBackgroundColor:[UIColor blackColor]];
}

- (NSString *) dataFilepath {
    //read the plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ItemsPList" ofType:@"plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"The file exists");
        return path;
    } else {
        NSLog(@"The file does not exist");
        return nil;
    }
}

- (void) writePlist {
    
    [dic setObject:[NSNumber numberWithInt:50] forKey:@"Money"];
    
    NSLog(@"New Cash: %i", [[dic objectForKey:@"Money"] intValue]);
    
}

- (void) readPlist {
    
    NSLog(@"Cash: %i", [[dic objectForKey:@"Money"] intValue]);
    
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

#pragma touch_methods

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Buy_Touched:(id)sender {
    
}

- (IBAction)Undo_Touched:(id)sender {
    
}

@end
