//
//  Friend.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-07-16.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CurrentEquip.h"
#import "Head.h"


@interface Friend : NSObject<NSCopying> {
    NSString *mediatype_id;
    NSString *user_id;//media(facebook) media_key
    NSString *whackwho_id;
    NSString *name;
    NSString *gender;
    NSString *head_id;
    NSInteger popularity;
    Head *head;
    CurrentEquip *currentEquip;
    BOOL isPlayer;
}

@property (nonatomic, strong) NSString *mediaType_id, *user_id, *name, *gender, *whackwho_id, *head_id;
@property (nonatomic, strong) CurrentEquip *currentEquip;
@property (nonatomic, strong) Head *head;
@property (nonatomic, assign) BOOL isPlayer;
@property (nonatomic, assign) NSInteger popularity;

@end

@interface FriendArray : NSObject{
    NSArray *friends;
    NSArray *strangers;
}
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *strangers;

-(void)copyToUserInfo;
-(void)getFromUserInfo;
@end