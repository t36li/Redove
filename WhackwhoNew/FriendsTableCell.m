//
//  FriendsTableCell.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-06.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FriendsTableCell.h"

@implementation FriendsTableCell
@synthesize name = _nameLabel;
@synthesize gender;
@synthesize profileImageView = _profileImageView;
@synthesize containerView;
@synthesize spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //add some shit here to handle touches
}

@end
