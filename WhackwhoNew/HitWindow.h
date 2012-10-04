//
//  HitWindow.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-09-28.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface HitWindow : UIImageView {
    Friend *friend;
}
@property (nonatomic) Friend *friend;
@end
