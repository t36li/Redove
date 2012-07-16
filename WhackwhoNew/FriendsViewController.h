//
//  FriendsViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface FriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *resultData;
    NSString *resultAction;
    UITableView *friendsTable;
    SpinnerView *spinner;
    IBOutlet UIView *loadingView;
}
@property (nonatomic, retain) NSMutableArray *resultData;
@property (nonatomic, retain) NSString *resultAction;
@property (nonatomic, assign) IBOutlet UITableViewCell *tableCell;
@property (nonatomic, assign) IBOutlet UITableView *friendTable;
@property (nonatomic, retain) SpinnerView *spinner;
@property (nonatomic, retain) IBOutlet UIView *loadingView;

- (IBAction)back_Touched:(id)sender;



@end
