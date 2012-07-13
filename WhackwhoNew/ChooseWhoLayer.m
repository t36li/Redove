//
//  ChooseWhoScene.m
//  MoleIt
//
//  Created by Bob Li on 12-06-25.
//  Copyright 2012 Waterloo. All rights reserved.
//

#import "ChooseWhoLayer.h"
#import "LevelOneLayer.h"

@implementation ChooseWhoLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseWhoLayer *layer = [ChooseWhoLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer z:0];
    
	// return the scene
	return scene;
}

-(id) init {
    
    if ((self = [super init])) {
        //tempDifficulty = [[Game sharedGame] difficulty];
        CGSize s = [[CCDirector sharedDirector] winSize];
        //popups = 2*tempDifficulty + 1;
        
        //testing
        tempDifficulty = 1;
        popups = 3;
        self.isTouchEnabled = YES;
        
        //finalFriendList = [[NSMutableArray alloc] init];
        //selectedHeads = [[NSMutableArray alloc] init];
        NSMutableArray *finalFriendList = [[Game sharedGame] friendList];
        NSMutableArray *selectedHeads = [[Game sharedGame] selectedHeads];
        [finalFriendList removeAllObjects];
        [selectedHeads removeAllObjects];
        
        //set background color to white
        CCSprite *bg1 = [CCSprite spriteWithFile:FriendList_bg];
        bg1.position = ccp(s.width/2, s.height/2);
        [self addChild:bg1];
        
        //set an instruction label
        CCLabelTTF *instruction = [CCLabelTTF labelWithString:@"Choose the Evil MOLE!" fontName:@"chalkduster" fontSize:40];
        instruction.color = ccc3(0, 0, 0);
        instruction.scale = 0.1;
        instruction.position = ccp(s.width/2, s.height - 50);
        [instruction runAction:[CCScaleTo actionWithDuration:0.5 scale:0.8]];
        [self addChild:instruction z:100];
        
        //set list of all facebook friends to select
        NSArray *friendList = [NSArray arrayWithObjects:@"baby.png", @"olaf.png", @"vlad.png", @"mice.png", @"pinky.png", @"monk.png", @"blue.png",nil];
        
        int randFriend;
        int listLength = [friendList count];
        
        //num of paddings = numofpopups + 1
        int hpad = (s.width - popups * 100) / (popups + 1); //(480 - 300)/4
        int vpad = 100;
        if ((s.width - popups*100) <= 0) {
            hpad = 25;
        }
        
        int i = 0;
        int index = 0;
        do {
            randFriend = arc4random() % listLength;
            NSString *friend = [friendList objectAtIndex:randFriend];
            // check to avoid duplicating heads
            if (![finalFriendList containsObject:friend]) {
                
                CCMenuItemImage *who = [CCMenuItemImage itemWithNormalImage:friend selectedImage:friend target:self selector:@selector(nextScene:)];
                who.tag = index;
                
                CCMenu *menu = [CCMenu menuWithItems:who, nil];
                if ((hpad*(i+1) + i*100) > 400) {
                    i = 0;
                    vpad = 200;
                }
                menu.anchorPoint = ccp(0,0);
                menu.position = ccp(hpad*(i+1) + i*100,vpad);
                //CCLOG(@"position: (%i, %i)", (int)menu.position.x, (int)menu.position.y);
                [self addChild:menu];
                
                i++;
                index++;
                popups -= 1;
                [finalFriendList addObject:friend];
            }
        } while (popups > 0);
        
        /*
         CCMenuItemImage *person1 = [CCMenuItemImage itemWithNormalImage:@"bob_resized.png" selectedImage:@"bob_resized.png" target:self selector:@selector(nextScene:)];
         person1.tag = 1;
         CCMenu *menu = [CCMenu menuWithItems:person1, nil];
         menu.position = ccp(60,150);
         [self addChild:menu];
         
         CCMenuItemImage *person2 = [CCMenuItemImage itemWithNormalImage:@"zach_resized.png" selectedImage:@"zach_resized.png" target:self selector:@selector(nextScene:)];
         person2.tag = 2;
         CCMenu *menu1 = [CCMenu menuWithItems:person2, nil];
         menu1.position = ccp(200,150);
         [self addChild:menu1];
         
         CCMenuItemImage *person3 = [CCMenuItemImage itemWithNormalImage:@"wensen_resized.png" selectedImage:@"wensen_resized.png" target:self selector:@selector(nextScene:)];
         person3.tag = 3;
         CCMenu *menu2 = [CCMenu menuWithItems:person3, nil];
         menu2.position = ccp(340,150);
         [self addChild:menu2];*/
    }
    return self;
}

-(void) nextScene: (id) sender {
    CCMenuItem *itm = (CCMenuItem *) sender;
    
    int index = itm.tag;
    
    //if already selected, then cant select anymore
    
    NSMutableArray *finalFriendList = [[Game sharedGame] friendList];
    NSMutableArray *selectedHeads = [[Game sharedGame] selectedHeads];
    NSString *friend = [finalFriendList objectAtIndex:index];
    
    if (![selectedHeads containsObject:friend]) {
        CCLOG(@"index: %d", index);
        CCLOG([finalFriendList objectAtIndex:index]);
        [selectedHeads addObject:[finalFriendList objectAtIndex:index]];
        tempDifficulty -= 1;
        
        if (tempDifficulty == 0) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
        }
    } else {
        CCLOG(@"already selected!");
    }
}

- (void) dealloc {
    //[finalFriendList release];
    //[selectedHeads release];
    [super dealloc];
}

@end
