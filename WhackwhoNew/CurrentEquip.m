//
//  CurrentEquip.m
//  WhackwhoNew
//
//  Created by chun su on 2012-09-18.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CurrentEquip.h"

@implementation CurrentEquip
@synthesize helmet,body,hammerArm,shieldArm;


-(CurrentEquip *) currentEquipInFileNames{
    CurrentEquip *ce = [CurrentEquip alloc];
    ce.helmet = [NSString stringWithFormat:@"%@.png",self.helmet];
    ce.body = [NSString stringWithFormat:@"%@.png",self.body];
    ce.hammerArm = [NSString stringWithFormat:@"%@.png",self.hammerArm];
    ce.shieldArm = [NSString stringWithFormat:@"%@.png",self.shieldArm];
    return ce;
}

-(CurrentEquip *) currentEquipInIDs{
    CurrentEquip *ceReturn = [CurrentEquip alloc];
    ceReturn.helmet =   [self.helmet  stringByReplacingOccurrencesOfString:@".png" withString:@""];
    ceReturn.body =   [self.body stringByReplacingOccurrencesOfString:@".png" withString:@""];
    ceReturn.hammerArm =   [self.hammerArm stringByReplacingOccurrencesOfString:@".png" withString:@""];
    ceReturn.shieldArm =   [self.shieldArm stringByReplacingOccurrencesOfString:@".png" withString:@""];
    return ceReturn;
}
@end
