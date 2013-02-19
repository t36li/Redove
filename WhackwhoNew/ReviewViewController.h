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


@interface ReviewViewController : UIViewController {
    IBOutlet UIView *portraitView;
    
    IBOutlet UIButton *backBtn, *uploadBtn, *leftBtn, *rightBtn;
    
    IBOutlet UILabel *scorelbl, *goldlbl;
    
    IBOutlet UIImageView *avatarImageView;
    
    NSMutableArray *avatarArray;
    UIImage *defaultImage;
    NSInteger selectedIndex;
    
    UIImage *leftEye, *rightEye, *lip, *nose, *leftEar, *rightEar;
    NSArray *leftEyeEffects, *rightEyeEffects, *mouthEffects, *noseEffects, *leftEarEffects, *rightEarEffects;
    NSArray *leftCheekEffects, *rightCheekEffects, *headEffects;
    
    NSArray *effects;
    
    NSMutableDictionary *imagesOfEffects;
    
    bool once;
}

@property (nonatomic, strong) IBOutlet UIView *portraitView;
@property (nonatomic, strong) IBOutlet UIButton *backBtn, *uploadBtn, *leftBtn, *rightBtn;
@property (nonatomic, strong) IBOutlet UILabel *scorelbl, *goldlbl;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;

-(IBAction) hitBack:(id)sender;
-(IBAction) hitLeft:(id)sender;
-(IBAction) hitRight:(id)sender;
-(IBAction) shareToFacebook:(id)sender;

@end
