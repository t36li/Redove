//
//  Items.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-09-18.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Items : NSObject {
    NSString *headID;
    NSString *helmet;
    NSString *body;
    NSString *hammerArm;
    NSString *shieldArm;

}

@property (nonatomic) NSString *headID;
@property (nonatomic) NSString *helmet;
@property (nonatomic) NSString *body;
@property (nonatomic) NSString *hammerArm;
@property (nonatomic) NSString *shieldArm;

@end
