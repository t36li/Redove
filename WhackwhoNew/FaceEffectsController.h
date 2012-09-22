//
//  FaceEffectsController.h
//  WhackwhoNew
//
//  Created by Peter on 2012-09-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarBaseController.h"

@interface FaceEffectsController : AvatarBaseController {
    IBOutlet UIView *containerView;
    
    IBOutlet UIImageView *nose;
    IBOutlet UIImageView *mouth;
    IBOutlet UIImageView *left_eye;
    IBOutlet UIImageView *right_eye;
    IBOutlet UIImageView *left_tear;
    IBOutlet UIImageView *right_tear;
    IBOutlet UIImageView *left_ear;
    IBOutlet UIImageView *right_ear;
    
    IBOutlet UIButton *backButton;
}


@property (nonatomic, retain) IBOutlet UIView *containerView;

@property (nonatomic, retain) IBOutlet UIImageView *nose;
@property (nonatomic, retain) IBOutlet UIImageView *mouth;
@property (nonatomic, retain) IBOutlet UIImageView *left_eye;
@property (nonatomic, retain) IBOutlet UIImageView *right_eye;
@property (nonatomic, retain) IBOutlet UIImageView *left_tear;
@property (nonatomic, retain) IBOutlet UIImageView *right_tear;
@property (nonatomic, retain) IBOutlet UIImageView *left_ear;
@property (nonatomic, retain) IBOutlet UIImageView *right_ear;
@property (nonatomic, retain) IBOutlet UIButton *backButton;

-(IBAction) back:(id)sender;
@end
