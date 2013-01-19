//
//  ReviewViewController.h
//  WhackwhoNew
//
//  Created by Peter on 2012-10-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "UserInfo.h"

#define NOSE_EFFECT_BLOOD @"nose_effect_blood.png"
#define NOSE_EFFECT_SWELL @"nose_effect_swell.png"
#define EAR_EFFECT_BANDAGE @"ear_effect_bandage.png"
#define EAR_EFFECT_BRUISE @"ear_effect_bruise.png"
#define CHEEK_EFFECT_BANDAGE @"cheek_effect_bandage.png"
#define HEAD_EFFECT_SWELL @"head_effect_swell.png"
#define HEAD_EFFECT_BANDAGE @"head_effect_bandage.png"
#define MOUTH_EFFECT_TEETH @"mouth_effect_teeth.png"
#define MOUTH_EFECT_SWELL @"mouth_effect_swell.png"

@interface ReviewViewController : UIViewController {
    IBOutlet UIView *portraitView;
    
    IBOutlet UIButton *backBtn, *uploadBtn, *leftBtn, *rightBtn;
    
    IBOutlet UILabel *scorelbl, *goldlbl;
    
    IBOutlet UIImageView *avatarImageView;
    
    NSMutableArray *avatarArray;
    UIImage *defaultImage;
    NSInteger selectedIndex;
}

@property (nonatomic, strong) IBOutlet UIView *portraitView;
@property (nonatomic, strong) IBOutlet UIButton *backBtn, *uploadBtn, *leftBtn, *rightBtn;
@property (nonatomic, strong) IBOutlet UILabel *scorelbl, *goldlbl;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;

-(IBAction) hitBack:(id)sender;
-(IBAction) hitLeft:(id)sender;
-(IBAction) hitRight:(id)sender;

@end
