//
//  OptionsViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSingletonNew.h"
#import "FBSingletonNewDelegate.h"
#import "UserInfo.h"

@interface OptionsViewController : UIViewController<FBSingletonNewDelegate>{
    UIButton *back;
    UIButton *logout_but;
    //IBOutlet UISwitch *tutorial;
    
@private
    UserInfo *usr;
    FBSingletonNew *fbs;
    
}

//@property (nonatomic) IBOutlet UISwitch *tutorial;
@property (nonatomic) IBOutlet UIButton *back;
@property (nonatomic) IBOutlet UIButton *logout_but;

-(IBAction)tutSwitch_touched:(id)sender;
-(IBAction)back_touched:(id)sender;
-(IBAction)logout_touched:(id)sender;
@end
