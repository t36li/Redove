//
//  LoadViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "FBSingletonNewDelegate.h"
#import "FBSingletonNew.h"
#import <RestKit/RestKit.h>
#import "UserInfo.h"
#import "User.h"
#import "GlobalMethods.h"

@class Reachability;

@interface LoadViewController : UIViewController <FBSingletonNewDelegate,RKRequestDelegate,RKObjectLoaderDelegate> {
    
    UserInfo *usr;
    FBSingletonNew *fbs;
    GlobalMethods *gmethods;
    
    IBOutlet UILabel *myLabel;
    
    Reachability *internetReachable;
    Reachability *hostReachable;
}

@property (nonatomic, retain) IBOutlet UILabel *myLabel;
@property BOOL internetActive;
@property BOOL hostActive;

-(void) checkNetworkStatus:(NSNotification *)notice;
-(void) goToMenu;

@end
