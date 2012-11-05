//
//  FriendsViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import "Friend.h"
#import "FBSingletonDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FBSingletonDelegate>{
    NSArray *resultData;
    NSString *resultAction;
    UITableView *friendsTable;
    SpinnerView *spinner;
    IBOutlet UIView *loadingView;
}
@property (nonatomic) NSArray *resultData;
@property (nonatomic) NSString *resultAction;
@property (nonatomic, weak) IBOutlet UITableViewCell *tableCell;
@property (nonatomic, weak) IBOutlet UITableView *friendTable;
@property (nonatomic) SpinnerView *spinner;
@property (nonatomic) IBOutlet UIView *loadingView;

- (IBAction)back_Touched:(id)sender;



@end
