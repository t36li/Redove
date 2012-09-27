//
//  StorageInv.h
//  WhackwhoNew
//
//  Created by chun su on 2012-09-19.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface StorageInv : NSObject

@property (nonatomic, retain) NSString *headIds, *helmets, *hammerArms, *shieldArms, *bodies;
@property (nonatomic, retain) NSArray *headIdsArrayInFileName, *helmetsArrayInFileName, *hammerArmsArrayInFileName, *shieldArmsArrayInFileName, *bodiesArrayInFileName;

-(StorageInv *)setStorageArrayInFileNames;
-(StorageInv *)setStorageStringInIDs;
@end
