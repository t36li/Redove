//
//  AppDelegate.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UserInfo *usr;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UserInfo *usr;

@end
