//
//  RootViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSingletonDelegate.h"
#import "UserInfoDelegate.h"
#import "FBSingleton.h"
#import "FriendsViewController.h"
#import "SpinnerView.h"

@interface RootViewController : UIViewController<FBSingletonDelegate, UserInfoDelegate> {
    UIImageView *LoginAccountImageView; //Facebook Profile Image, Renren Profile Image or Gmail
    UIButton *play_but;
    UIButton *opt_but;
    FriendsViewController *friendVC;
}
@property (nonatomic, retain) IBOutlet UIImageView *LoginAccountImageView; 
@property (nonatomic, retain) IBOutlet UIButton *play_but;
@property (nonatomic, retain) IBOutlet UIButton *opt_but;

-(IBAction)play_touched:(id)sender;
-(IBAction)opt_touched:(id)sender;

@end
