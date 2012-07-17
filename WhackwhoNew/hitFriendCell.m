//
//  hitFriendCell.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-14.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "hitFriendCell.h"

@implementation hitFriendCell

@synthesize gender, name, profileImage;
@synthesize identity, containerView, spinner;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        loadingImage = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addSpinner {
    if (!loadingImage) {
        spinner = [SpinnerView loadSpinnerIntoView:containerView];
        loadingImage = YES;
    }
}

-(void)removeSpinner {
    if (loadingImage) {
        [spinner removeSpinner];
        loadingImage = NO;
    }
}

@end
