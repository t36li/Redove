//
//  LoadLayer.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "LoadLayer.h"

@implementation LoadLayer

@synthesize filename;
@synthesize menuDelegate;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoadLayer *layer = [LoadLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id) sceneWithDelegate: (id<MainMenuDelegate>) delegate
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoadLayer *layer = [LoadLayer node];
	
    // set the layer delegate
    layer.menuDelegate = delegate;
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        //CCLOG(@"FUCK!");
		// init view
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		_progress = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"Default.png"]];
		_progress.type = kCCProgressTimerTypeRadial;
		_progress.position = ccp(winSize.width / 2, winSize.height / 2);
		[self addChild:_progress];
		
		_loadingLabel = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Marker Felt" fontSize:24];
		_loadingLabel.position = ccp(winSize.width / 2, winSize.height / 2 + [_progress contentSize].height / 2 + [_loadingLabel contentSize].height);
		[self addChild:_loadingLabel];
		
		// load resources
		ResourcesLoader *loader = [ResourcesLoader sharedLoader];
		NSArray *extensions = [NSArray arrayWithObjects:@"png", @"wav", nil];
		
		for (NSString *extension in extensions) {
			NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:extension inDirectory:nil];
			for (NSString *filename2 in paths) {
				filename = [[filename2 componentsSeparatedByString:@"/"] lastObject];
				[loader addResources:filename, nil];
			}
		}
		
		// load it async
		[loader loadResources:self];
        
       /* [CCSprite spriteWithFile:hills_l1];
        [CCSprite spriteWithFile:hills_l2];
        [CCSprite spriteWithFile:hills_l3];
        [CCSprite spriteWithFile:hills_l4];
        [CCSprite spriteWithFile:hills_l5];
        [CCSprite spriteWithFile:hills_l6];*/

	}
	return self;
}


- (void) didReachProgressMark:(CGFloat)progressPercentage
{
	[_progress setPercentage:progressPercentage * 100];
	
	if (progressPercentage == 1.0f) {
		[_loadingLabel setString:@"Loading complete"];
        [menuDelegate goToMenu];
        //[[CCDirector sharedDirector] replaceScene:[helloworldlayer scene]];
	}
}


@end
