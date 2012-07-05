//
//  RootViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-26.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSingletonDelegate.h"

@interface RootViewController : UIViewController<FBSingletonDelegate> {
    IBOutlet UIImageView *LoginAccountImageView; //Facebook Profile Image, Renren Profile Image or Gmail
    UIButton *play_but;
    int currentLogInType;
}
@property (nonatomic, retain) IBOutlet UIImageView *LoginAccountImageView; 
@property (nonatomic, retain) IBOutlet UIButton *play_but;

-(IBAction)play_touched:(id)sender;

@end
