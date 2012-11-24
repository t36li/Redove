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

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize locations, splashSheet, splashFrames;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        //[self addChild:[CCSprite spriteWithFile:@"splash_sheet.png"]];

        self.isTouchEnabled = YES;
        CGSize winSize = [CCDirector sharedDirector].winSize;
                
        //init variables
        speed = DEFAULT_HEAD_POP_SPEED;
        //_hud = hud;
        //gamePaused = FALSE;
        has_bomb = FALSE;
        
        coins = [[NSMutableArray alloc] init];
        bomb = [[NSMutableArray alloc] init];
        heads = [[NSMutableArray alloc] init];
        splashFrames = [NSMutableArray array];

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"splash_sheet.plist"];
        splashSheet = [CCSpriteBatchNode batchNodeWithFile:@"splash_sheet.png"];
        [self addChild:splashSheet z:100];
        for (int i = 1; i <= 13; i ++) {
            [splashFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"s%d.png", i]]];
        }

        //determine which background to load
        int level = [[Game sharedGame] difficulty];
        level = 0;
        //0: Hills level
        //1: Water level
        
        switch (level) {
            case 1:
                [self performSelector:@selector(setSeaLevel)];
                break;
                
            default:
                [self performSelector:@selector(setHillsLevel)];
                break;
        }
        
        //code for initializing all other sprites + schedulers
        self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        shake_once = false;
        
        //add "hits" label
        hitsLabel = [CCLabelTTF labelWithString:@"X" fontName:@"chalkduster" fontSize:35];
        hitsLabel.color = ccc3(255, 0, 0);
        hitsLabel.anchorPoint = ccp(0.5,1);
        hitsLabel.position = ccp(winSize.width/2, winSize.height - 10);
        //hitsLabel.scale = 0.1;
        [self addChild:hitsLabel z:10];
        hitsLabel.visible = FALSE;
        
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
            //head.position = ccp(xpad, s.height/2);
            //xpad += 60;
            //head.visible = TRUE;
        }
        
        [self schedule:@selector(tryPopheads) interval:1.5];
        //[self schedule:@selector(checkGameState) interval:0.1];
	}
    
	return self;
}

-(void) setHillsLevel {
    //testing: hard-code 5 points
    /*botLeft = [[NSArray alloc] initWithObjects:
               [NSValue valueWithCGPoint:CGPointMake(16, 146)],
               [NSValue valueWithCGPoint:CGPointMake(63, 135.5)],
               [NSValue valueWithCGPoint:CGPointMake(105.5, 111)],
               [NSValue valueWithCGPoint:CGPointMake(135, 78.5)],
               [NSValue valueWithCGPoint:CGPointMake(151.5, 44)],
               nil];
    botRight = [[NSArray alloc] initWithObjects:
                [NSValue valueWithCGPoint:CGPointMake(390/2, 320-479/2)],
                [NSValue valueWithCGPoint:CGPointMake(504/2, 320-452/2)],
                [NSValue valueWithCGPoint:CGPointMake(634/2, 320-434/2)],
                [NSValue valueWithCGPoint:CGPointMake(763/2, 320-455/2)],
                [NSValue valueWithCGPoint:CGPointMake(872/2, 320-491/2)],
                nil];
    midLeft = [[NSArray alloc] initWithObjects:
               [NSValue valueWithCGPoint:CGPointMake(179/2, 320-326/2)],
               [NSValue valueWithCGPoint:CGPointMake(321/2, 320-296/2)],
               [NSValue valueWithCGPoint:CGPointMake(439/2, 320-345/2)],
               nil];
    midRight = [[NSArray alloc] initWithObjects:
                [NSValue valueWithCGPoint:CGPointMake(546/2, 320-334/2)],
                //[NSValue valueWithCGPoint:CGPointMake(648/2, 320-274/2)],
                [NSValue valueWithCGPoint:CGPointMake(772/2, 320-253/2)],
                [NSValue valueWithCGPoint:CGPointMake(905/2, 320-273/2)],
                nil];
    topMid = [[NSArray alloc] initWithObjects:
              //[NSValue valueWithCGPoint:CGPointMake(316/2, 320-262/2)],
              //[NSValue valueWithCGPoint:CGPointMake(357/2, 320-229/2)],
              [NSValue valueWithCGPoint:CGPointMake(411/2, 320-195/2)],
              [NSValue valueWithCGPoint:CGPointMake(466/2, 320-174/2)],
              [NSValue valueWithCGPoint:CGPointMake(553/2, 320-164/2)],
              [NSValue valueWithCGPoint:CGPointMake(609/2, 320-167/2)],
              [NSValue valueWithCGPoint:CGPointMake(672/2, 320-184/2)],
              //[NSValue valueWithCGPoint:CGPointMake(720/2, 320-202/2)],
              //[NSValue valueWithCGPoint:CGPointMake(761/2, 320-224/2)],
              nil];
    topLeft = [[NSArray alloc] initWithObjects:
               [NSValue valueWithCGPoint:CGPointMake(30/2, 320-153/2)],
               [NSValue valueWithCGPoint:CGPointMake(85/2, 320-151/2)],
               [NSValue valueWithCGPoint:CGPointMake(133/2, 320-166/2)],
               //[NSValue valueWithCGPoint:CGPointMake(188/2, 320-189/2)],
               //[NSValue valueWithCGPoint:CGPointMake(247/2, 320-233/2)],
               nil];
    topRight = [[NSArray alloc] initWithObjects:
                //[NSValue valueWithCGPoint:CGPointMake(804/2, 320-213/2)],
                [NSValue valueWithCGPoint:CGPointMake(843/2, 320-196/2)],
                [NSValue valueWithCGPoint:CGPointMake(897/2, 320-176/2)],
                //[NSValue valueWithCGPoint:CGPointMake(938/2, 320-169/2)],
                nil];*/
    CGSize winSize = [CCDirector sharedDirector].winSize;

    glClearColor(255, 255, 255, 255);
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"hillLevelBackground.pvr.ccz"];
    [self addChild:spritesBgNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hillLevelBackground.plist"];
    
    //because naming fucked up. L7 and L8 has to be swapped
    NSArray *images = [NSArray arrayWithObjects:@"L1.png", @"L2.png", @"L3.png", @"L4.png", @"L5.png", @"L6.png", @"L7.png", @"L8.png", @"L9.png", nil];
    for(int i = 0; i < images.count; ++i) {
        NSString *image = [images objectAtIndex:i];
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:image];
        sprite.anchorPoint = ccp(0.5,0.5);
        sprite.position = ccp(winSize.height/2, winSize.width/2);
        [spritesBgNode addChild:sprite z:(i*-10)];
    }
    
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
    
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"seaLevelBackground.pvr.ccz"];
    [self addChild:spritesBgNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"seaLevelBackground.plist"];
    
    //because naming fucked up. L7 and L8 has to be swapped
    NSArray *images = [NSArray arrayWithObjects:@"L1.png", @"L2.png", @"L3.png", @"L4.png", @"L5.png", @"L6.png", nil];
    for(int i = 0; i < images.count; ++i) {
        NSString *image = [images objectAtIndex:i];
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:image];
        sprite.anchorPoint = ccp(0.5,0.5);
        sprite.position = ccp(winSize.height/2, winSize.width/2);
        [spritesBgNode addChild:sprite z:(i*10)];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Level2" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    locations = [dictionary objectForKey:@"points"];
}

 -(void) cleanup {
     
     //check if game is over
     [self stopAllActions];
     [self unscheduleAllSelectors];
     [self removeAllChildrenWithCleanup:YES];
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
    
    //float numSelected = [[Game sharedGame] selectHeadCount];
    //float totalHeadNum = [[[Game sharedGame] arrayOfAllPopups] count];
    
    //int randFactor = (numSelected/totalHeadNum)*100;
    
    //selectedHeads/totalHeads chance to pop selected
    //hence, chance of popping correct head increases as u choose more heads
    /*
    for (Character *head in heads) {
        if (head.numberOfRunningActions == 0) {
            if (arc4random() % 100 < 75){//randFactor) {
                //pop the selected heads
                if (head.isSelectedHit == TRUE) {
                    //numHitOccur++;
                    [self popHeadNew:head];
                }
            } else {
                //pop the "bomb"
                if (head.isSelectedHit == FALSE) {
                    //numBombOccur++;
                    [self popHeadNew:head];
                }
            }
        }
    }*/
    
    @synchronized(heads) {
    	for (Character *head in heads) {
            if (CGPointEqualToPoint(head.position, CGPointZero)) {
                [self popHeadNew:head];
            }
        }
    }
}

-(BOOL) checkLocation:(CGPoint) point {
    for (Character *head in heads) {
        if (CGPointEqualToPoint(point, head.position))
            return YES;
    }
    return NO;
}


- (void) popHeadNew: (Character *) head {
    NSNumber *x, *y, *zOrder;
    
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
    
    head.didMiss = TRUE;
    head.visible = TRUE;
    

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
    //add the height of the body * 0.3 to the move: 59.5 * 0.3
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp(0, 40)];
    CCMoveBy *easeMoveUp = [CCEaseIn actionWithAction:moveUp rate:3.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:3.0];
    
    CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFuncN *setUntappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
    CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
    //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];
    
    [head runAction:[CCSequence actions: setTappable, easeMoveUp, delay, easeMoveDown, setUntappable, checkCombo, nil]];
}

-(void) endSplashAction: (id)node {
    [[node parent] removeChild:node cleanup:YES];
}

-(void) popHead: (Character *) head {
        
    float height_now = head.contentSize.height * head.scaleY; //76.5
    
    // algorithm: random the hill that it will pop up, then need to random the rotation... either left or right
    int randHill = arc4random() % 7;
    // Hill numberings:
    //  0: botLeft:-35: 5 possible
    //  1: botRight:-45: 5 possible
    //  2: midLeft:-55: 3 possible
    //  3: midRight:-65: 4 possible
    //  4: topMid:-75:  9 possible
    //  5: topLeft:-85: 5 possible
    //  6: topRight:-95: 4 possible

    NSArray *temp;    
    switch (randHill) {
        case 0:
            temp = botLeft;
            //adjust scale accordingly
            //head.scale *= 0.9;
            [head setZOrder:-35];
            break;
        case 1:
            temp = botRight;
            [head setZOrder:-45];
            break;
        case 2:
            temp = midLeft;
            [head setZOrder:-55];
            break;
        case 3:
            temp = midRight;
            [head setZOrder:-65];
            break;
        case 4:
            temp = topMid;
            [head setZOrder:-75];
            break;
        case 5  :
            temp = topLeft;
            [head setZOrder:-85];
            break;
        case 6:
            temp = topRight;
            [head setZOrder:-95];
            break;
    }
    
    int randTurn;
    int max = [temp count];
    int randPos = arc4random() % max;
    
    //  if the rand pos generated is the endpoint, then only 1 possible rotation turn
    if (randPos == 0) {
        randTurn = 1;
    } else if (randPos == (max - 1)) {
        randTurn = 0;
    } else {
        randTurn = arc4random() % 2;
    }
    
    if (randTurn == 0) {
        randTurn = -1;
    }
    
    CGPoint myPos = [[temp objectAtIndex:randPos] CGPointValue];
    CGPoint myPosTwo = [[temp objectAtIndex:(randPos + randTurn)] CGPointValue];
    
    head.position = myPos;
    //check if collides with all other heads ... problem is dunno which index this head is in...
    //int index = (int) [heads indexOfObject:head];
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
                head.position = ccp(0,0);
                //head.scale = 0.2;
                head.visible = FALSE;
                [head stopAllActions];
                return;
            }
        }
    }
    
    //now, this gets executed if no collission is detected....
    
#pragma mark - bomb popup code
    //10% chance for a bomb to popup
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
    //}
    
    //obtain rotation angle.... from method
    //angel is in radians already
    float rotationAngle = [self getAngleWithPts:myPos andPointTwo:myPosTwo];
    
    //head.rotation is always in degrees
    head.rotation = CC_RADIANS_TO_DEGREES(rotationAngle);
    head.didMiss = TRUE;
    
    //offset head by y = h * cos(theta), x = h*sin(theta)
    head.position = ccp(head.position.x - height_now * sin(rotationAngle), head.position.y - height_now * cos(rotationAngle));
    head.visible = TRUE;
    
    //init all the actions
    //add the height of the body * 0.3 to the move: 59.5 * 0.3
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp((height_now+20) * sin(rotationAngle), (height_now+20) * cos(rotationAngle))];
    CCMoveBy *easeMoveUp = [CCEaseIn actionWithAction:moveUp rate:3.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    CCCallFuncN *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFuncN *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unSetTappable:)];
    CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:3.0];
    //id action = [CCLiquid actionWithWaves:10 amplitude:20 grid:ccg(10,10) duration:5 ];

    [head runAction:[CCSequence actions: setTappable, easeMoveUp, delay, easeMoveDown,unsetTappable, checkCombo, nil]];
}

-(float) getAngleWithPts: (CGPoint) pt1 andPointTwo: (CGPoint) pt2 {
    float rise = pt2.y - pt1.y;
    float run = pt2.x - pt1.x;
    float angle = atanf(rise/run) * -1;
    //CCLOG(@"%f", angle);
    return angle;
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
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
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
    
}

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
                
                head.hp -= 2;
                head.numberOfHits ++;
                //update scores - show little label sign beside
                int score_added = 5 + scene.consecHits / 5;
                [scene updateScore:score_added];
                
                //generate crit label
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
                
                //update hit streak label
                [scene updateConsecHits];
                if (scene.consecHits > 1) {
                    [hitsLabel setString:[NSString stringWithFormat:@"X%i", scene.consecHits]];
                }
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
            
            float height_now = head.contentSize.height * head.scaleY;
            
            float rotation = CC_DEGREES_TO_RADIANS(head.rotation);
            CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.5 position:ccp(-(5+height_now) * sin(rotation), -(height_now+5) * cos(rotation))];
            CCMoveBy *easeMoveDown = [CCEaseOut actionWithAction:moveDown rate:3.0];
            CCCallFuncN *checkCombo = [CCCallFuncN actionWithTarget:self selector:@selector(checkCombo:)];
            
            [head runAction:[CCSequence actions: easeMoveDown, checkCombo, nil]];
            
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
@synthesize gameOverDelegate;


- (id)init {
    
    if ((self = [super init])) {
        
        lives = 3;
        consecHits = 0;
        baseScore = 0;
        moneyEarned = 0;

        self.layer = [HelloWorldLayer node];
        [self addChild:self.layer z:0];
        
        // 'hud' is the restart object
        self.hud = [HUDLayer node];
        [self addChild:self.hud z:100];
        
    }
	
	return self;
}

-(void)gameOver:(BOOL)timeout {
    //update "score"
    [self.layer cleanup];
    
    
    NSString *msg;
    if (timeout) {
        msg = @"Time's UP!";
    } else {
        msg = @"Game OVER!";
    }
    CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:msg fontName:@"Chalkduster" fontSize:50];
    gameOverLabel.position = ccp(200,200);
    [self addChild:gameOverLabel];
    
    
    [self performSelector:@selector(transitionToReview) withObject:nil afterDelay:2.0];
    
    
    Game *game = [Game sharedGame];
    [game setBaseScore:baseScore];
    [game setMoneyEarned:moneyEarned];
    [game setMultiplier:consecHits];
}

-(void)transitionToReview {
    [self.gameOverDelegate proceedToReview];
}

-(void)reduceHealth {
    lives -= 1;
    
    if (lives <= 0) {
        [self gameOver:NO];
    }
}

-(void)updateScore:(int)score {
    baseScore = score;
    [self.hud updateScore:baseScore];
}

-(void)updateConsecHits {
    consecHits++;
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
@end