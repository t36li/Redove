//
//  SelectToLoginViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-27.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectToLoginViewController : UIViewController{
    IBOutlet UIButton *LogonFB_But;
    IBOutlet UIButton *LogonRenren_But;
    IBOutlet UIButton *LogonEmail_But;
}
@property (nonatomic, retain) IBOutlet UIButton *LogonFB_But;
@property (nonatomic, retain) IBOutlet UIButton *LogonRenren_But;
@property (nonatomic, retain) IBOutlet UIButton *LogonEmail_But;

-(IBAction)FBClicked:(id)sender;

@end
