//
//  GameViewController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController {
    IBOutlet UIButton *leftButton;
    IBOutlet UIButton *rightButton;
    IBOutlet UIImageView *background;
    NSMutableArray *bg_list;
    int index;
}

@property (nonatomic, retain) IBOutlet UIButton *leftButton;
@property (nonatomic, retain) IBOutlet UIButton *rightButton;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) NSMutableArray *bg_list;

- (IBAction)leftButton_touched:(id)sender;
- (IBAction)rightButton_touched:(id)sender;

@end
