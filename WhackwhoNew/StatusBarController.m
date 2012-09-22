//
//  StatusBarController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusBarController.h"
#import "StatusViewLayer.h"
#import "HelloWorldLayer.h"
#import "Dragbox.h"

//define tags
#define helmet_Label 1
#define body_Label 2
#define hammerHand_Label 3
#define shieldHand_Label 4

@implementation StatusBarController

@synthesize containerView;
@synthesize helmet, body, hammer_hand, shield_hand;
@synthesize stashItems;
@synthesize item1, item2, item3, item4, item5, item6, item7, item8, item9, item10;
@synthesize money, totalCash;
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
    
    equipments = [NSArray arrayWithObjects:helmet, body, hammer_hand, shield_hand, nil];
    
    orig_item_positions = [[NSMutableDictionary alloc] init];
    orig_equipment_positions = [[NSMutableDictionary alloc] init];
    
    totalCash = 0;
    
    //retrieve data from database about user's storage and display them accordingly
    //assume for testing the user has 4 items only...
    //for (int i = 0, i < [useritems count], i++) {
    //    UIImage *item = [useritems objectatindex: int];
    //    [stashItems objectAtIndex:i].image = item;
    //}
    //will need to set tags for each item as well
    item1.image = [UIImage imageNamed:devil_hammer];
    item1.tag = hammerHand_Label;
    item2.image = [UIImage imageNamed:standard_pink_head];
    item2.tag = helmet_Label;
    item3.image = [UIImage imageNamed:starting_shield];
    item3.tag = shieldHand_Label;
    item4.image = [UIImage imageNamed:starting_body];
    item4.tag = body_Label;
    item5.image = [UIImage imageNamed:rabbit_hammer];
    item5.tag = hammerHand_Label;
    
    //setUp tags for equipments
    helmet.tag = helmet_Label;
    body.tag = body_Label;
    hammer_hand.tag = hammerHand_Label;
    shield_hand.tag = shieldHand_Label;
    
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
        tap.numberOfTapsRequired = 1;
        [item addGestureRecognizer:tap];
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

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    UIImage *face_DB = [[UserInfo sharedInstance] croppedImage];
        
    //we will initialize all body part sprite here, then change the texture
    //!!! need to retrive from database the current equipment!
    
    //init face with image from DB, if none exists, give it blank (use pause.png for now)
    faceView = [[UIImageView alloc] initWithFrame:CGRectMake(43, 90, 85, 35)];
    [faceView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:faceView];
    [self.containerView sendSubviewToBack:faceView];
    [faceView setImage:face_DB];
    
    //init body
    bodyView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 148, 88, 63)];
    [bodyView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:bodyView];
    [bodyView setImage:[UIImage imageNamed:standard_blue_body]];
    
    //init helmet
    helmetView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 30, 120, 135)];
    [helmetView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:helmetView];
    [helmetView setImage:[UIImage imageNamed:standard_blue_head]];
    
    //init hammerHand
    hammerView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 134, 32, 39)];
    [hammerView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:hammerView];
    [hammerView setImage:[UIImage imageNamed:starting_hammer]];
    
    //init shieldHand
    shieldView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 145, 40, 40)];
    [shieldView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:shieldView];
    [shieldView setImage:[UIImage imageNamed:starting_shield]];
    
    //animations
    //CCMoveBy *moveHeadUp = [CCMoveBy actionWithDuration:2.5 position:ccp(0,10)];
    //CCMoveBy *moveHeadDown = [CCMoveBy actionWithDuration:2.5 position:ccp(0,-10)];
    //[helmet runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:moveHeadUp two:moveHeadDown]]];

}
// viewdidload gets called before this
/*-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if ([director isPaused]) {
        [director resume];
    }
    
    CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, 190, 250)
                                   pixelFormat:kEAGLColorFormatRGB565   //kEAGLColorFormatRGBA8
                                   depthFormat:0    //GL_DEPTH_COMPONENT24_OES
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    // HERE YOU CHECK TO SEE IF THERE IS A SCENE RUNNING IN THE DIRECTOR ALREADY
    if(![director runningScene]){
        [director setView:glView]; // SET THE DIRECTOR VIEW
        if( ! [director enableRetinaDisplay:YES] ) // ENABLE RETINA
            CCLOG(@"Retina Display Not supported");
        
        [director runWithScene:[StatusViewLayer scene]]; // RUN THE SCENE
        
    } else {
        // THERE IS A SCENE, START SINCE IT WAS STOPPED AND REPLACE TO RESTART
        [director startAnimation];
        [director.view setFrame:CGRectMake(0, 0, 190, 250)];
        [director replaceScene:[StatusViewLayer scene]];
    }
    
    [director willMoveToParentViewController:nil];
    [director.view removeFromSuperview];
    [director removeFromParentViewController];
    [director willMoveToParentViewController:self];
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    [self.containerView addSubview: director.view];
    [self.containerView sendSubviewToBack:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
}

- (void) viewDidDisappear:(BOOL)animated {
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
    
    [director end];
}*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - UI methods
- (void)handleTapOnItemImage: (UITapGestureRecognizer *)gesture {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
    UIImageView *item = ((UIImageView *)(tap.view));
    
    //set previously selected item's background to clearcolor
    for (UIImageView *item in stashItems) {
        if ([item.backgroundColor isEqual:[UIColor blackColor]]) {
            [item setBackgroundColor:[UIColor clearColor]];
            break;
        }
    }
    
    if ([item.image CGImage] != nil) {
        [item setBackgroundColor:[UIColor blackColor]];
    }
}


- (void)handleTapOnEquipmentImage: (UITapGestureRecognizer *)gesture {
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
    UIImageView *equipment = ((UIImageView *)(tap.view));
    
    for (UIImageView *item in stashItems) {
        
        if ([item.image CGImage] == nil) {
            item.tag = equipment.tag;
            item.image = equipment.image;
            equipment.image = nil;

            //call the cocos2d layer to remove the equipment
            switch (item.tag) {
                case helmet_Label:
                    [helmetView setImage:[UIImage imageNamed:standard_blue_head]];
                    break;
                case body_Label:
                    [bodyView setImage:[UIImage imageNamed:standard_blue_body]];
                    break;
                case hammerHand_Label:
                    [hammerView setImage:[UIImage imageNamed:starting_hammer]];
                    break;
                case shieldHand_Label:
                    [shieldView setImage:[UIImage imageNamed:starting_shield]];
                    break;
            }
            break;
        }
    }
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
                
                //put the other hammer into stash
                if (equipment.image != nil) {
                    for (UIImageView *item in stashItems) {
                        
                        if ([item.image CGImage] == nil) {
                            item.tag = equipment.tag;
                            item.image = equipment.image;
                            break;
                        }
                    }
                }
                
                //update equipment
                equipment.image = item.image;
                item.image = nil;
                
                //move the dragbox back to original position
                NSValue *pt = [orig_item_positions objectForKey:[NSString stringWithString:[item accessibilityLabel]]];
                item.center = [pt CGPointValue];
                
                //call the cocos2d layer to update character
                switch (item.tag) {
                    case helmet_Label:
                        [helmetView setImage:equipment.image];
                        break;
                    case body_Label:
                        [bodyView setImage:equipment.image];
                        break;
                    case hammerHand_Label:
                        [hammerView setImage:equipment.image];
                        break;
                    case shieldHand_Label:
                        [shieldView setImage:equipment.image];
                        break;
                }
                
                [item setBackgroundColor:[UIColor clearColor]];
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

/*-(void) viewWillDisappear:(BOOL)animated {
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
    
    [director end];
}*/

#pragma mark - touch methods

- (IBAction)Back_Touched:(id)sender {
    //if total stacks = 5, came from email..
    //else, came from facebook
    //int totalStacks = [self.navigationController.viewControllers count];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Ok_Pressed:(id)sender {
    //if no records with current whackwho_id, then insert.
    //else, update
    [self performSegueWithIdentifier:@"StatusToModeSegue" sender:sender];
}

- (IBAction)money_pressed:(id)sender {
    for (UIImageView *item in stashItems) {
        if ([item.backgroundColor isEqual:[UIColor blackColor]]) {
            //database kicks in here, updates... removes the item from the user's profile
            item.image = nil;
            totalCash += 100;
            [money setText:[NSString stringWithFormat:@"%i", totalCash]];
            [item setBackgroundColor:[UIColor clearColor]];
            break;
        }
    }
}

/*- (void)returnToMenu {
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

}*/

@end
