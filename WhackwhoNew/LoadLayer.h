//
//  LoadLayer.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "cocos2d.h"
#import "ResourcesLoader.h"

@interface LoadLayer : CCLayer<ResourceLoaderDelegate>
{
	CCProgressTimer *_progress;
	CCLabelTTF *_loadingLabel;
    NSString *filename;
}

@property (nonatomic, retain) NSString *filename;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
