//
//  ModeSelectionViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
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
#import "Items.h"

#define MAX_HITTABLE 3
#define MAX_NO_HITTABLE 4

@interface HitWhoViewController : UIViewController<FBSingletonDelegate,UITableViewDelegate,UITableViewDataSource,RKObjectLoaderDelegate,PullToRefreshViewDelegate> {
   
    NSMutableArray *selectedHits;
    NSMutableArray *selectedHitsNames;
    NSMutableArray *arrayOfFinalImages;
    
    UIImage *defaultImage;
    int whichNumber;
    
    //!!!decommission noHits.... no longer lets user select who to NOT hit
    //NSMutableArray *noHits;
    //NSMutableArray *noHitsNames;

    IBOutlet UIImageView *hit1;
    IBOutlet UIImageView *hit2;
    IBOutlet UIImageView *hit3;
    IBOutlet UIImageView *hit4;
    
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *faceView;
    IBOutlet UIImageView *bodyView;
    IBOutlet UIImageView *helmetView;
    IBOutlet UIImageView *hammerView;
    IBOutlet UIImageView *shieldView;
    
    IBOutlet UIImageView *hitNumber;
    
    UITableView *table;
    NSArray *resultFriends;
    SpinnerView *spinner;
    IBOutlet UIView *loadingView;
    PullToRefreshView *tablepull;

}

@property (nonatomic) IBOutlet UIImageView *hit1;
@property (nonatomic) IBOutlet UIImageView *hit2;
@property (nonatomic) IBOutlet UIImageView *hit3;
@property (nonatomic) IBOutlet UIImageView *hit4;
@property (nonatomic) IBOutlet UIImageView *hitNumber;

@property (nonatomic) UIImage *defaultImage;


@property (nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) IBOutlet UIImageView *faceView;
@property (nonatomic) IBOutlet UIImageView *bodyView;
@property (nonatomic) IBOutlet UIImageView *helmetView;
@property (nonatomic) IBOutlet UIImageView *hammerView;
@property (nonatomic) IBOutlet UIImageView *shieldView;



@property (nonatomic) IBOutlet UITableView *table;
@property (nonatomic) SpinnerView *spinner;
@property (nonatomic) IBOutlet UIView *loadingView;
@property (nonatomic) NSArray *resultFriends;

//-(IBAction)handleRandomButton:(id)sender;
-(IBAction)nextTouched:(id)sender;
-(IBAction)Back_Touched:(id)sender;
-(IBAction)cancelTouched:(id)sender;
-(IBAction)battleTouched:(id)sender;

@end
