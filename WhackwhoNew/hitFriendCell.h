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
}
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *gender;

@end
