//
//  hitFriendCell.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-14.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hitFriendCell : UITableViewCell{
    UIImageView *profileImage;
    UILabel *name;
    UILabel *gender;
    NSString *identity;
}
@property (nonatomic, retain) UIImageView *profileImage;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *gender;
@property (nonatomic, retain) NSString *identity;

@end
