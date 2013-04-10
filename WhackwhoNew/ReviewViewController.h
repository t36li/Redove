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
    
    IBOutlet UIImageView *star1, *star2, *star3;
    
    NSMutableArray *avatarArray;
    UIImage *defaultImage;
    NSInteger selectedIndex;
    NSString *sendToFBMsg;
    
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
@property (nonatomic, strong) NSString *sendToFBMsg;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *star1, *star2, *star3;

-(IBAction) hitBack:(id)sender;
-(IBAction) hitLeft:(id)sender;
-(IBAction) hitRight:(id)sender;
-(IBAction) shareToFacebook:(id)sender;

@end
