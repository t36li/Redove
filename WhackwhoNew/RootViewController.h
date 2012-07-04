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
    
}
@property (nonatomic, retain) IBOutlet UIImageView *LoginAccountImageView; 

@end
