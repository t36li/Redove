//
//  LoadLayer.m
//  WhackwhoNew
//
//  Created by Bob Li on 2012-07-31.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "LoadLayer.h"
#import "TestLayer.h"
#import "HelloWorldLayer.h"

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
		// init view
		CGSize winSize = CGSizeMake(480, 320);
		
		_progress = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"Default.png"]];
		_progress.type = kCCProgressTimerTypeRadial;
        _progress.anchorPoint = ccp(0.5,0.5);
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
            //filename = nil;
			for (NSString *filename2 in paths) {
				filename = [[filename2 componentsSeparatedByString:@"/"] lastObject];
				//[loader addResources:filename, nil];
                [loader addResourcesList:filename];
			}
		}
        /*
        [CCSprite spriteWithFile:hills_l1];
        [CCSprite spriteWithFile:hills_l2];
        [CCSprite spriteWithFile:hills_l3];
        [CCSprite spriteWithFile:hills_l4];
        [CCSprite spriteWithFile:hills_l5];
        [CCSprite spriteWithFile:hills_l6];
        [CCSprite spriteWithFile:hills_l7];
        [CCSprite spriteWithFile:hills_l8];
        [CCSprite spriteWithFile:hills_l9];
        [CCSprite spriteWithFile:@"pause.png"];
        [CCSprite spriteWithFile:@"heart.png"];
        [CCSprite spriteWithFile:@"scoreboard.png"];
        [CCSprite spriteWithFile:@"hit effect.png"];
        [CCSprite spriteWithFile:@"coin front.png"];
        [CCSprite spriteWithFile:@"peter body.png"];
        [CCSprite spriteWithFile:@"peter head c.png"];
        [CCSprite spriteWithFile:@"score paper.png"];
        [CCSprite spriteWithFile:@"play again key.png"];
        [CCSprite spriteWithFile:@"home key.png"];*/

		// load it async
		[loader loadResources:self];
        
        //alternative method
        /*
         @implementation LoadingScene
         
         @synthesize textures;
         
         - (id) init {
         if((self = [super init]) == nil) return nil;
         
         CCSprite *bg = [CCSprite spriteWithFile:@"Default.png"];
         bg.position = ccp(160, 240);
         [self addChild:bg z:0];
         
         CCSprite *loadingStatusBackground = [CCSprite spriteWithFile:@"loading_progress_background.png"];
         loadingStatusBackground.anchorPoint = ccp(0,0);
         loadingStatusBackground.position = ccp(22, 150);
         [self addChild:loadingStatusBackground z:1];
         
         CCSprite *loadingStatusForeground = [CCSprite spriteWithFile:@"loading_progress_foreground.png"];
         loadingStatusForeground.anchorPoint = loadingStatusBackground.anchorPoint;
         loadingStatusForeground.position = loadingStatusBackground.position;
         loadingStatusForeground.scaleX = 0;
         [self addChild:loadingStatusForeground z:2 tag:1];
         
         CCBitmapFontAtlas *loadingText = [CCBitmapFontAtlas bitmapFontAtlasWithString:@" " fntFile:@"visitor_12pt_green.fnt"];
         loadingText.anchorPoint = loadingStatusBackground.anchorPoint;
         loadingText.position = ccp(loadingStatusBackground.position.x, loadingStatusBackground.position.y - 15);
         [self addChild:loadingText z:2 tag:2];
         
         return self;
         }
         
         - (void) onEnter {
         [super onEnter];
         
         NSError *error;
         NSArray *bundleContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:&error];
         
         self.textures = [NSMutableArray arrayWithCapacity:[bundleContents count]];
         
         for(NSString *file in bundleContents) {
         if([[file pathExtension] compare:@"png"] == NSOrderedSame) {
         [textures addObject:[file lastPathComponent]];
         }
         }
         
         numberOfLoadedTextures = 0;
         [(CCBitmapFontAtlas*)[self getChildByTag:2] setString:[NSString stringWithFormat:@"Loading %@...", [textures objectAtIndex:numberOfLoadedTextures]]];
         [[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
         }
         
         - (void) imageDidLoad:(CCTexture2D*)tex {
         NSString *plistFile =
         [[(NSString*)[textures objectAtIndex:numberOfLoadedTextures] stringByDeletingPathExtension] stringByAppendingString:@".plist"];
         
         if([[NSFileManager defaultManager] fileExistsAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:plistFile]]) {
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFile];
         NSLog(@"loading %@", plistFile);
         }
         
         numberOfLoadedTextures++;
         CCSprite *loadingStatusForeground = (CCSprite*)[self getChildByTag:1];
         loadingStatusForeground.scaleX = (float)numberOfLoadedTextures / (float)[textures count];
         
         if(numberOfLoadedTextures == [textures count]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:kPreloadingDone object:nil];
         } else {
         [(CCBitmapFontAtlas*)[self getChildByTag:2] setString:[NSString stringWithFormat:@"Loading %@...", [textures objectAtIndex:numberOfLoadedTextures]]];
         [[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
         }
         }
         
         - (void) dealloc {
         [textures release];
         }
         
         @end*/
        
    }
	return self;
}

- (void) didReachProgressMark:(CGFloat)progressPercentage
{
    //[[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];

	[_progress setPercentage:progressPercentage * 100];
	
	if (progressPercentage == 1.0f) {
		[_loadingLabel setString:@"Loading complete"];
        [self performSelector:@selector(doStuff) withObject:nil afterDelay:1.5];
        //[[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
	}
}

- (void) doStuff {
    [menuDelegate goToMenu];
}


@end
