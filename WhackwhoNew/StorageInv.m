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
    self.helmetsArrayInFileName = [self addFileExtension:self.helmets];
    self.bodiesArrayInFileName = [self addFileExtension:self.bodies];
    self.hammerArmsArrayInFileName = [self addFileExtension:self.hammerArms];
    self.shieldArmsArrayInFileName = [self addFileExtension:self.shieldArms];
    
    return self;
}

-(StorageInv *)setStorageStringInIDs{
    self.headIds = [headIdsArrayInFileName componentsJoinedByString:@","];
    self.helmets = [self removeFileExtension:helmetsArrayInFileName];
    self.bodies = [self removeFileExtension:bodiesArrayInFileName];
    self.hammerArms = [self removeFileExtension:hammerArmsArrayInFileName];
    self.shieldArms = [self removeFileExtension:shieldArmsArrayInFileName];
    return self;
}

-(NSArray *) addFileExtension:(NSString *)target{
    NSMutableArray *returnT = [[NSMutableArray alloc] init];
    for (NSString *item in [target componentsSeparatedByString:@","]){
        NSString* i = [NSString stringWithFormat:@"%@.png",item];
        [returnT addObject:i];
    }
    return [[NSArray alloc] initWithArray:returnT];
}
 
-(NSString *) removeFileExtension:(NSArray *)target{
    NSMutableArray *returnT = [[NSMutableArray alloc] init];
    for (NSString *item in target){
        NSString* i = [item stringByReplacingOccurrencesOfString:@".png" withString:@""];
        [returnT addObject:i];
    }
    return [returnT componentsJoinedByString:@","];
}

@end
