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

@interface LoadViewController : UIViewController <FBSingletonNewDelegate,RKRequestDelegate,RKObjectLoaderDelegate> {
    
    UserInfo *usr;
    FBSingletonNew *fbs;
    GlobalMethods *gmethods;
    
    IBOutlet UILabel *myLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *myLabel;


-(void) goToMenu;
@end
