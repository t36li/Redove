//
//  StatusBarController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GameOverDelegate.h"
#import "StatusCocosDelegate.h"
#import <RestKit/RestKit.h>

@interface StatusBarController : UIViewController<RKObjectLoaderDelegate, UIAlertViewDelegate> {// <CCDirectorDelegate, GameOverDelegate> {
    IBOutlet UIView *containerView;
    
    //define the outlets for gear
    NSArray *equipments;
    IBOutlet UIImageView *helmet;
    IBOutlet UIImageView *body;
    IBOutlet UIImageView *hammer_hand;
    IBOutlet UIImageView *shield_hand;
    
    //define a dictionary containing all original positions of the above frames
    NSMutableDictionary *orig_equipment_positions;
    
    //define the stash
    //make an array that contains all the UIImageViews
    NSArray *stashItems;
    NSMutableArray *invItems;
    IBOutlet UIImageView *item1;
    IBOutlet UIImageView *item2;
    IBOutlet UIImageView *item3;
    IBOutlet UIImageView *item4;
    IBOutlet UIImageView *item5;
    IBOutlet UIImageView *item6;
    IBOutlet UIImageView *item7;
    IBOutlet UIImageView *item8;
    IBOutlet UIImageView *item9;
    IBOutlet UIImageView *item10;
    
    //define a dictionary containing all original positions of the above frames
    NSMutableDictionary *orig_item_positions;
    
    //UIImageView startPoint
    CGPoint startPoint;
    BOOL touched_item;
    
    //define containerView subviews
    IBOutlet UIImageView *faceView;
    IBOutlet UIImageView *bodyView;
    IBOutlet UIImageView *helmetView;
    IBOutlet UIImageView *hammerView;
    IBOutlet UIImageView *shieldView;
    
    //define money label
    IBOutlet UILabel *money;
    int totalCash;
}

//define delegate
//@property (nonatomic, strong) id<StatusCocosDelegate> cocosDelegate;

//define the container view that stores the cocos2d view
@property (nonatomic, strong) IBOutlet UIView *containerView;

//define current equipment
@property (nonatomic, strong) NSArray *equipments;
@property (nonatomic, strong) IBOutlet UIImageView *helmet;
@property (nonatomic, strong) IBOutlet UIImageView *body;
@property (nonatomic, strong) IBOutlet UIImageView *hammer_hand;
@property (nonatomic, strong) IBOutlet UIImageView *shield_hand;

//define containerView subviews
@property (nonatomic) IBOutlet UIImageView *faceView;
@property (nonatomic) IBOutlet UIImageView *bodyView;
@property (nonatomic) IBOutlet UIImageView *helmetView;
@property (nonatomic) IBOutlet UIImageView *hammerView;
@property (nonatomic) IBOutlet UIImageView *shieldView;

//define the stash items
@property (nonatomic, strong) NSArray *stashItems;
@property (nonatomic, strong) NSMutableArray *invItems;
@property (nonatomic, strong) IBOutlet UIImageView *item1;
@property (nonatomic, strong) IBOutlet UIImageView *item2;
@property (nonatomic, strong) IBOutlet UIImageView *item3;
@property (nonatomic, strong) IBOutlet UIImageView *item4;
@property (nonatomic, strong) IBOutlet UIImageView *item5;
@property (nonatomic, strong) IBOutlet UIImageView *item6;
@property (nonatomic, strong) IBOutlet UIImageView *item7;
@property (nonatomic, strong) IBOutlet UIImageView *item8;
@property (nonatomic, strong) IBOutlet UIImageView *item9;
@property (nonatomic, strong) IBOutlet UIImageView *item10;

//define money
@property (nonatomic) IBOutlet UILabel *money;
@property (nonatomic) int totalCash;

- (IBAction)Back_Touched:(id)sender;
- (IBAction)Ok_Pressed:(id)sender;
- (IBAction)money_pressed:(id)sender;
- (void)updateDB;
- (IBAction)saveToDB_Touched:(id)sender;

@end
