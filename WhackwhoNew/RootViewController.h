//
//  RootViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSingletonDelegate.h"
#import "FBSingleton.h"
#import "FriendsViewController.h"
#import "SpinnerView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RestKit/RestKit.h>

@interface RootViewController : UIViewController<FBSingletonDelegate, UIAlertViewDelegate> {
    UIImageView *LoginAccountImageView; //Facebook Profile Image, Renren Profile Image or Gmail
    UIButton *play_but;
    UIButton *opt_but;
    FriendsViewController *friendVC;
}
@property (nonatomic) IBOutlet UIImageView *LoginAccountImageView; 
@property (nonatomic) IBOutlet UIButton *play_but;
@property (nonatomic) IBOutlet UIButton *opt_but;
@property (nonatomic) FriendsViewController *friendVC;

-(IBAction)play_touched:(id)sender;
-(IBAction)opt_touched:(id)sender;
-(IBAction)upload_clicked:(id)sender;

@end
