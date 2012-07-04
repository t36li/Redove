//
//  OptionsViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController{
    UIButton *back;
}
@property (nonatomic, retain) IBOutlet UIButton *back;

-(IBAction)back_clicked:(id)sender;
@end
