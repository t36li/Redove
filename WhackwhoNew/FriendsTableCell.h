//
//  FriendsTableCell.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-06.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableCell : UITableViewCell{
    IBOutlet UILabel *name;
    IBOutlet UIImageView *profileImageView;
}
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, readonly) IBOutlet UIImageView *profileImageView;

@end
