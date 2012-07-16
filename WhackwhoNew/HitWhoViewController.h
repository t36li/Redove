//
//  ModeSelectionViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "cocos2d.h"
#import "ChooseWhoLayer.h"
#import "FBSingletonDelegate.h"
#import "FBSingleton.h"
#import "hitFriendCell.h"
#import "GlobalMethods.h"

@interface HitWhoViewController : UIViewController<FBSingletonDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *selectedHits;
    NSMutableArray *selectedHitsNames;
    NSMutableArray *noHits;
    NSMutableArray *noHitsNames;
    IBOutlet UIImageView *hit1;
    IBOutlet UIImageView *hit2;
    IBOutlet UIImageView *hit3;
    IBOutlet UIImageView *noHit1;
    IBOutlet UIImageView *noHit2;
    IBOutlet UIImageView *noHit3;
    IBOutlet UIImageView *noHit4;
    IBOutlet UIImageView *portrait;
    UITableView *table;
    NSMutableArray *resultFriends;

}

@property (nonatomic, retain) NSMutableArray *selectedHits;
@property (nonatomic, retain) IBOutlet UIImageView *hit1;
@property (nonatomic, retain) IBOutlet UIImageView *hit2;
@property (nonatomic, retain) IBOutlet UIImageView *hit3;
@property (nonatomic, retain) IBOutlet UIImageView *noHit1;
@property (nonatomic, retain) IBOutlet UIImageView *noHit2;
@property (nonatomic, retain) IBOutlet UIImageView *noHit3;
@property (nonatomic, retain) IBOutlet UIImageView *noHit4;
@property (nonatomic, retain) IBOutlet UIImageView *portrait;
@property (nonatomic, retain) IBOutlet UITableView *table;

-(IBAction) handleRandomButton:(id)sender;
-(IBAction) nextTouched:(id)sender;

@end
