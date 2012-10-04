//
//  Head.h
//  WhackwhoNew
//
//  Created by chun su on 2012-09-20.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

//for friend class ONLY

#import <Foundation/Foundation.h>

@interface Head : NSObject{
    UIImage *headImage;
    NSString *headId;
    
    NSString *leftEyePosition;
    NSString *rightEyePosition;
    NSString *mouthPosition;
    NSString *faceRect;
}

@property (nonatomic, strong) NSString *leftEyePosition, *rightEyePosition, *mouthPosition, *faceRect, *headId;
@property (nonatomic, strong) UIImage *headImage;

@end
