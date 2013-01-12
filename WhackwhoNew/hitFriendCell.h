//
//  hitFriendCell.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-14.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface hitFriendCell : UITableViewCell{
    IBOutlet UIView *containerView;
    UIImageView *profileImage;
    UILabel *name;
    //UILabel *gender;
    NSString *identity;
    SpinnerView *spinner;
}

@property (nonatomic) UIImageView *profileImage;
@property (nonatomic) UILabel *name;
//@property (nonatomic) UILabel *gender;
@property (nonatomic) NSString *identity;
@property (nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) SpinnerView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *popularity;


@end
