//
//  StoreViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalMethods.h"

@interface StoreViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView *mainItemsScroll;
    UIScrollView *purchasedItemsScroll;
    
    NSMutableDictionary *dic;
    
    float oldX; // here or better in .h interface
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainItemsScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *purchasedItemsScroll;

- (NSString *) dataFilepath;
- (void) writePlist;
- (void) readPlist;

- (IBAction)Back_Touched:(id)sender;
- (IBAction)Buy_Touched:(id)sender;
- (IBAction)Undo_Touched:(id)sender;

@end
