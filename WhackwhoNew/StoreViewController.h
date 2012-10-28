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
    float oldX; // here or better in .h interface
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainItemsScroll;

- (IBAction)Back_Touched:(id)sender;

@end
