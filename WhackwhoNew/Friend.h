//
//  Friend.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-16.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface Friend : NSObject<NSCopying> {
    NSString *user_id;//media(facebook) media_key
    NSString *whackwho_id;
    NSString *head_id;
    NSString *name;
    NSString *gender;
    BOOL isPlayer;
}

@property (nonatomic) NSString *user_id, *name, *gender, *whackwho_id, *head_id;
@property (nonatomic, assign) BOOL isPlayer;

+(void)objectMappingLoader;
@end

@interface FriendArray : NSObject{
    NSArray *_friends;
}
@property (nonatomic,retain) NSArray *friends;


+(void)objectMappingLoader;
@end