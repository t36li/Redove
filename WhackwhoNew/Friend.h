//
//  Friend.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-16.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Friend : NSObject<NSCopying> {
    NSString *user_id;
    NSString *name;
    NSString *gender;
    BOOL isPlayer;
}

@property (nonatomic, retain) NSString *user_id, *name, *gender;
@property (nonatomic, assign) BOOL isPlayer;

@end
