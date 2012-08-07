//
//  StatusBarController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusBarController.h"
#import "UserInfo.h"
#import "StatusViewLayer.h"
#import "HelloWorldLayer.h"
#import "Dragbox.h"

//define tags
#define head_Label 1
#define body_Label 2
#define leftHand_Label 3
#define rightHand_Label 4

@implementation StatusBarController

@synthesize containerView;
@synthesize helmet, body, left_hand, right_hand;
@synthesize stashItems;
@synthesize item1, item2, item3, item4, item5, item6, item7, item8, item9, item10;
//@synthesize cocosDelegate;

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view, this will only load once.
    
    stashItems =  [NSArray arrayWithObjects:item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, nil];
    
    equipments = [NSArray arrayWithObjects:helmet, body, left_hand, right_hand, nil];
    
    orig_item_positions = [[NSMutableDictionary alloc] init];
    orig_equipment_positions = [[NSMutableDictionary alloc] init];
    
    //retrieve data from database about user's gears and display them accordingly
    //assume for testing the user has 4 items only...
    //for (int i = 0, i < [useritems count], i++) {
    //    UIImage *item = [useritems objectatindex: int];
    //    [stashItems objectAtIndex:i].image = item;
    //}
    //will need to set tags for each item as well
    item1.image = [UIImage imageNamed:starting_hammer];
    item1.tag = leftHand_Label;
    item2.image = [UIImage imageNamed:standard_pink_head];
    item2.tag = head_Label;
    item3.image = [UIImage imageNamed:starting_shield];
    item3.tag = rightHand_Label;
    item4.image = [UIImage imageNamed:starting_body];
    item4.tag = body_Label;
    
    //setUp tags for equipments
    helmet.tag = head_Label;
    body.tag = body_Label;
    left_hand.tag = leftHand_Label;
    right_hand.tag = rightHand_Label;
    
    //set up touch gestures for stash items
    int i = 1;
    for (UIImageView *item in stashItems) {
        //add pan gesture (to view the glview)
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(itemDragged:)];
        [item addGestureRecognizer:gesture];
        //[item setBackgroundColor:[UIColor blackColor]];
        [item setAccessibilityLabel:[NSString stringWithFormat:@"Item%i", i]];
        
        //add original position to the array
        //NSLog(@"item accessibility identifier: %@", [item accessibilityIdentifier]);
        
        [orig_item_positions setObject:[NSValue valueWithCGPoint:item.center] forKey:[NSString stringWithString:[item accessibilityLabel]]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnItemImage:)];
        //tap.numberOfTapsRequired = 1;
        //[item addGestureRecognizer:tap];
        i++;
    }
    
    //set up touch gestures for equipement items
    i = 1;
    for (UIImageView *equipment in equipments) {
        //add pan gesture (to view the glview)
        //UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                           //initWithTarget:self
                                           //action:@selector(equipmentDragged:)];
        //[equipment addGestureRecognizer:gesture];
        //[equipment setBackgroundColor:[UIColor blackColor]];
        [equipment setAccessibilityLabel:[NSString stringWithFormat:@"Equipment%i", i]];

        //add original position to the array
        //NSLog(@"equipment accessibility label: %@", [equipment accessibilityLabel]);
        //NSLog(@"equipment center: x: %f y: %f", equipment.center.x, equipment.center.y);
        
        //[orig_equipment_positions setObject:[NSValue valueWithCGPoint:equipment.center] forKey:[NSString stringWithString:[equipment accessibilityLabel]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnEquipmentImage:)];
        tap.numberOfTapsRequired = 1;
        [equipment addGestureRecognizer:tap];
        i++;
    }
}


// viewdidload gets called before this
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    //photoView.image = [[UserInfo sharedInstance] exportImage];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if ([director isPaused]) {
        [director resume];
    }
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    [director setDisplayStats:NO];
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    [self.containerView addSubview: director.view];
    [self.containerView bringSubviewToFront:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    //CCScene *scene = [director runningScene];
    //id layer = [[scene children] objectAtIndex:0]; //returned nil
    //self.cocosDelegate = layer;
}

- (void)handleTapOnEquipmentImage: (UITapGestureRecognizer *)gesture {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
    UIImageView *equipment = ((UIImageView *)(tap.view));
    
    for (UIImageView *item in stashItems) {
        
        if ([item.image CGImage] == nil) {
            item.tag = equipment.tag;
            item.image = equipment.image;
            
            //call the cocos2d layer to remove the equipment
            CCScene *scene = [[CCDirector sharedDirector] runningScene];
            id layer = [[scene children] objectAtIndex:0];
            [layer updateCharacterWithImage:equipment.image bodyPart:equipment.tag];
            
            equipment.image = nil;
            break;
        }
        
                    
  /*          //call the cocos2d layer to remove the equipment
            CCScene *scene = [[CCDirector sharedDirector] runningScene];
            id layer = [[scene children] objectAtIndex:0];
            [layer updateCharacterWithImage:equipment.image bodyPart:equipment.tag];
            break;
            //if not in vincinity of any item boxes, switch back
        } else {
            //switch dragbox back to original position
            NSValue *pt = [orig_equipment_positions objectForKey:[NSString stringWithString:[equipment accessibilityLabel]]];
            equipment.center = [pt CGPointValue];
        }*/
    } // ends "for"
}

- (void)itemDragged:(UIPanGestureRecognizer *)gesture
{
	UIImageView *item = (UIImageView *)gesture.view;
    [self.view bringSubviewToFront:item];
	CGPoint translation = [gesture translationInView:item];
    
	// move label
	item.center = CGPointMake(item.center.x + translation.x,
                               item.center.y + translation.y);
    
    CGPoint newcenter = item.center;
    
    //stay within bounds
    float midPointX = CGRectGetMidX(item.bounds);
    //if too far right
    if (newcenter.x > self.view.bounds.size.width- midPointX) {
        newcenter.x = self.view.bounds.size.width - midPointX;
    //if too far left
    } else if (newcenter.x < midPointX) {
        newcenter.x = midPointX;
    }
    
    //if too far down
    float midPointY = CGRectGetMidY(item.bounds);
    if (newcenter.y > self.view.bounds.size.height - midPointY) {
        newcenter.y = self.view.bounds.size.height - midPointY;
     //if too far up...
    } else if (newcenter.y < midPointY) {
        newcenter.y = midPointY;
    }
    
    item.center = newcenter;
    
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        
        //check if collides with any equipment boxes after the user has lifted his/her finger
        for (UIImageView *equipment in equipments) {
            CGPoint snapLoc = equipment.center;
            double distance = sqrt(pow((newcenter.x - snapLoc.x), 2.0) + pow((newcenter.y - snapLoc.y), 2.0));
            
            //if the box gets in the vincinity of an equipment box AND is correct body part
            if (distance <= sqrt(pow(CGRectGetMidX(equipment.bounds), 2.0) + pow(CGRectGetMidY(equipment.bounds), 2.0)) && equipment.tag == item.tag) {
                [UIView animateWithDuration:0.1f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     item.center = snapLoc;
                                 }
                                 completion:nil];
                
                //set equipment image to the image being dragged. and item image to nil
                equipment.image = item.image;
                item.image = nil;
                
                //move the dragbox back to original position
                NSValue *pt = [orig_item_positions objectForKey:[NSString stringWithString:[item accessibilityLabel]]];
                item.center = [pt CGPointValue];
                
                //call the cocos2d layer to update character
                CCScene *scene = [[CCDirector sharedDirector] runningScene];
                id layer = [[scene children] objectAtIndex:0];
                [layer updateCharacterWithImage:equipment.image bodyPart:item.tag];
                break;
            //if not in vincinity AND invalid gear part
            } else {
                //move the dragbox back to original position
                NSValue *pt = [orig_item_positions objectForKey:[NSString stringWithString:[item accessibilityLabel]]];
                item.center = [pt CGPointValue];
            }
        } // ends "for"
    }
    
	// reset translation: do this last
	[gesture setTranslation:CGPointZero inView:item];
}

/*- (void)equipmentDragged:(UIPanGestureRecognizer *)gesture
{
	UIImageView *equipment = (UIImageView *)gesture.view;
    [self.view bringSubviewToFront:equipment];
	CGPoint translation = [gesture translationInView:equipment];
    
	// move label
	equipment.center = CGPointMake(equipment.center.x + translation.x,
                              equipment.center.y + translation.y);
    
    CGPoint newcenter = equipment.center;
    
    //stay within bounds
    float midPointX = CGRectGetMidX(equipment.bounds);
    //if too far right
    if (newcenter.x > self.view.bounds.size.width- midPointX) {
        newcenter.x = self.view.bounds.size.width - midPointX;
        //if too far left
    } else if (newcenter.x < midPointX) {
        newcenter.x = midPointX;
    }
    
    //if too far up
    float midPointY = CGRectGetMidY(equipment.bounds);
    if (newcenter.y > self.view.bounds.size.height - midPointY) {
        newcenter.y = self.view.bounds.size.height - midPointY;
        //if too far down...
    } else if (newcenter.y < midPointY) {
        newcenter.y = midPointY;
    }
    
    equipment.center = newcenter;
    
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        
        //check if collides with any equipment boxes after the user has lifted his/her finger
        for (UIImageView *item in stashItems) {
            CGPoint snapLoc = item.center;
            double distance = sqrt(pow((newcenter.x - snapLoc.x), 2.0) + pow((newcenter.y - snapLoc.y), 2.0));
            
            //if the box gets in the vincinity of an item box, clip it, and update cocos view
            if (distance <= sqrt(pow(CGRectGetMidX(item.bounds), 2.0) + pow(CGRectGetMidY(item.bounds), 2.0))) {
                [UIView animateWithDuration:0.1f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     equipment.center = snapLoc;
                                 }
                                 completion:nil];
                item.image = equipment.image;
                equipment.image = nil;
                
                //switch dragbox back to original position
                NSValue *pt = [orig_equipment_positions objectForKey:[NSString stringWithString:[equipment accessibilityLabel]]];
                equipment.center = [pt CGPointValue];
                
                //call the cocos2d layer to remove the equipment
                CCScene *scene = [[CCDirector sharedDirector] runningScene];
                id layer = [[scene children] objectAtIndex:0];
                [layer updateCharacterWithImage:equipment.image bodyPart:equipment.tag];
                break;
            //if not in vincinity of any item boxes, switch back
            } else {
                //switch dragbox back to original position
                NSValue *pt = [orig_equipment_positions objectForKey:[NSString stringWithString:[equipment accessibilityLabel]]];
                equipment.center = [pt CGPointValue];
            }
        } // ends "for"
    }
    
	// reset translation: do this last
	[gesture setTranslation:CGPointZero inView:equipment];
}*/

/*-(void) handleTapOnItemImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIImageView *itemView = ((UIImageView *)(tap.view));
}*/

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void) viewDidDisappear:(BOOL)animated {
    [[CCDirector sharedDirector].view setFrame:CGRectMake(0, 0, 480, 320)];
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer sceneWithDelegate:self]];
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] setDelegate:nil];
    //[[CCDirector sharedDirector] popScene];
    //[[CCDirector sharedDirector] pause];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)Back_Touched:(id)sender {
    //if total stacks = 5, came from email..
    //else, came from facebook
    //int totalStacks = [self.navigationController.viewControllers count];

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction) Ok_Pressed:(id)sender {
    [self performSegueWithIdentifier:@"StatusToModeSegue" sender:sender];
}

#pragma mark - gameOverDelegate Methods
- (void)returnToMenu {
    //UINavigationController *nav = self.navigationController;
    //if (![CCDirector sharedDirector].isPaused) {
    // [[CCDirector sharedDirector] pause];
    //}
    
    //[[CCDirector sharedDirector] popScene];
    int totalStack = [self.navigationController.viewControllers count];
    
    if (totalStack == 8) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:YES];
    } else {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
    
    [[CCDirector sharedDirector].view setFrame:CGRectMake(0, 0, 190, 250)];
    [[CCDirector sharedDirector] replaceScene:[StatusViewLayer scene]];
}

@end
