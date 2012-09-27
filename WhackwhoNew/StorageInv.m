//
//  StorageInv.m
//  WhackwhoNew
//
//  Created by chun su on 2012-09-19.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StorageInv.h"

@implementation StorageInv
@synthesize headIds, helmets,hammerArms,shieldArms,bodies;
@synthesize headIdsArrayInFileName,helmetsArrayInFileName,hammerArmsArrayInFileName,shieldArmsArrayInFileName,bodiesArrayInFileName;


-(StorageInv *)setStorageArrayInFileNames{
    self.headIdsArrayInFileName = [headIds componentsSeparatedByString:@","];
    self.helmetsArrayInFileName = [self addFileExtension:self.helmets :@"HE"];
    self.bodiesArrayInFileName = [self addFileExtension:self.bodies :@"BO"];
    self.hammerArmsArrayInFileName = [self addFileExtension:self.hammerArms :@"HA"];
    self.shieldArmsArrayInFileName = [self addFileExtension:self.shieldArms :@"SA"];
    
    return self;
}

-(StorageInv *)setStorageStringInIDs{
    self.headIds = [headIdsArrayInFileName componentsJoinedByString:@","];
    self.helmets = [self removeFileExtension:helmetsArrayInFileName :@"HE"];
    self.bodies = [self removeFileExtension:bodiesArrayInFileName :@"BO"];
    self.hammerArms = [self removeFileExtension:hammerArmsArrayInFileName :@"HA"];
    self.shieldArms = [self removeFileExtension:shieldArmsArrayInFileName :@"SA"];
    return self;
}

-(NSArray *) addFileExtension:(NSString *)target : (NSString *)type{
    NSMutableArray *returnT = [[NSMutableArray alloc] init];
    for (NSString *item in [target componentsSeparatedByString:@","]){
        NSString* i = [NSString stringWithFormat:@"%@%@.png",type,item];
        [returnT addObject:i];
    }
    return [[NSArray alloc] initWithArray:returnT];
}

-(NSString *) removeFileExtension:(NSArray *)target : (NSString *)type{
    NSMutableArray *returnT = [[NSMutableArray alloc] init];
    for (NSString *item in target){
        NSString* i = [[item stringByReplacingOccurrencesOfString:type withString:@""] stringByReplacingOccurrencesOfString:@".png" withString:@""];
        [returnT addObject:i];
    }
    return [returnT componentsJoinedByString:@","];
}

@end
