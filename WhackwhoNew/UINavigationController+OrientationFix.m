//
//  UINavigationController+OrientationFix.m
//  WhackwhoNew
//
//  Created by Peter on 2012-12-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "UINavigationController+OrientationFix.h"

@implementation UINavigationController (OrientationFix)

-(NSUInteger) supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

@end
