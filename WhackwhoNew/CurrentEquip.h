//
//  CurrentEquip.h
//  WhackwhoNew
//
//  Created by chun su on 2012-09-18.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <RestKit/RestKit.h>

@interface CurrentEquip : NSObject{
    NSString *helmet, *hammerArm, *shieldArm, *body;
}

@property (nonatomic, retain) NSString *helmet, *hammerArm, *shieldArm, *body;

-(CurrentEquip *) currentEquipInFileNames;
-(CurrentEquip *) currentEquipInIDs;
@end