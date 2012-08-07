//
//  GameViewController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeSelectionViewController : UIViewController {
    IBOutlet UIButton *leftButton;
    IBOutlet UIButton *rightButton;
    IBOutlet UIImageView *background;
    IBOutlet UIImageView *wholeView;
    NSMutableArray *bg_list;
    int index;
}

@property (nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic) IBOutlet UIImageView *background;
@property (nonatomic) NSMutableArray *bg_list;

- (IBAction)leftButton_touched:(id)sender;
- (IBAction)rightButton_touched:(id)sender;
- (IBAction)Back_Touched:(id)sender;

@end
