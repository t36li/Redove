//
//  HelloWorldLayer.m
//  MoleIt
//
//  Created by Bob Li on 12-06-23.
//  Copyright Waterloo 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import <Foundation/Foundation.h>
#import "CocosViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "Items.h"
#import "AppDelegate.h"

#define hillLevel 0
#define seaLevel 1
#define spaceLevel 2
#define fireTag 808
#define burntTag 909

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize locations, baselayer, splashFrames, bodyFrames;
@synthesize x_min, x_max, y_min, y_max; //the min/max for the splash sprite, not head

// on "init" you need to initialize your instance
-(id) init {
	if( (self=[super init]) ) {
        
	}
	return self;
}


void endHammerSound (SystemSoundID  mySSID, void *myself)
{    
    NSString *fireSoundPath = [[NSBundle mainBundle] pathForResource:@"Fire_sound" ofType:@"caf"];
	NSURL *fireSoundURL = [NSURL fileURLWithPath:fireSoundPath];
    SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)fireSoundURL, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void) onEnter {
    [super onEnter];
    
    NSString *rightHammerPath = [[NSBundle mainBundle] pathForResource:@"hit_sound_final" ofType:@"caf"];
	NSURL *rightHammerURL = [NSURL fileURLWithPath:rightHammerPath];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)rightHammerURL, &_rightHammerSound);
    AudioServicesAddSystemSoundCompletion(_rightHammerSound, NULL, NULL, endHammerSound, NULL);

    NSString *wrongHammerPath = [[NSBundle mainBundle] pathForResource:@"miss_sound_final" ofType:@"caf"];
	NSURL *wrongHammerURL = [NSURL fileURLWithPath:wrongHammerPath];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)wrongHammerURL, &_wrongHammerSound);
    
    self.isTouchEnabled = YES;
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //init variables
    speed = DEFAULT_HEAD_POP_SPEED;
    //has_bomb = FALSE;
    
    if ([[CCDirector sharedDirector] isPaused]) {
        [[CCDirector sharedDirector] resume];
    }
    
    //coins = [[NSMutableArray alloc] init];
    //bomb = [[NSMutableArray alloc] init];
    heads = [[NSMutableArray alloc] init];
    sve = [[NSMutableArray alloc] init];
    sve_displayed = 0;
    
    //determine which background to load
    //if unlocked new level, then randomize
    int temp = [[Game sharedGame] bgs_to_random];
    level = arc4random() % (temp+1); //generates 0,1,2,.,temp
    int hms = [[Game sharedGame] hammers_to_random];
    int rand_hms = (arc4random() % (hms+1)) + 1;
    //if (rand_hms == 0) {
      //  hammer_name = @"hit_hammer.png";
    //} else {
    hammer_name = [NSString stringWithFormat:@"Hammer%i.png", rand_hms];
    //}
    hammer_name = @"Hammer2.png";
    
    glClearColor(255, 255, 255, 255);
    splashFrames = [NSMutableArray array];
    bodyFrames = [[NSMutableArray alloc] initWithCapacity:5];
    objectsCantCollide = [NSMutableArray array];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bodyAnimations.plist"];

    for (int i = 1; i <= 5; i ++) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (int j = 1; j <= 3; j++) {
            [tempArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"body%i_%i.png", i, j]]];
        }
        [bodyFrames addObject:tempArray];
    }
    
    switch (level) {
        case hillLevel:
        {
            [self performSelector:@selector(setLevelOne)];
            break;
        }
        case seaLevel:
        {
            [self performSelector:@selector(setLevelTwo)];
            break;
        }
        case spaceLevel:
        {
            [self performSelector:@selector(setLevelThree)];
            break;
        }
    }
    
    //initialize shake handler
    //self.isAccelerometerEnabled = YES;
    //[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
    //shake_once = false;
    
    int i = 0; //for key purpose
    for (UIImage *person in [[Game sharedGame] arrayOfAllPopups]) {
        Character *head = [Character spriteWithCGImage:[person CGImage] key:[NSString stringWithFormat:@"person%i", i]];
        
        if (i < [[Game sharedGame] selectHeadCount]) {
            head.isSelectedHit = TRUE;
        } else {
            head.isSelectedHit = FALSE;
        }
        
        head.anchorPoint = ccp(0.5, 0.5);
        head.visible = FALSE;
        head.position = CGPointZero;
        [self addChild:head z:10];
        [heads addObject:head];
        i++;
        
        CCSprite *tempBody = [CCSprite spriteWithSpriteFrameName:@"body1_1.png"];
        tempBody.anchorPoint = ccp(0.5,1);
        tempBody.scale = 0.6;
        [head addChild:tempBody z:-10];
        
        int randomBody = arc4random() % 5;
        switch (randomBody) {
            case 0:
                tempBody.position = ccp(24, 15);
                break;
            case 1:
                tempBody.position = ccp(24, 20);
                break;
            case 2:
                tempBody.position = ccp(24, 8);
                break;
            case 3:
                tempBody.position = ccp(24, 10);
                break;
            case 4:
                tempBody.position = ccp(24, 10);
                break;
        }
        CCAnimation *bodyAnim = [CCAnimation animationWithSpriteFrames:[bodyFrames objectAtIndex:randomBody] delay:0.2f];
        CCRepeat *bodyAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:bodyAnim] times:-1];
        CCCallFuncN *endSplashAction = [CCCallFuncN actionWithTarget:self selector:@selector(endSplashAction:)];
        [tempBody runAction:[CCSequence actions:bodyAction, endSplashAction, nil]];
    }
    
    [self schedule:@selector(tryPopheads) interval:DEFAULT_HEAD_POP_SPEED];
     
}

-(void)finalCleanup {
    for (Character *head in heads) {
        [[CCTextureCache sharedTextureCache] removeTexture:[head texture]];
    }
    
    heads=nil;
    sve = nil;
    
    locations = nil;
    baselayer = nil;
    splashFrames = nil;
    objectsCantCollide = nil;
    
    [self removeAllChildrenWithCleanup:YES];
    [self unscheduleAllSelectors];
}

-(void) setLevelOne {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"level1_sprites.plist"];
    baselayer = [CCSpriteBatchNode batchNodeWithFile:@"level1_sprites.pvr.ccz"];
    [self addChild:baselayer];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"level1.png"];
    sprite.anchorPoint = ccp(0.5,0.5);
    sprite.position = ccp(winSize.width/2, winSize.height/2);
    [baselayer addChild:sprite];
    
    for (int i = 1; i <= 10; i ++) {
        [splashFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"mudsplash%i.png", i]]];
    }
    
    self.x_min = 30;
    self.x_max = 450;
    self.y_min = 14;
    self.y_max = 200;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Level1" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    locations = [dictionary objectForKey:@"points"];
    
    NSArray *temparray = [NSArray arrayWithObjects:@"hill_rainbow1.png", @"hill_rainbow2.png", @"hill_rainbow3.png", @"hill_cloud1.png", @"hill_cloud2.png", @"hill_flower1.png", @"hill_flower2.png", @"hill_flower3.png", @"hill_flower4.png", @"hill_scoreboard.png", @"grass1.png", @"grass2.png", nil];
    NSNumber *x, *y;

    for (int i = 0; i < [temparray count]; i++) {
        NSString *imageName = [temparray objectAtIndex:i];
        CCSprite *tempSprite = [CCSprite spriteWithSpriteFrameName:imageName];
        NSString *dicKey = [[imageName componentsSeparatedByString:@"."] objectAtIndex:0];
        NSDictionary *dict = [locations objectForKey:dicKey];
        x = [dict objectForKey:@"x"];
        y = [dict objectForKey:@"y"];
        [tempSprite setPosition:CGPointMake(x.integerValue, y.integerValue)];
        [tempSprite convertToWorldSpace:tempSprite.position];
        [baselayer addChild:tempSprite];
        if (i < 3) {
            tempSprite.visible = FALSE;
            [sve addObject:tempSprite];
        } else if (i >= 5) {
            [objectsCantCollide addObject:tempSprite];
        }
    }
    
    //UIImage *person = [[[Game sharedGame]arrayOfAllPopups] objectAtIndex:0];
    //spriteForHead = [CCSprite spriteWithCGImage:[person CGImage] key:@"person1"];
    //spriteForHead.anchorPoint = ccp(0.5,0.5);
    //spriteForHead.position = ccp(winSize.width/2, winSize.height/2);
    //[self addChild:spriteForHead z:10];
}

-(void) setLevelTwo {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"level2_sprites.plist"];
    baselayer = [CCSpriteBatchNode batchNodeWithFile:@"level2_sprites.pvr.ccz"];
    [self addChild:baselayer];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"level2.png"];
    sprite.anchorPoint = ccp(0.5,0.5);
    sprite.position = ccp(winSize.width/2, winSize.height/2);
    [baselayer addChild:sprite];
    
    for (int i = 1; i <= 11; i ++) {
        [splashFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"watersplash%d.png", i]]];
    }
    
    self.x_min = 30;
    self.x_max = 450;
    self.y_min = 47;
    self.y_max = 226;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Level2" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    locations = [dictionary objectForKey:@"points"];
    
    NSArray *temparray = [NSArray arrayWithObjects:@"beach.png", @"coral1_1.png", @"coral2_1.png", @"crab1.png", @"rock1.png", @"rock2.png", @"sea_scoreboard.png", @"purplestar1.png",  @"sea_shell.png", @"seaconch.png", @"seaweed1.png", @"starsgrouped.png", @"sea_fish1.png", @"sea_fish2.png", @"sea_fish3.png", nil];
    NSNumber *x, *y;
    
    for (int i = 0; i < [temparray count]; i++) {
        NSString *imageName = [temparray objectAtIndex:i];
        CCSprite *tempSprite = [CCSprite spriteWithSpriteFrameName:imageName];
        NSString *dicKey = [[imageName componentsSeparatedByString:@"."] objectAtIndex:0];
        NSDictionary *dict = [locations objectForKey:dicKey];
        x = [dict objectForKey:@"x"];
        y = [dict objectForKey:@"y"];
        [tempSprite setPosition:CGPointMake(x.integerValue, y.integerValue)];
        [tempSprite convertToWorldSpace:tempSprite.position];
        [baselayer addChild:tempSprite];
        if (i <= 6) {
            [objectsCantCollide addObject:tempSprite];
        } else if (i >= 12) {
            tempSprite.visible = FALSE;
            [sve addObject:tempSprite];
        }
    }
}

-(void) setLevelThree {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"level3_sprites.plist"];
    baselayer = [CCSpriteBatchNode batchNodeWithFile:@"level3_sprites.pvr.ccz"];
    [self addChild:baselayer];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"level3.png"];
    sprite.anchorPoint = ccp(0.5,0.5);
    sprite.position = ccp(winSize.width/2, winSize.height/2);
    [baselayer addChild:sprite];
    
    for (int i = 1; i <= 10; i ++) {
        [splashFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"spacesplash%d.png", i]]];
    }
    
    self.x_min = 40;
    self.x_max = 445;
    self.y_min = 54;
    self.y_max = 280;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Level3" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    locations = [dictionary objectForKey:@"points"];
    
    NSArray *temparray = [NSArray arrayWithObjects:@"space_scoreboard.png", nil];
    NSNumber *x, *y;
    
    for (int i = 0; i < [temparray count]; i++) {
        NSString *imageName = [temparray objectAtIndex:i];
        CCSprite *tempSprite = [CCSprite spriteWithSpriteFrameName:imageName];
        NSString *dicKey = [[imageName componentsSeparatedByString:@"."] objectAtIndex:0];
        NSDictionary *dict = [locations objectForKey:dicKey];
        x = [dict objectForKey:@"x"];
        y = [dict objectForKey:@"y"];
        [tempSprite setPosition:CGPointMake(x.integerValue, y.integerValue)];
        [tempSprite convertToWorldSpace:tempSprite.position];
        [baselayer addChild:tempSprite];
        if (i <= 1) {
            [objectsCantCollide addObject:tempSprite];
        }
    }
}

-(void) tryPopheads{
    @synchronized(heads) {
    	for (Character *head in heads) {
            if (CGPointEqualToPoint(head.position, CGPointZero)) {
                [self popHeadNew:head];
            }
        }
    }
}

-(BOOL) checkCollission: (Character *) head {
    //CGRect absrect1, absrect2;
    //absrect1 = CGRectMake(head.position.x, head.position.y, [head boundingBox].size.width, [head boundingBox].size.height);
    for (Character *head2 in heads) {
        //if this is itself, then skip it
        if ([head2 isEqual:head]) {
            continue;
        } else {
            //check for collision (i.e. overlap)
            //absrect2 = CGRectMake(head2.position.x, head2.position.y, [head2 boundingBox].size.width, [head2 boundingBox].size.height);
            if (CGRectIntersectsRect(head.boundingBox, head2.boundingBox)) {
                //CCLOG(@"intersected!");
                [head stopAllActions];
                head.position = CGPointZero;
                head.visible = FALSE;
                return YES;
            }
        }
    }
    return NO;
}

//-(BOOL) checkLocation:(CGPoint) point {
  //  for (Character *head in heads) {
    //    if (CGPointEqualToPoint(point, head.position))
      //      return YES;
   // }
    //return NO;
//}

-(BOOL) checkSplashCollission: (CCSprite *) splash {
    for (CCSprite *object in objectsCantCollide) {
        if (CGRectIntersectsRect(object.boundingBox, splash.boundingBox)) {
            //CCLOG(@"INTERSECTED!");
            return YES;
        }
    }
    return NO;
}

-(void) endSplashAction: (id)node {
    [[node parent] removeChild:node cleanup:YES];
}

- (void) popHeadNew: (Character *) head {
    CCSprite *splash;
    float delayTime;
    
    switch (level) {
        case hillLevel:
        {
            splash = [CCSprite spriteWithSpriteFrameName:@"mudsplash1.png"];
            delayTime = 0.6;
            break;
        }
        case seaLevel:
        {
            splash = [CCSprite spriteWithSpriteFrameName:@"watersplash1.png"];
            delayTime = 0.3;
            break;
        }
        case spaceLevel:
        {
            splash = [CCSprite spriteWithSpriteFrameName:@"spacesplash1.png"];
            delayTime = 0;
            break;
        }
    }
    [baselayer addChild:splash];
    
    do {
        int x = (arc4random() % (x_max - x_min + 1)) + x_min;
        int y = (arc4random() % (y_max - y_min + 1)) + y_min;
        
        [splash setPosition:CGPointMake(x, y)];
        [splash convertToWorldSpace:splash.position];
        
    } while ([self checkSplashCollission:splash]);
    
    //first check if splash collides with any of the objects
    //then set head position and check if head collides with any other heads
    //!!! NEED TO SCALE SPRITE HERE BASED ON Y_POSITION
    switch (level) {
        case hillLevel:
        {
            head.position = ccp(splash.position.x - 5, splash.position.y + 40);
            break;
        }
        case seaLevel:
        {
            head.position = ccp(splash.position.x, splash.position.y + 30);
            break;
        }
        case spaceLevel:
        {
            head.position = ccp(splash.position.x, splash.position.y);
            break;
        }
    }
    
    if ([self checkCollission:head]) {
        [self endSplashAction:splash];
        return; //do this because don't want 3 heads at same time
   }
    
    /*do {
        int index = (arc4random() % locations.count) + 1;
        NSDictionary *dict = [locations objectForKey:[NSString stringWithFormat:@"p%d", index]];
        x = [dict objectForKey:@"x"];
        y = [dict objectForKey:@"y"];
        zOrder = [dict objectForKey:@"z"];
    } while ([self checkLocation:CGPointMake(x.integerValue, y.integerValue)]);
    
    [head setZOrder:zOrder.integerValue];
    [head setPosition:CGPointMake(x.integerValue, y.integerValue)];
    [head convertToWorldSpace:head.position];
    
    if ([self checkCollission:head]) {
        return;
    }*/
    
    CCAnimation *splashAnim = [CCAnimation animationWithSpriteFrames:splashFrames delay:0.1f];
    CCRepeat *splashAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:splashAnim] times:1];
    CCCallFuncN *endSplashAction = [CCCallFuncN actionWithTarget:self selector:@selector(endSplashAction:)];
    [splash runAction:[CCSequence actions:splashAction, endSplashAction, nil]];
    
    if (level == spaceLevel) {
        //time scaling of head with the space splash animation
        head.scale = 0.1;
        CCScaleBy *scaleUp = [CCScaleBy actionWithDuration:0.5f scale:10];
        CCScaleBy *easeScaleUp = [CCEaseIn actionWithAction:scaleUp rate:10.0f];
        CCAction *easeScaleDown = [easeScaleUp reverse];
        CCDelayTime *delay_sprite = [CCDelayTime actionWithDuration:1.2];
        
        CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
        CCCallFuncN *setUntappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
        CCCallFuncN *resetHead = [CCCallFuncN actionWithTarget:self selector:@selector(resetHead:)];
        //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];
        
        [head runAction:[CCSequence actions: setTappable, easeScaleUp, delay_sprite, easeScaleDown, setUntappable, resetHead, nil]];
        
    } else {
        //need to delay the popping of head until the middle of mud animation
        CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.3f position:ccp(0, 60*3/4)];
        CCMoveBy *easeMoveUp = [CCEaseIn actionWithAction:moveUp rate:10.0f];
        CCAction *easeMoveDown = [easeMoveUp reverse];
        CCDelayTime *delay_splash = [CCDelayTime actionWithDuration:delayTime];
        CCDelayTime *delay_sprite = [CCDelayTime actionWithDuration:1.2];
        
        CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
        CCCallFuncN *setUntappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
        CCCallFuncN *resetHead = [CCCallFuncN actionWithTarget:self selector:@selector(resetHead:)];
        //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];
        
        [head runAction:[CCSequence actions: delay_splash, setTappable, easeMoveUp, delay_sprite, easeMoveDown, setUntappable, resetHead, nil]];
    }
}

//OLD POPHEADS INCLUDE BOMB CODE
/*-(void) popSeaLevelHeads: (Character *) head {
    NSNumber *x, *y, *zOrder;
    
    //if the position is not already occupied
    do {
        int index = (arc4random() % locations.count) + 1;
        NSDictionary *dict = [locations objectForKey:[NSString stringWithFormat:@"p%d", index]];
        x = [dict objectForKey:@"x"];
        y = [dict objectForKey:@"y"];
        zOrder = [dict objectForKey:@"z"];
    } while ([self checkLocation:CGPointMake(x.integerValue, y.integerValue)]);
    
    [head setZOrder:zOrder.integerValue];
    [head setPosition:CGPointMake(x.integerValue, y.integerValue)];
    [head convertToWorldSpace:head.position];
    
    if ([self checkCollission:head]) {
        return;
    }
    
    head.didMiss = TRUE;
    head.visible = TRUE;
    
    //splash animation
    CCSprite *splash = [CCSprite spriteWithSpriteFrameName:@"s1.png"];
    CGPoint splashPosition = head.position;
    //splashPosition.y -= 5;
    splash.position = splashPosition;
    [splashSheet addChild:splash z:head.zOrder+1];
    
    CCAnimation *splashAnim = [CCAnimation animationWithSpriteFrames:splashFrames delay:0.1f];
    CCRepeat *splashAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:splashAnim] times:1];
    CCCallFuncN *endSplashAction = [CCCallFuncN actionWithTarget:self selector:@selector(endSplashAction:)];
    [splash runAction:[CCSequence actions:splashAction, endSplashAction, nil]];
    
    
    //init all the actions
    //!!!!! NEED FOR THIS TIME TO MATCH THE ANIMATION TIME OF THE SPLASH!
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp(0, 10)];
    CCMoveBy *easeMoveUp = [CCEaseIn actionWithAction:moveUp rate:3.5];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0];
    
    CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFuncN *setUntappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
    CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
    //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];
    
    [head runAction:[CCSequence actions: setTappable, easeMoveUp, delay, easeMoveDown, setUntappable, checkCombo, nil]];

}

-(float) getAngleWithPts: (CGPoint) pt1 andPointTwo: (CGPoint) pt2 {
    float rise = pt2.y - pt1.y;
    float run = pt2.x - pt1.x;
    float angle = atanf(rise/run) * -1;
    //CCLOG(@"%f", angle);
    return angle;
}

-(void) popHillLevelHead: (Character *) head {
    NSNumber *x, *y, *zOrder;
    int randPt;
    NSArray *hillTop;
    
    //this loop only checks if the current hill position is taken
    do {
        int randHill = (arc4random() % locations.count) + 1;
        
        //pick a random hill
        hillTop = [locations objectForKey:[NSString stringWithFormat:@"hill%d", randHill]];
        
        //pick a random point on the hill
        randPt = arc4random() % hillTop.count;
        NSDictionary *dict = [hillTop objectAtIndex:randPt];
        x = [dict objectForKey:@"x"];
        y = [dict objectForKey:@"y"];
        zOrder = [dict objectForKey:@"z"];
    } while ([self checkLocation:CGPointMake(x.integerValue, y.integerValue)]);
    
    [head setZOrder:zOrder.integerValue];
    [head setZOrder:50];

    [head setPosition:CGPointMake(x.integerValue, y.integerValue)];
    [head convertToWorldSpace:head.position];
    
    if ([self checkCollission:head]) {
        return;
    }
    
    head.didMiss = TRUE;
    head.visible = TRUE;
    
    int randTilt;
    if (randPt ==0) { //if at beginning of hill, can only tilt to the right
        randTilt = 1;
    } else if (randPt == (hillTop.count-1)) {//if at end of hill, can only tilt to left
        randTilt = -1;
    } else {//somewhere in between
        randTilt = arc4random() % 2;
        if (randTilt == 0) {
            randTilt = -1;
        }
    }
    
    NSDictionary *pt2 = [hillTop objectAtIndex:(randPt + randTilt)];
    NSNumber *x2, *y2;
    x2 = [pt2 objectForKey:@"x"];
    y2 = [pt2 objectForKey:@"y"];
    CGPoint posTwo = CGPointMake(x2.integerValue, y2.integerValue);
    
    //returned angel is in radians
    float rotationAngle = [self getAngleWithPts:head.position andPointTwo:posTwo];
    
    //head.rotation is always in degrees
    head.rotation = CC_RADIANS_TO_DEGREES(rotationAngle);
    
    float height_now = head.contentSize.height * head.scaleY;
    
    //offset head by y = h * cos(theta), x = h*sin(theta)
    head.position = ccp(head.position.x - height_now * sin(rotationAngle), head.position.y - height_now * cos(rotationAngle));
    
    //No collission detected
    
    //pop bomb code
    10% chance for a bomb to popup
    //if (arc4random() % 100 < 10 && !has_bomb) {
      //  has_bomb = TRUE;
        //CCSprite *testObj = [CCSprite spriteWithFile:@"bomb.png"];
       // testObj.position = ccp(head.position.x + head.contentSize.width * head.scaleX/2, head.position.y+50);
     //   testObj.scale = 2.0;
     //   testObj.tag = 0; //tag will serve as hit or no-hit; 0 = nohit, 1 = hit
     //   [self addChild:testObj];
     //   [bomb addObject:testObj];
        
     //   CCRotateBy *rotateBomb = [CCRotateBy actionWithDuration:2.0f angle:(360*7)];
     //   CCCallFuncN *removeBomb = [CCCallFuncN actionWithTarget:self selector:@selector(removeBomb:)];
     //   [testObj runAction:[CCSequence actions: rotateBomb, removeBomb, nil]];
    }
    
    //hill animation
    CCSprite *splash = [CCSprite spriteWithSpriteFrameName:@"s1.png"];
    CGPoint splashPosition = head.position;
    splashPosition.y -= 30;
    splash.position = splashPosition;
    //splash.rotation = CC_RADIANS_TO_DEGREES(rotationAngle);
    [splashSheet addChild:splash z:head.zOrder+1];
    
    CCAnimation *splashAnim = [CCAnimation animationWithSpriteFrames:splashFrames delay:0.1f];
    CCRepeat *splashAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:splashAnim] times:1];
    CCCallFuncN *endSplashAction = [CCCallFuncN actionWithTarget:self selector:@selector(endSplashAction:)];
    [splash runAction:[CCSequence actions:splashAction, endSplashAction, nil]];
    
    //init all the actions
    //add the height of the body * 0.3 to the move: 59.5 * 0.3
    //CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp((height_now+20) * sin(rotationAngle), (height_now+20) * cos(rotationAngle))];
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:1.0 position:ccp(0,5)];
    CCMoveBy *easeMoveUp = [CCEaseIn actionWithAction:moveUp rate:3.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFuncN *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
    CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:2.0];
    //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];
        
    [head runAction:[CCSequence actions: setTappable, easeMoveUp, delay, easeMoveDown,unsetTappable, checkCombo, nil]];
}*/

-(void) setTappable: (id) sender {
    Character *head = (Character *) sender;
    [head setDidMiss:TRUE];
    [head setTappable:TRUE];
    [head setVisible:TRUE];
}

-(void) unSetTappable: (id) sender {
    Character *head = (Character *) sender;
    [head setTappable:FALSE];
}

-(void) removeFire {    
    [self removeChildByTag:fireTag cleanup:YES];
}

-(void) resetHead: (id) sender {
    HelloWorldScene *scene = (HelloWorldScene *)self.parent;
    Character *head = (Character *) sender;
    
    head.visible = FALSE;
    head.scale = 1.0f;
    head.position = CGPointZero;
    
    if ([head isSelectedHit] && !head.didMiss) {
        [self performSelector:@selector(removeFire) withObject:nil afterDelay:1.0f];
    }
    
    if (head.didMiss && head.isSelectedHit) {
        [scene resetConsecHits];
    }
    
    if ([head getChildByTag:burntTag]) {
        [head removeChildByTag:burntTag cleanup:YES];
    }
    
    //display rainbows according to hit streaks
    if (scene.consecHits == 0 && speed != DEFAULT_HEAD_POP_SPEED) {
        switch (level) {
            case hillLevel:
            {
                for (CCSprite *rainbow in sve) {
                    [rainbow stopAllActions];
                    rainbow.visible = FALSE;
                }
                break;
            }
            case seaLevel:
            {
                for (CCSprite *fish in sve) {
                    [fish stopAllActions];
                    fish.visible = FALSE;
                }
                break;
            }
            case spaceLevel:
            {
                
            }
                
                break;
        }
        
        sve_displayed = 0;
        speed = DEFAULT_HEAD_POP_SPEED;
        [self unschedule:@selector(tryPopheads)];
        [self schedule:@selector(tryPopheads) interval:speed];
        
    } else if (scene.consecHits != 0 && scene.consecHits % 5 == 0 && head.isSelectedHit){
        if (sve_displayed < [sve count]) {
            
        CCSprite *sve_unit = [sve objectAtIndex:sve_displayed];
        switch (level) {
            case hillLevel:
            {
                sve_unit.visible = TRUE;
                CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:80];
                CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
                CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actionOne:fadeOut two:fadeIn]];
                [sve_unit runAction:repeat];
                break;
            }
            case seaLevel:
            {
                sve_unit.visible = TRUE;
                CCMoveBy *moveleft = [CCMoveBy actionWithDuration:5.0 position:ccp(-40,0)];
                CCMoveBy *moveright = [CCMoveBy actionWithDuration:5.0 position:ccp(40,0)];
                CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actionOne:moveleft two:moveright]];
                [sve_unit runAction:repeat];
                break;
            }
            case spaceLevel:
            {
                break;
            }
        }
        
        sve_displayed++;
        }
        
        //update speed accordingly with combo times
        speed *= 0.5;
        [self unschedule:@selector(tryPopheads)];
        [self schedule:@selector(tryPopheads) interval:speed];
    }
}


//shake event handler
/*-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    float THRESHOLD = 2;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD ||
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        if (!shake_once) {
            //CCLOG(@"shake it baby from the scene");
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            shake_once = true;
            
            if (has_bomb) {
                for (CCSprite *tempbomb in bomb) {
                    tempbomb.tag = 1; //1 = hit
                    [tempbomb stopAllActions];
                    
                    CCScaleBy *scaleCoinUp = [CCScaleBy actionWithDuration:0.2 scale:2];
                    CCAction *scaleCoinDown = [scaleCoinUp reverse];
                    CCCallFuncN *removeCoin = [CCCallFuncN actionWithTarget:self selector:@selector(removeBomb:)];
                    [tempbomb runAction:[CCSequence actions:scaleCoinUp, scaleCoinDown, removeCoin, nil]];
                    break;
                }
            }
        }
    }
    else {
        shake_once = false;
    }
    
}*/

-(void) removeCoin: (id) sender {
    CCSprite *coin = (CCSprite *) sender;
    
    //[coins removeObject:coin];
    [self removeChild:coin cleanup:YES];
}

-(void) removeNode: (id) node {
    [node removeFromParentAndCleanup:YES];
}

-(void) generateExplosion: (id) node {
    CCSprite *temp = (CCSprite *)node;
    
    CCParticleSystem *emitter = [[CCParticleExplosion alloc] initWithTotalParticles:100];
    //set the location of the emitter
    emitter.autoRemoveOnFinish = YES;
    emitter.position = ccp(temp.position.x - temp.contentSize.width/2, temp.position.y - temp.contentSize.height/2);
    emitter.scale = 0.5;
    emitter.life = 0.5f;
    //add to layer ofcourse(effect begins after this step)
    [self addChild: emitter];
}

-(void) generateFire: (id) node {
    CCSprite *temp = (CCSprite *)node;
    
    CCParticleSystem *emitter = [[CCParticleFire alloc] initWithTotalParticles:200];
    //set the location of the emitter
    emitter.anchorPoint = ccp(0,0);
    emitter.position = ccp(temp.position.x + temp.contentSize.width/2 - 20, temp.position.y - temp.contentSize.height/2 - 40);
    emitter.scale = 0.5;
    emitter.life = 0.3f;
    emitter.speed = 300;
    emitter.speedVar = 10;
    if ([hammer_name isEqualToString:@"Hammer1.png"]) {
        emitter.startColor = ccc4f(0.75f, 0.5f, 0.2f, 1.0f);
        emitter.endColor = ccc4f(0.75f, 0.5f, 0.2f, 1.0f);
    } else if ([hammer_name isEqualToString:@"Hammer2.png"]) {
        emitter.startColor = ccc4f(0.5f, 0.3f, 0.2f, 1.0f);
        emitter.endColor = ccc4f(0.5f, 0.3f, 0.2f, 1.0f);
    } else if ([hammer_name isEqualToString:@"Hammer3.png"]) {
        emitter.startColor = ccc4f(0.2f, 0.6f, 0.2f, 1.0f);
        emitter.endColor = ccc4f(0.2f, 0.6f, 0.2f, 1.0f);
    } else {
        emitter.startColor = ccc4f(0.75f, 0.5f, 0.75f, 1.0f);
        emitter.endColor = ccc4f(0.75f, 0.5f, 0.75f, 1.0f);
    }
    //add to layer ofcourse(effect begins after this step)
    [self addChild: emitter z:20 tag:fireTag];
}

-(void) overlayBurn: (id) node {
    Character *head = (Character *) node;
    
    //head.visible = FALSE;
    CCSprite *burntEffect = [CCSprite spriteWithFile:@"burnt_effect2.png"];
    burntEffect.anchorPoint = ccp(0,0);
    burntEffect.position = ccp(-10, -20);
    burntEffect.scaleX = head.contentSize.width/burntEffect.contentSize.width * 1.4;
    burntEffect.scaleY = head.contentSize.height/burntEffect.contentSize.height * 1.4;
    [head addChild:burntEffect z:0 tag:burntTag];
}

- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //if (gamePaused) return;
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    HelloWorldScene *scene = (HelloWorldScene *)self.parent;
    
    //spritePosTest.position = ccp(location.x, location.y);

    /*for (CCSprite *coin in coins) {
        if (coin.tag == 1) {
            continue;
        }
        if (CGRectContainsPoint(coin.boundingBox, location)) {
            coin.tag = 1; //tag serves as coin.tappble = false
            [coin stopAllActions];
            //CCLOG(@"got coin!");
            [scene updateGold:10];
            CCScaleBy *scaleCoinUp = [CCScaleBy actionWithDuration:0.2 scale:2];
            CCAction *scaleCoinDown = [scaleCoinUp reverse];
            CCCallFuncN *removeCoin = [CCCallFuncN actionWithTarget:self selector:@selector(removeCoin:)];
            [coin runAction:[CCSequence actions:scaleCoinUp, scaleCoinDown, removeCoin, nil]];
            
            return YES;
        }
    }*/
    
    for (Character *head in heads) {
        if (head.tappable == FALSE) {
            continue;
        }
        
        if (CGRectContainsPoint(head.boundingBox, location)) {
            
            [head stopAllActions];
            head.didMiss = FALSE;
            head.tappable = FALSE;
            
            CCSprite *hammer = [CCSprite spriteWithFile:hammer_name];
            hammer.position = ccp(head.position.x + head.contentSize.width/2 + 20, head.position.y + head.contentSize.height/2 - 20);
            hammer.rotation = 45;
            hammer.anchorPoint = ccp(1, 0); //bottom right
            [self addChild:hammer z:50];
            
            CCRotateBy *smash = [CCRotateBy actionWithDuration:0.10f angle:-70];
            CCRotateBy *easeSmash = [CCEaseInOut actionWithAction:smash rate:3.0f];
            CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(removeNode:)];
            CCCallFuncN *explode = [CCCallFuncN actionWithTarget:self selector:@selector(generateExplosion:)];
            
            [hammer runAction:[CCSequence actions:easeSmash, explode, remove, nil]];
            
            //if hit the correct "mole"
            if (head.isSelectedHit) {
                
                AudioServicesPlaySystemSound(_rightHammerSound);
                
                //10% chance for a coin to popup
               // if (arc4random() % 100 < 10) {
                 //   CCSprite *testObj = [CCSprite spriteWithFile:@"coin front.png"];
                   // testObj.position = ccp(location.x, location.y);
                   // testObj.scale = 0.4;
                   // testObj.tag = 0;
                   // [self addChild:testObj];
                   // [coins addObject:testObj];
                    
                    //CCRotateBy *rotateCoin = [CCRotateBy actionWithDuration:1.9 angle:(360*7)];
                    //CCCallFuncN *removeCoin = [CCCallFuncN actionWithTarget:self selector:@selector(removeCoin:)];
                    //[testObj runAction:[CCSequence actions: rotateCoin, removeCoin, nil]];
                //}
                
                head.numberOfHits ++;
                int score_added = 5 + scene.consecHits / 5;
                [scene updateScore:score_added];
                
                //generate "combat text"
                CCLabelTTF *ctLabel;
                ctLabel = [CCLabelTTF labelWithString:@"+1" fontName:@"chalkduster" fontSize:30];
                ctLabel.color = ccc3(255, 0, 0);
                ctLabel.anchorPoint = ccp(0.5,0.5);
                [self addChild:ctLabel z:10];
                [ctLabel setString:[NSString stringWithFormat:@"+%i", score_added]];
                ctLabel.visible = TRUE;
                ctLabel.position = ccp(location.x, location.y);
                CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0];
                [ctLabel runAction:[CCSequence actions:delay, remove, nil]];

                [scene updateConsecHits];
                
                //CCDelayTime *delay = [CCDelayTime actionWithDuration:0.25];
                CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.25 position:ccp(0, -60)];
                CCMoveBy *easeMoveDown = [CCEaseInOut actionWithAction:moveDown rate:3.5];
                CCCallFuncN *resetHead = [CCCallFuncN actionWithTarget:self selector:@selector(resetHead:)];
                CCCallFuncN *fire = [CCCallFuncN actionWithTarget:self selector:@selector(generateFire:)];
                CCCallFuncN *overlayBurnt = [CCCallFuncN actionWithTarget:self selector:@selector(overlayBurn:)];
                
                [head runAction:[CCSequence actions: fire, overlayBurnt, easeMoveDown, resetHead, nil]];
                //[head runAction:[CCSequence actions: overlayBurnt, easeMoveDown, resetHead, nil]];
            } else {
                CGSize winSize = [CCDirector sharedDirector].winSize;
                
                AudioServicesPlaySystemSound(_wrongHammerSound);
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                CCSprite *redscreen = [CCSprite spriteWithSpriteFrameName:@"red_screen.png"];
                [baselayer addChild:redscreen];
                redscreen.anchorPoint = ccp(0.5,0.5);
                redscreen.position = ccp(winSize.width/2, winSize.height/2);
                redscreen.visible = TRUE;
                CCDelayTime *delay = [CCDelayTime actionWithDuration:0.5];
                CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(removeNode:)];
                [redscreen runAction:[CCSequence actions:delay, remove, nil]];
                
                [scene compareConsecHits];
                [scene resetConsecHits];
                
                //update lives
                [scene reduceHealth];
                
                head.numberOfHits ++;
                
                //send all heads down
                //for (Character *head2 in heads) {
                    //[head2 stopAllActions];
                CCCallFuncN *resetHead = [CCCallFuncN actionWithTarget:self selector:@selector(resetHead:)];
                [head runAction:[CCSequence actions: resetHead, nil]];
                //}
                break;
            }
            
            //float height_now = head.contentSize.height * head.scaleY;
            //float rotation = CC_DEGREES_TO_RADIANS(head.rotation);
            //CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.5 position:ccp(-(5+height_now) * sin(rotation), -(height_now+5) * cos(rotation))];
            //CCMoveBy *easeMoveDown = [CCEaseOut actionWithAction:moveDown rate:3.0];
            //need to remove hiteffect sprite just like the coins
            
            //stop the loop as we are not support multi-touch anymore
            return NO;
        }
    } //end heads loop

    return NO;
}

-(void) onExit {
    //[coins removeAllObjects];
    [heads removeAllObjects];
    [sve removeAllObjects];
    //[bomb removeAllObjects];
    AppDelegate *blah = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [blah switchToNormalBGM];
    
    //CGSize winsize = [[CCDirector sharedDirector] winSize];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    
    [super onExit];
}

-(void)setArrayForReview {
    Game *game = [Game sharedGame];
    
    NSArray *hitsArray = [NSArray arrayWithArray:heads];
    [game setArrayOfHits:hitsArray];
}

// on "dealloc" you need to release all your retained objects
@end

@implementation HelloWorldScene

@synthesize layer=_layer;
@synthesize hud=_hud;

static id<GameOverDelegate> gameOverDelegate = nil;


- (id)init {
    
    if ((self = [super init])) {
        
        lives = 3;
        consecHits = 0;
        max_consecHits = 0;
        baseScore = 0;
        //moneyEarned = 0;
        
        //score reading initializations
        NSString *path = [self dataFilepath];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        int bgs = [self readPlist:@"Bgs_Unlocked"];
        int hammers = [self readPlist:@"Hammers_Unlocked"];
        [[Game sharedGame] setHammers_to_random:hammers];
        [[Game sharedGame] setBgs_to_random:bgs];

        self.layer = [[HelloWorldLayer alloc] init];
        [self addChild:self.layer z:0];
        
        // 'hud' is the restart object
        self.hud = [[HUDLayer alloc] init];
        
        [self addChild:self.hud z:100];
        
    }
	
	return self;
}

-(void)gameOver:(BOOL)timeout {
    if (timeout) {
        [self.hud showGameOverLabel:@"Time's Up!"];
    } else {
        [self.hud showGameOverLabel:@"Game Over!"];
    }
    
    //update local storage
    int current_hs = [self readPlist:@"High_Score"];
    if (baseScore > current_hs) {
        [self writePlist:@"High_Score" withUpdate:baseScore];
    }
    
    int current_combo = [self readPlist:@"Highest_Combo"];
    if (max_consecHits > current_combo) {
        [self writePlist:@"Highest_Combo" withUpdate:max_consecHits];
    }
    
    int current_gp = [self readPlist:@"Games_Played"];
    [self writePlist:@"Games_Played" withUpdate:(current_gp + 1)];
    //unlock a new background for every 5 games played
    if ((current_gp + 1) % 5 == 0) {
        [[Game sharedGame] setUnlocked_new_bg:YES];
        int current_bgs_unlocked = [self readPlist:@"Bgs_Unlocked"];
        [self writePlist:@"Bgs_Unlocked" withUpdate:MAX(3, (current_bgs_unlocked + 1))];
    }
    
    if (baseScore > 500) {
        [[Game sharedGame] setUnlocked_new_hammer:YES];
        int current_hmr = [self readPlist:@"Hammers_Unlocked"];
        [self writePlist:@"Hammers_Unlocked" withUpdate:(current_hmr + 1)];
    }
    
    //turn off tutorial if successfully played 1 round of games
    if ([[dic objectForKey:@"Tutorial"] boolValue]) {
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"Tutorial"];
        [dic writeToFile:[self dataFilepath] atomically:NO];
    }
    
    Game *game = [Game sharedGame];
    [game setBaseScore:baseScore];
    //[game setMoneyEarned:moneyEarned];
    [game setMax_combo:max_consecHits];
    
    [self.layer setArrayForReview];

    [self performSelector:@selector(transitionToReview) withObject:nil];
    
    [self cleanup];
    [self finalCleanup];
}

-(void)finalCleanup {
    [self.layer finalCleanup];
    [self.hud finalCleanup];
    [self removeAllChildrenWithCleanup:YES];
    [self unscheduleUpdate];
    [self unscheduleAllSelectors];
}

//Plist methods
- (NSString *) dataFilepath {
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"ScorePlist.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"ScorePlist" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    
    return destPath;
}

- (void) writePlist: (NSString *) whichLbl withUpdate: (int) nmbr {
    [dic setObject:[NSNumber numberWithInt:nmbr] forKey:whichLbl];
    [dic writeToFile:[self dataFilepath] atomically:NO];
    
    NSLog(@"New %@: %i", whichLbl, [[dic objectForKey:whichLbl] intValue]);
}

- (int) readPlist: (NSString *) whichLbl {
    NSNumber *ret = [dic objectForKey:whichLbl];
    
    NSLog(@"%@: %i", whichLbl, [[dic objectForKey:whichLbl] intValue]);
    
    return [ret intValue];
}

-(void)transitionToReview {
    [gameOverDelegate proceedToReview];
    //[self removeAllChildrenWithCleanup:YES];
}

-(void)reduceHealth {
    lives -= 1;
    [self.hud removeHeart];
    
    if (lives <= 0) {
        [[CCDirector sharedDirector] pause];
        [self gameOver:NO];
    }
}

-(void)updateScore:(int)score {
    baseScore += score;
    [self.hud updateScore:baseScore];
    
}

-(void)updateConsecHits {
    consecHits++;
    [self.hud updateHits:consecHits];
}

-(void)resetConsecHits {
    consecHits = 0;
}

-(void)compareConsecHits {
    if (consecHits > max_consecHits) {
        max_consecHits = consecHits;
    }
}

//-(void)updateGold:(int)gold {
  //  moneyEarned += gold;
//}

-(NSInteger)consecHits {
    return consecHits;
}

//-(NSInteger)moneyEarned {
  //  return moneyEarned;
//}

-(NSInteger)baseScore {
    return baseScore;
}

+(void)setGameOverDelegate:(id<GameOverDelegate>)delegate {
    gameOverDelegate = delegate;
}

+(id<GameOverDelegate>)gameOverDelegate {
    return gameOverDelegate;
}

@end