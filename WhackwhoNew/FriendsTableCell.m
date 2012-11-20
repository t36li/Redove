//
//  FriendsTableCell.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-06.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FriendsTableCell.h"
#import "FBSingleton.h"

@implementation FriendsTableCell
@synthesize name = _nameLabel;
@synthesize gender;
@synthesize profileImageView = _profileImageView;
@synthesize containerView;
@synthesize spinner;
@synthesize user_id;

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

- (IBAction)inviteTouched:(id)sender {
    //invite single friend into the game.
    self.Invite_but.titleLabel.text = @"Inviting...";   
    UIAlertView *confirmBox = [[UIAlertView alloc] initWithTitle:@"" message:[[NSString alloc] initWithFormat:@"tell %@ to join Whack Who!",self.name.text] delegate:self cancelButtonTitle:@"Post" otherButtonTitles:@"later", nil];
    confirmBox.tag = 1;
    [confirmBox show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 0){
                //[[FBSingleton sharedInstance] postToWallWithDialogNewHighscore:1000];
                //**[[FBSingleton sharedInstance] InviteYou:@"841183328"];///testing ; correct form: self.user_id
            }
            break;
            
        default:
            break;
    }
}
@end
