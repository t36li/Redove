//
//  AvatarView.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-09.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarView : UIView {
    IBOutlet UIImageView *backgroundView, *headView, *photoView;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundView, *headView, *photoView;

@end
