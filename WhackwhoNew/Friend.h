//
//  Friend.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-16.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Friend : NSObject {
    NSString *user_id;
    NSString *name;
    NSString *gender;
}

@property (nonatomic, retain) NSString *user_id, *name, *gender;

@end
