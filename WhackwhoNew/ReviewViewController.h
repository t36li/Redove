//
//  ReviewViewController.h
//  WhackwhoNew
//
//  Created by Peter on 2012-10-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController {
    IBOutlet UIView *portraitView;
    
    IBOutlet UIButton *backBtn, *uploadBtn, *leftBtn, *rightBtn;
}

@property (nonatomic, strong) IBOutlet UIView *portraitView;
@property (nonatomic, strong) IBOutlet UIButton *backBtn, *uploadBtn, *leftBtn, *rightBtn;

-(IBAction) hitBack:(id)sender;

@end
