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
    IBOutlet UIButton *backButton;
    
    IBOutlet UIView *containerView;
}

@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIView *containerView;

-(IBAction) back:(id)sender;
@end
