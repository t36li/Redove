//
//  FriendsTableCell.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-06.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalMethods.h"
#import "SpinnerView.h"

@interface FriendsTableCell : UITableViewCell<UIAlertViewDelegate>{
    NSString *user_id;
    UILabel *name;
    UILabel *gender;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIView *containerView;
    SpinnerView *spinner;
}

@property (nonatomic) IBOutlet UILabel *name, *gender;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *profileImageView;
@property (nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) SpinnerView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *isPlayer;
@property (strong, nonatomic) IBOutlet UIButton *Invite_but;
@property (strong, nonatomic) NSString *user_id;

- (IBAction)inviteTouched:(id)sender;

@end
