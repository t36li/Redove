//
//  GlobalMethods.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethods : NSObject{
}

@property (nonatomic) NSMutableData *responseData;


-(void) setViewBackground:(NSString *)BackgroundImage viewSender:(id)sender;
//+ (UIImage *)imageForObject:(NSString *)objectID;
//RestKit initial setup (URL, ObjectMapping, router)
-(void) RKInit;


@end

