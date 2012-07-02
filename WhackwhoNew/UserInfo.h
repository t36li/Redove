//
//  UserInfo.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-02.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo : NSObject {
    @public
    UIImage *croppedImage;
    UIImage *usrImg;
}

@property (nonatomic, retain) UIImage *usrImg, *croppedImage;

+(id)sharedInstance;

@end
