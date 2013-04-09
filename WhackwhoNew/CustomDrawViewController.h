//
//  CustomDrawViewController.h
//  WhackwhoNew
//
//  Created by Peter on 2012-11-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDrawView.h"
#import <RestKit/RestKit.h>

#define LEFT_EYE 1
#define RIGHT_EYE 2
#define LIPS 3
#define NOSE 4
#define LEFT_EAR 5
#define RIGHT_EAR 6

//@class WEPopoverController;

@interface CustomDrawViewController : UIViewController <RKObjectLoaderDelegate> {
    IBOutlet CustomDrawView *containerView;
    IBOutlet UIButton *leftEyeButton, *rightEyeButton, *lipsButton, *noseButton, *leftEarButton, *rightEarButton;
    NSMutableSet *buttonSet;
    NSMutableArray *originalBtnPositions;
    IBOutlet UIButton *redoBtn, *okBtn, *cropBtn;
    
    //score storage
    NSDictionary *dic;
    
    //BOOL showOnce;
    //WEPopoverController *popoverController;
    UIView *popUp;

}

@property (nonatomic, strong) IBOutlet CustomDrawView *containerView;
@property (nonatomic, strong) IBOutlet UIButton *leftEyeButton, *rightEyeButton, *lipsButton, *noseButton, *leftEarButton, *rightEarButton, *redoBtn, *okBtn, *cropBtn;
@property (nonatomic, strong) NSMutableSet *buttonSet;
//@property (nonatomic, strong) WEPopoverController *popoverController;

-(IBAction)backTouched:(id)sender;
-(IBAction)crop:(id)sender;
-(IBAction)done:(id)sender;

//class methods
- (NSString *) dataFilepath;
- (NSString *) readPlist: (NSString *) whichLbl;

@end
