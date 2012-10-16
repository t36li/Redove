//
//  LoadViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "FBSingletonDelegate.h"
#import "FBSingleton.h"
#import <RestKit/RestKit.h>
#import "UserInfo.h"
#import "User.h"
#import "GlobalMethods.h"

@interface LoadViewController : UIViewController <FBSingletonDelegate,RKRequestDelegate,RKObjectLoaderDelegate> {
    
    UserInfo *usr;
    FBSingleton *fbs;
    GlobalMethods *gmethods;
    
    IBOutlet UILabel *myLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *myLabel;


-(void) goToMenu;
@end
