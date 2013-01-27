//
//  RootViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "SpinnerView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RestKit/RestKit.h>

@interface RootViewController : UIViewController<FBSingletonNewDelegate,UIAlertViewDelegate>{
    FBProfilePictureView *profileImageView; //Facebook Profile Image, Renren Profile Image or Gmail
    
    UIButton *play_but;
    UIButton *opt_but;
    IBOutlet UIImageView *baby;
    IBOutlet UIImageView *whack_label;
    IBOutlet UIImageView *poster;

    
@private
    UserInfo *usr;
    FBSingletonNew *fbs;
    
}
@property (retain, nonatomic) IBOutlet FBProfilePictureView *profileImageView;

@property (nonatomic) IBOutlet UIButton *play_but;
@property (nonatomic) IBOutlet UIButton *opt_but;
@property (nonatomic) IBOutlet IBOutlet UIImageView *baby;
@property (nonatomic) IBOutlet IBOutlet UIImageView *whack_label;
@property (nonatomic) IBOutlet IBOutlet UIImageView *poster;

-(IBAction)play_touched:(id)sender;
-(IBAction)opt_touched:(id)sender;
//-(IBAction)upload_clicked:(id)sender;

@end
