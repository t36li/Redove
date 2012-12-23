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
#import "FBSingletonNew.h"

@interface FriendsTableCell : UITableViewCell<UIAlertViewDelegate>{
    NSString *user_id;
    UILabel *name;
    UILabel *gender;
    SpinnerView *spinner;
}

@property (nonatomic) IBOutlet UILabel *name, *gender;
@property (nonatomic, strong) SpinnerView *spinner;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *isPlayer;
@property (strong, nonatomic) IBOutlet UIButton *Invite_but;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *FBprofileImageView;

- (IBAction)inviteTouched:(id)sender;

@end
