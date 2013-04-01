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
//#import "Items.h"
#import "HitWindow.h"
#import "FBSingletonNewDelegate.h"

@class WEPopoverController;

@interface HitWhoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RKObjectLoaderDelegate,PullToRefreshViewDelegate,FBSingletonNewDelegate> {
   
    NSMutableArray *selectedHits;
    NSMutableArray *selectedStrangers;
    NSArray *hitWindows;
    
    IBOutlet HitWindow *hit1;
    IBOutlet HitWindow *hit2;
    IBOutlet HitWindow *hit3;
    IBOutlet HitWindow *hit4;
    
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *faceView;
    IBOutlet UIImageView *bodyView;
    IBOutlet UIImageView *hitNumber;
    IBOutlet UIImageView *leftHammer;
    IBOutlet UIImageView *rightHammer;
    
    UITableView *table;
    NSMutableArray *resultFriends;
    NSMutableArray *resultStrangers;
    SpinnerView *spinner;
    IBOutlet UIView *loadingView;
    PullToRefreshView *tablepull;
    Friend *friendSelected;
    
    IBOutlet UILabel *namelabel;
    
    BOOL isHammerDown, isTableLoaded;
    
    WEPopoverController *popoverController;
    
    //score storage
    NSDictionary *dic;
}

@property (nonatomic) IBOutlet UILabel *namelabel;

@property (nonatomic) IBOutlet HitWindow *hit1;
@property (nonatomic) IBOutlet HitWindow *hit2;
@property (nonatomic) IBOutlet HitWindow *hit3;
@property (nonatomic) IBOutlet HitWindow *hit4;
@property (nonatomic) IBOutlet UIImageView *hitNumber;
@property (nonatomic) IBOutlet UIImageView *leftHammer;
@property (nonatomic) IBOutlet UIImageView *rightHammer;

@property (nonatomic) IBOutlet UIView *containerView, *popupView, *characterReviewView;
@property (nonatomic) IBOutlet UIImageView *faceView;
@property (nonatomic) IBOutlet UIImageView *bodyView;

@property (nonatomic) IBOutlet UITableView *table;
@property (nonatomic) SpinnerView *spinner;
@property (nonatomic) IBOutlet UIView *loadingView;
@property (nonatomic, strong) NSArray *resultFriends;
@property (nonatomic, strong) NSMutableArray *resultStrangers;
@property (nonatomic) NSArray *hitWindows;

@property (nonatomic) UIButton *uploadBtn, *dismissPopupBtn;

@property (nonatomic, strong) WEPopoverController *popoverController;

- (NSString *) dataFilepath;

-(IBAction)Back_Touched:(id)sender;
-(IBAction)cancelTouched:(id)sender;
-(IBAction)battleTouched:(id)sender;
@end
