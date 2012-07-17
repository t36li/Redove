//
//  GlobalMethods.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GlobalMethodsDelegate <NSObject>

@optional
-(void)profilePicLoaded:(UIImage *)img;

@end


@interface GlobalMethods : NSObject<NSURLConnectionDelegate>{
    NSMutableData *responseData;
    id<GlobalMethodsDelegate> delegate;
}

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) id<GlobalMethodsDelegate> delegate;


-(void) setViewBackground:(NSString *)BackgroundImage viewSender:(id)sender;
//+ (UIImage *)imageForObject:(NSString *)objectID;
-(void) RequestProfilePic:(NSString *)profileID;

@end

