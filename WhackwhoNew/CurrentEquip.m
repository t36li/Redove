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
    ce.helmet = [NSString stringWithFormat:@"HE%@.png",self.helmet];
    ce.body = [NSString stringWithFormat:@"BO%@.png",self.body];
    ce.hammerArm = [NSString stringWithFormat:@"HA%@.png",self.hammerArm];
    ce.shieldArm = [NSString stringWithFormat:@"SA%@.png",self.shieldArm];
    return ce;
}

-(CurrentEquip *) currentEquipInIDs{
    CurrentEquip *ceReturn = [CurrentEquip alloc];
    ceReturn.helmet =   [[self.helmet stringByReplacingOccurrencesOfString:@"HE" withString:@""] stringByReplacingOccurrencesOfString:@".png" withString:@""];
    ceReturn.body =   [[self.body stringByReplacingOccurrencesOfString:@"BO" withString:@""] stringByReplacingOccurrencesOfString:@".png" withString:@""];
    ceReturn.hammerArm =   [[self.hammerArm stringByReplacingOccurrencesOfString:@"HA" withString:@""] stringByReplacingOccurrencesOfString:@".png" withString:@""];
    ceReturn.shieldArm =   [[self.shieldArm stringByReplacingOccurrencesOfString:@"SA" withString:@""] stringByReplacingOccurrencesOfString:@".png" withString:@""];
    return ceReturn;
}

@end
