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
    UISwitch *tutSwitch;
    //IBOutlet UISwitch *tutorial;
    
    UIView *popUp;
    NSMutableDictionary *dic;
    
@private
    UserInfo *usr;
    FBSingletonNew *fbs;
    
}

//@property (nonatomic) IBOutlet UISwitch *tutorial;
@property (nonatomic) IBOutlet UIButton *back;
@property (nonatomic) IBOutlet UIButton *logout_but;
@property (nonatomic) IBOutlet UIButton *login_but;
@property (nonatomic) IBOutlet UISwitch *tutSwitch;
- (IBAction)login_touch:(id)sender;

- (NSString *) dataFilepath;
- (void) writePlist: (BOOL) onOff;
- (int) readPlist;

-(IBAction)back_touched:(id)sender;
-(IBAction)logout_touched:(id)sender;
-(IBAction)about_touched:(id)sender;
-(IBAction)tutorial_touched:(id)sender;
@end
