//
//  LoadLayer.h
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "cocos2d.h"
#import "ResourcesLoader.h"
#import "TestLayer.h"
#import "HelloWorldLayer.h"
#import "MainMenuDelegate.h"
#import "StatusViewLayer.h"

@interface LoadLayer : CCLayer<ResourceLoaderDelegate>
{
	CCProgressTimer *_progress;
	CCLabelTTF *_loadingLabel;
    NSString *filename;
    id<MainMenuDelegate> menuDelegate;
}

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) id<MainMenuDelegate> menuDelegate;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
+(id) sceneWithDelegate: (id<MainMenuDelegate>) delegate;
@end
