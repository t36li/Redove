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
#import "FBSingletonNew.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FBFriendPickerDelegate>{
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
@property (strong, nonatomic) IBOutlet UITextView *inviteMessage;
- (IBAction)FriendListClick:(id)sender;

- (IBAction)back_Touched:(id)sender;
- (IBAction)SendTouched:(id)sender;



@end
