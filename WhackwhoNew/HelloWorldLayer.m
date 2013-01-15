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

#define hillLevel 0
#define seaLevel 1

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize locations, splashSheet, splashFrames;

// on "init" you need to initialize your instance
-(id) init
{

	if( (self=[super init]) ) {
        
	}
    
	return self;
}

-(void) onEnter {
    [super onEnter];
    
    self.isTouchEnabled = YES;
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //init variables
    speed = DEFAULT_HEAD_POP_SPEED;
    has_bomb = FALSE;
    
    if ([[CCDirector sharedDirector] isPaused]) {
        [[CCDirector sharedDirector] resume];
    }
    
    coins = [[NSMutableArray alloc] init];
    bomb = [[NSMutableArray alloc] init];
    heads = [[NSMutableArray alloc] init];
    
    //determine which background to load
    //if unlocked new level, then randomize
    int temp = [[Game sharedGame] bgs_to_random];
    if (temp == 0) {
        level = seaLevel;
    } else {
        level = arc4random() % temp;
    }
    
    switch (level) {
        case hillLevel:
            [self performSelector:@selector(setHillsLevel)];
            break;
        case seaLevel:
            [self performSelector:@selector(setSeaLevel)];
            break;
    }
    
    //initialize shake handler
    //self.isAccelerometerEnabled = YES;
    //[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
    //shake_once = false;
    
    //!!!! initializing popups
    //use the array from game.h which contains all image names
    //int xpad = 50; //for testing
    int i = 0;
    for (UIImage *person in [[Game sharedGame] arrayOfAllPopups]) {
        Character *head = [Character spriteWithCGImage:[person CGImage] key:[NSString stringWithFormat:@"person%i", i]];
        
        if (i < [[Game sharedGame] selectHeadCount]) {
            head.isSelectedHit = TRUE;
        } else {
            head.isSelectedHit = FALSE;
        }
        
        head.visible = FALSE;
        head.position = CGPointZero;
        
        [self addChild:head];
        [heads addObject:head];
        i++; //for key purposes
        
        //for testing
        //head.position = ccp(xpad, winSize.height/2);
        //xpad += 60;
        //head.visible = TRUE;
    }
    
    [self schedule:@selector(tryPopheads) interval:1.5];
     
}

-(void) setHillsLevel {
    CGSize winSize = [CCDirector sharedDirector].winSize;

    glClearColor(255, 255, 255, 255);
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
    splashFrames = [NSMutableArray array];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"splash_sheet.plist"];
    splashSheet = [CCSpriteBatchNode batchNodeWithFile:@"splash_sheet.png"];
    [self addChild:splashSheet z:100];
    for (int i = 1; i <= 13; i ++) {
        [splashFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"s%d.png", i]]];
    }
    
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"Hills_Level_Background.pvr.ccz"];
    [self addChild:spritesBgNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Hills_Level_Background.plist"];
    
    //hills_background is the farthest back
    //NSArray *imageNames = [NSArray arrayWithObjects: hills_background, hill_topmid, hill_topleft, hill_topright, hill_midmid, hill_midleft, hill_midright, hill_botmid, hill_botleft, hill_botright, nil];
    NSArray *imageNames = [NSArray arrayWithObjects:hill_botright, hill_botleft, hill_botmid, hill_midright, hill_midleft, hill_midmid, hill_topright, hill_topleft, hill_topmid, hills_background, nil];
    
    for(int i = 0; i < imageNames.count; ++i) {
        NSString *image = [imageNames objectAtIndex:i];
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:image];
        sprite.anchorPoint = ccp(0.5,0.5);
        sprite.position = ccp(winSize.width/2, winSize.height/2);
        [spritesBgNode addChild:sprite z:(i*-10)];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Level1" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    locations = [dictionary objectForKey:@"points"];
    
    //add "rainbows" !!! do this in spritesheet later on
    /*rainbows = [[NSMutableArray alloc] init];
    CCSprite *rainbow = [CCSprite spriteWithFile:@"rainbow4.png"];
    rainbow.position = ccp(156, 192);
    rainbow.visible = FALSE;
    [rainbows addObject:rainbow];
    CCSprite *rainbow2 = [CCSprite spriteWithTexture:[rainbow texture]];
    rainbow2.position = ccp(14, 247);
    rainbow2.scale = 0.5;
    rainbow2.visible = FALSE;
    [rainbows addObject:rainbow2];
    CCSprite *rainbow3 = [CCSprite spriteWithTexture:[rainbow texture]];
    rainbow3.position = ccp(443, 214);
    rainbow3.scale = 0.8;
    rainbow3.visible = FALSE;
    [rainbows addObject:rainbow3];
    CCSprite *rainbow4 = [CCSprite spriteWithTexture:[rainbow texture]];
    rainbow4.position = ccp(305, 220);
    rainbow4.scale = 0.3;
    rainbow4.visible = FALSE;
    [rainbows addObject:rainbow4];
    [self addChild:rainbow4 z:-95];
    [self addChild:rainbow3 z:-95];
    [self addChild:rainbow2 z:-95];
    [self addChild:rainbow z:-95];*/
}

-(void) setSeaLevel {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    glClearColor(255, 255, 255, 255);
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
    splashFrames = [NSMutableArray array];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"splash_sheet.plist"];
    splashSheet = [CCSpriteBatchNode batchNodeWithFile:@"splash_sheet.png"];
    [self addChild:splashSheet z:100];
    for (int i = 1; i <= 13; i ++) {
        [splashFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"s%d.png", i]]];
    }
    
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"seaLevelBackground.pvr.ccz"];
    [self addChild:spritesBgNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"seaLevelBackground.plist"];
    
    NSArray *images = [NSArray arrayWithObjects:@"L1.png", @"L2.png", @"L3.png", @"L4.png", @"L5.png", @"L6.png", nil];
    for(int i = 0; i < images.count; ++i) {
        NSString *image = [images objectAtIndex:i];
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:image];
        sprite.anchorPoint = ccp(0.5,0.5);
        sprite.position = ccp(winSize.width/2, winSize.height/2);
        [spritesBgNode addChild:sprite z:(i*10)];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Level2" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    locations = [dictionary objectForKey:@"points"];
}

-(void) onExit {
    [coins removeAllObjects];
    [heads removeAllObjects];
    [bomb removeAllObjects];
    [rainbows removeAllObjects];
    
    //CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    [super onExit];
 }

-(void)setArrayForReview {
    Game *game = [Game sharedGame];

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:game.selectHeadCount];
    for (int i = 0; i < game.selectHeadCount; i ++) {
        [array addObject:[heads objectAtIndex:i]];
    }
    [game setArrayOfHits:array];
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
    //Collission checking code? Inefficient
    CGRect absrect1, absrect2;
    absrect1 = CGRectMake(head.position.x, head.position.y, [head boundingBox].size.width, [head boundingBox].size.height);
    for (Character *head2 in heads) {
        //if this is itself, then skip it
        if ([head2 isEqual:head]) {
            continue;
        } else {
            //check for collision (i.e. overlap)
            absrect2 = CGRectMake(head2.position.x, head2.position.y, [head2 boundingBox].size.width, [head2 boundingBox].size.height);
            if (CGRectIntersectsRect(absrect1, absrect2)) {
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

-(BOOL) checkLocation:(CGPoint) point {
    for (Character *head in heads) {
        if (CGPointEqualToPoint(point, head.position))
            return YES;
    }
    return NO;
}

- (void) popHeadNew: (Character *) head {
    
    switch (level) {
        case hillLevel:
            [self popHillLevelHead:head];
            break;
        case seaLevel:
            [self popSeaLevelHeads:head];
            break;
    }
}

-(void) endSplashAction: (id)node {
    [[node parent] removeChild:node cleanup:YES];
}

-(void) popSeaLevelHeads: (Character *) head {
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
    splashPosition.y -= 30;
    splash.position = splashPosition;
    [splashSheet addChild:splash z:head.zOrder+1];
    
    CCAnimation *splashAnim = [CCAnimation animationWithSpriteFrames:splashFrames delay:0.1f];
    CCRepeat *splashAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:splashAnim] times:1];
    CCCallFuncN *endSplashAction = [CCCallFuncN actionWithTarget:self selector:@selector(endSplashAction:)];
    [splash runAction:[CCSequence actions:splashAction, endSplashAction, nil]];
    
    
    //init all the actions
    //!!!!! NEED FOR THIS TIME TO MATCH THE ANIMATION TIME OF THE SPLASH!
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp(0, 25)];
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
    
    /*int randTilt;
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
    head.position = ccp(head.position.x - height_now * sin(rotationAngle), head.position.y - height_now * cos(rotationAngle));*/
    
    //No collission detected
    
    //pop bomb code
    /*10% chance for a bomb to popup
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
    }*/
    
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
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:1.0 position:ccp(0,40)];
    CCMoveBy *easeMoveUp = [CCEaseIn actionWithAction:moveUp rate:3.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFuncN *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
    CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:2.0];
    //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];
        
    [head runAction:[CCSequence actions: setTappable, easeMoveUp, delay, easeMoveDown,unsetTappable, checkCombo, nil]];
}

-(void) setTappable: (id) sender {
    Character *head = (Character *) sender;
    [head setTappable:TRUE];
}

-(void) unSetTappable: (id) sender {
    Character *head = (Character *) sender;
    [head setTappable:FALSE];
}

-(void) checkCombo: (id) sender {
    HelloWorldScene *scene = (HelloWorldScene *)self.parent;
    Character *head = (Character *) sender;

    head.rotation = 0;
    head.position = ccp(0,0);
    //head.scale = 0.2;
    head.visible = NO;

    if (head.didMiss && head.isSelectedHit) {
        [scene resetConsecHits];
    }
    
    //display rainbows according to hit streaks
    if (scene.consecHits == 0 && speed != DEFAULT_HEAD_POP_SPEED) {
        
        //set all rainbows to not visible
       // for (CCSprite *rainbow in rainbows) {
         //   rainbow.visible = FALSE;
        //}
        
        speed = DEFAULT_HEAD_POP_SPEED;
        [self unschedule:@selector(tryPopheads)];
        [self schedule:@selector(tryPopheads) interval:speed];
        
    } else if (scene.consecHits % 5 == 0){
        
        //show rainbows every 5 hit combos
        //for (CCSprite *rainbow in rainbows) {
          //  if (rainbow.visible == FALSE) {
            //    [rainbow setVisible:TRUE];
              //  CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:80];
               // CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:255];
               // CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actionOne:fadeOut two:fadeIn]];
                //[rainbow runAction:repeat];
                //break;
            //}
        //}
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

-(void) removeHitEffect: (id) sender {
    CCSprite *hitEffect = (CCSprite *) sender;
    [self removeChild:hitEffect cleanup:YES];
}

//-(void) removeBomb: (id) sender {
  //  CCSprite *tempbomb = (CCSprite *) sender;
    
   // if (tempbomb.tag == 0) {
     //   lives -= 1;
       // if ([hearts count] > 0) {
         //   [self removeChild:[hearts objectAtIndex:[hearts count] - 1] cleanup:YES];
           // [hearts removeLastObject];
        //}

    //    baseScore -= 10;
    //}
    
    //has_bomb = FALSE;
    //[self removeChild:tempbomb cleanup:YES];
//}



- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) removeCoin: (id) sender {
    CCSprite *coin = (CCSprite *) sender;
    
    [coins removeObject:coin];
    [self removeChild:coin cleanup:YES];
}

-(void) removeNode: (id) node {
    [self removeChild:node cleanup:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //if (gamePaused) return;
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    HelloWorldScene *scene = (HelloWorldScene *)self.parent;

    //CCLOG(@"x: %f, y: %f", location.x, location.y);
    
    for (CCSprite *coin in coins) {
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
    }
    
    for (Character *head in heads) {
        if (head.tappable == FALSE) {
            continue;
        }
        
        if (CGRectContainsPoint(head.boundingBox, location)) {
            
            [head stopAllActions];
            head.didMiss = FALSE;
            head.tappable = FALSE;
            
            //need to remove hiteffect sprite just like the coins
            CCSprite *hitEffect = [CCSprite spriteWithFile:@"hit effect.png"];
            hitEffect.scale = 0.01;
            hitEffect.position = ccp(head.position.x + head.contentSize.width * head.scaleX/2, head.position.y);
            [self addChild:hitEffect];
            CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:0.1 scale:1.0];
            CCScaleTo *scaleDown = [CCScaleTo actionWithDuration:0.1 scale:0.01];
            CCCallFuncN *removeHitEffect = [CCCallFuncN actionWithTarget:self selector:@selector(removeHitEffect:)];
            [hitEffect runAction:[CCSequence actions:scaleUp, scaleDown, removeHitEffect, nil]];
            
            //if hit the correct "mole"
            if (head.isSelectedHit) {
                
                //10% chance for a coin to popup
                if (arc4random() % 100 < 10) {
                    CCSprite *testObj = [CCSprite spriteWithFile:@"coin front.png"];
                    testObj.position = ccp(location.x, location.y);
                    testObj.scale = 0.4;
                    testObj.tag = 0;
                    [self addChild:testObj];
                    [coins addObject:testObj];
                    
                    CCRotateBy *rotateCoin = [CCRotateBy actionWithDuration:1.9 angle:(360*7)];
                    CCCallFuncN *removeCoin = [CCCallFuncN actionWithTarget:self selector:@selector(removeCoin:)];
                    [testObj runAction:[CCSequence actions: rotateCoin, removeCoin, nil]];
                }
                
                //head.hp -= 2;
                //head.numberOfHits ++;
                //update scores - show little label sign beside
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
                ctLabel.position = ccp(head.position.x, head.position.y);
                CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0];
                CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(removeNode:)];
                [ctLabel runAction:[CCSequence actions:delay, remove, nil]];
                

                [scene updateConsecHits];

                
                //if not hit correct "mole"
            } else {
                
                //vibrate to indicate mis-hit
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                [scene resetConsecHits];
                
                //update lives
                [scene reduceHealth];
                
                //send all heads down
                for (Character *head in heads) {
                    [head stopAllActions];
                    head.visible = FALSE;
                    head.tappable = FALSE;
                    [head runAction:[CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)]];
                }
                break;
            }
            
            //float height_now = head.contentSize.height * head.scaleY;
            
            //float rotation = CC_DEGREES_TO_RADIANS(head.rotation);
            //CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.5 position:ccp(-(5+height_now) * sin(rotation), -(height_now+5) * cos(rotation))];
            //CCMoveBy *easeMoveDown = [CCEaseOut actionWithAction:moveDown rate:3.0];
            CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
            
            [head runAction:[CCSequence actions: checkCombo, nil]];
            
            //stop the loop as we are not support multi-touch anymore
            return YES;
        }
    } //end heads loop*/
    
    return NO;
}


/*
-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
}
*/
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
        baseScore = 0;
        moneyEarned = 0;
        
        //score reading initializations
        NSString *path = [self dataFilepath];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [[Game sharedGame] setBgs_to_random:[self readPlist:@"Bg_Unlocked"]];

        self.layer = [[HelloWorldLayer alloc] init];
        [self addChild:self.layer z:0];
        
        // 'hud' is the restart object
        self.hud = [[HUDLayer alloc] init];
        
        [self addChild:self.hud z:100];
        
    }
	
	return self;
}

-(void)gameOver:(BOOL)timeout {
    //update scores
    int current_hs = [self readPlist:@"High_Score"];
    if (baseScore > current_hs) {
        [self writePlist:@"High_Score" withUpdate:baseScore];
    }
    
    int current_gold = [self readPlist:@"Total_Gold"];
    [self writePlist:@"Total_Gold" withUpdate:(current_gold + moneyEarned)];
    
    int current_gp = [self readPlist:@"Games_Played"];
    [self writePlist:@"Games_Played" withUpdate:(current_gp + 1)];
    
    //unlock a new background for every 5 games played
    if (current_gp >= 5) {
        [[Game sharedGame] setLevelsUnlocked:1];
        int current_bg_unlocked = [self readPlist:@"Bg_Unlocked"];
        
        [self writePlist:@"Bg_Unlocked" withUpdate:(current_bg_unlocked + 1)];
    }

    [self cleanup];
    
    //NSString *msg;
    //if (timeout) {
        //msg = @"Time's UP!";
    //} else {
      //  msg = @"Game OVER!";
    //}
    
    //[self.hud showGameOverLabel:msg];
    
    [self performSelector:@selector(transitionToReview) withObject:nil afterDelay:2.0];
    
    
    Game *game = [Game sharedGame];
    [game setBaseScore:baseScore];
    [game setMoneyEarned:moneyEarned];
    [game setMultiplier:consecHits];
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

-(void)updateGold:(int)gold {
    moneyEarned += gold;
}

-(NSInteger)consecHits {
    return consecHits;
}

-(NSInteger)moneyEarned {
    return moneyEarned;
}

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