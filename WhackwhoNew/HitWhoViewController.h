//
//  ModeSelectionViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface HitWhoViewController : UIViewController {
    NSMutableArray *selectedHits;
    IBOutlet UIImageView *hit1;
    IBOutlet UIImageView *hit2;
    IBOutlet UIImageView *hit3;
    IBOutlet UITableView *table;

}

@property (nonatomic, retain) NSMutableArray *selectedHits;
@property (nonatomic, retain) IBOutlet UIImageView *hit1;
@property (nonatomic, retain) IBOutlet UIImageView *hit2;
@property (nonatomic, retain) IBOutlet UIImageView *hit3;


@end
