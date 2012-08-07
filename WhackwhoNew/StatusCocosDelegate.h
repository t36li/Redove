//
//  StatusCocosDelegate.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-08-06.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatusCocosDelegate <NSObject>

-(void)updateCharacterWithImage: (UIImage *)img bodyPart: (int) pos;

@end
