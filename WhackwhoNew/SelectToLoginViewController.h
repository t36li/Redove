//
//  SelectToLoginViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-27.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSingletonDelegate.h"

@interface SelectToLoginViewController : UIViewController<FBSingletonDelegate>{
    UIButton *FBBut;
    UIButton *EMBut;
}
@property (nonatomic, retain) IBOutlet UIButton *FBBut;
@property (nonatomic, retain) IBOutlet UIButton *EMBut;

-(IBAction)FBTouched:(id)sender;
-(IBAction)EMTouched:(id)sender;

@end
