//
//  ModeSelectionViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "hitFriendCell.h"
#import "GlobalMethods.h"
#import "SpinnerView.h"
#import "Friend.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RestKit/RestKit.h>
#import "PullToRefreshView.h"
#import "Items.h"
#import "HitWindow.h"
#import "FBSingletonNewDelegate.h"

@interface HitWhoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RKObjectLoaderDelegate,PullToRefreshViewDelegate,FBSingletonNewDelegate> {
   
    NSMutableArray *selectedHits;
    NSArray *hitWindows;
    
    //UIImage *defaultImage;

    IBOutlet HitWindow *hit1;
    IBOutlet HitWindow *hit2;
    IBOutlet HitWindow *hit3;
    IBOutlet HitWindow *hit4;
    
    IBOutlet UIView *containerView;
    
    IBOutlet UIImageView *faceView;
    IBOutlet UIImageView *bodyView;
    IBOutlet UIImageView *helmetView;
    IBOutlet UIImageView *hammerView;
    IBOutlet UIImageView *shieldView;
    
    IBOutlet UIImageView *hitNumber;
    IBOutlet UIImageView *leftHammer;
    IBOutlet UIImageView *rightHammer;
    
    UITableView *table;
    NSArray *resultFriends;
    NSMutableArray *resultStrangers;
    SpinnerView *spinner;
    IBOutlet UIView *loadingView;
    PullToRefreshView *tablepull;
    Friend *friendSelected;
    
    BOOL isHammerDown;
}

@property (nonatomic) IBOutlet HitWindow *hit1;
@property (nonatomic) IBOutlet HitWindow *hit2;
@property (nonatomic) IBOutlet HitWindow *hit3;
@property (nonatomic) IBOutlet HitWindow *hit4;
@property (nonatomic) IBOutlet UIImageView *hitNumber;
@property (nonatomic) IBOutlet UIImageView *leftHammer;
@property (nonatomic) IBOutlet UIImageView *rightHammer;

//@property (nonatomic) UIImage *defaultImage;

@property (nonatomic) IBOutlet UIView *containerView, *popupView, *characterReviewView;
@property (nonatomic) IBOutlet UIImageView *faceView;
@property (nonatomic) IBOutlet UIImageView *bodyView;
@property (nonatomic) IBOutlet UIImageView *helmetView;
@property (nonatomic) IBOutlet UIImageView *hammerView;
@property (nonatomic) IBOutlet UIImageView *shieldView;

@property (nonatomic) IBOutlet UITableView *table;
@property (nonatomic) SpinnerView *spinner;
@property (nonatomic) IBOutlet UIView *loadingView;
@property (nonatomic, strong) NSArray *resultFriends;
@property (nonatomic, strong) NSMutableArray *resultStrangers;
@property (nonatomic) NSArray *hitWindows;

@property (nonatomic) UIButton *uploadBtn, *dismissPopupBtn;

-(IBAction)Back_Touched:(id)sender;
-(IBAction)cancelTouched:(id)sender;
-(IBAction)battleTouched:(id)sender;
@end
