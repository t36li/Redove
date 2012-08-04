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

@interface FriendsTableCell : UITableViewCell {
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


@end
