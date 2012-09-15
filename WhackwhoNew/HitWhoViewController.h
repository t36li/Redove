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
#import "SpinnerView.h"
#import "Friend.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RestKit/RestKit.h>
#import "PullToRefreshView.h"

#define MAX_HITTABLE 3
#define MAX_NO_HITTABLE 4

@interface HitWhoViewController : UIViewController<FBSingletonDelegate,UITableViewDelegate,UITableViewDataSource,RKObjectLoaderDelegate,PullToRefreshViewDelegate> {
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
    NSArray *resultFriends;
    SpinnerView *spinner;
    IBOutlet UIView *loadingView;
    PullToRefreshView *tablepull;

}

@property (nonatomic) NSMutableArray *selectedHits;
@property (nonatomic) IBOutlet UIImageView *hit1;
@property (nonatomic) IBOutlet UIImageView *hit2;
@property (nonatomic) IBOutlet UIImageView *hit3;
@property (nonatomic) IBOutlet UIImageView *noHit1;
@property (nonatomic) IBOutlet UIImageView *noHit2;
@property (nonatomic) IBOutlet UIImageView *noHit3;
@property (nonatomic) IBOutlet UIImageView *noHit4;
@property (nonatomic) IBOutlet UIImageView *portrait;
@property (nonatomic) IBOutlet UITableView *table;
@property (nonatomic) SpinnerView *spinner;
@property (nonatomic) IBOutlet UIView *loadingView;
@property (nonatomic) NSArray *resultFriends;

-(IBAction) handleRandomButton:(id)sender;
-(IBAction) nextTouched:(id)sender;
- (IBAction)Back_Touched:(id)sender;


@end
