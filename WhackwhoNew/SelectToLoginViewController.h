//
//  SelectToLoginViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-06-27.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSingletonNewDelegate.h"

@interface SelectToLoginViewController : UIViewController<FBSingletonNewDelegate>{
    UIButton *FBBut;
}
@property (nonatomic) IBOutlet UIButton *FBBut;

-(IBAction)FBTouched:(id)sender;

@end