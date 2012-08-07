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

@interface StatusBarController : UIViewController <CCDirectorDelegate, GameOverDelegate> {
    IBOutlet UIView *containerView;
    
    //define the outlets for gear
    NSArray *equipments;
    IBOutlet UIImageView *helmet;
    IBOutlet UIImageView *body;
    IBOutlet UIImageView *left_hand;
    IBOutlet UIImageView *right_hand;
    
    //define a dictionary containing all original positions of the above frames
    NSMutableDictionary *orig_equipment_positions;
    
    //define the stash
    //make an array that contains all the UIImageViews
    NSArray *stashItems;
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
    
    //define cocos layer as delegate
    //id<StatusCocosDelegate> cocosDelegate;

}

//define delegate
//@property (nonatomic, retain) id<StatusCocosDelegate> cocosDelegate;

//define the container view that stores the cocos2d view
@property (nonatomic) IBOutlet UIView *containerView;

//define current equipment
@property (nonatomic) NSArray *equipments;
@property (nonatomic) IBOutlet UIImageView *helmet; 
@property (nonatomic) IBOutlet UIImageView *body;
@property (nonatomic) IBOutlet UIImageView *left_hand;
@property (nonatomic) IBOutlet UIImageView *right_hand;

//define the stash items
@property (nonatomic) NSArray *stashItems;
@property (nonatomic) IBOutlet UIImageView *item1;
@property (nonatomic) IBOutlet UIImageView *item2;
@property (nonatomic) IBOutlet UIImageView *item3;
@property (nonatomic) IBOutlet UIImageView *item4;
@property (nonatomic) IBOutlet UIImageView *item5;
@property (nonatomic) IBOutlet UIImageView *item6;
@property (nonatomic) IBOutlet UIImageView *item7;
@property (nonatomic) IBOutlet UIImageView *item8;
@property (nonatomic) IBOutlet UIImageView *item9;
@property (nonatomic) IBOutlet UIImageView *item10;

- (IBAction)Back_Touched:(id)sender;
- (IBAction)Ok_Pressed:(id)sender;

@end
