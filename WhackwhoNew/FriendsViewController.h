//
//  FriendsViewController.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *resultData;
    NSMutableArray *selectedHits;
    NSMutableArray *selectedHitsNames;
    IBOutlet UIImageView *hit1;
    IBOutlet UIImageView *hit2;
    IBOutlet UIImageView *hit3;
    NSString *resultAction;
    UITableView *friendsTable;
}
@property (nonatomic, retain) NSMutableArray *resultData;
@property (nonatomic, retain) NSString *resultAction;
@property (nonatomic, assign) IBOutlet UITableViewCell *tableCell;
@property (nonatomic, assign) IBOutlet UITableView *friendTable;
@property (nonatomic, retain) NSMutableArray *selectedHits;
@property (nonatomic, retain) IBOutlet UIImageView *hit1;
@property (nonatomic, retain) IBOutlet UIImageView *hit2;
@property (nonatomic, retain) IBOutlet UIImageView *hit3;

- (IBAction)back_Touched:(id)sender;



@end
