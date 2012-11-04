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
#import "User.h"

//define tags
#define helmet_Label 1
#define body_Label 2
#define hammerHand_Label 3
#define shieldHand_Label 4

@implementation StatusBarController

@synthesize containerView;
@synthesize helmet, body, hammer_hand, shield_hand;
@synthesize faceView, helmetView, bodyView, hammerView, shieldView;
@synthesize stashItems, invItems;
@synthesize item1, item2, item3, item4, item5, item6, item7, item8, item9, item10;
@synthesize money, totalCash;
@synthesize equipments;
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
    invItems = [[NSMutableArray alloc] initWithCapacity:10];
    
    totalCash = 0;
    
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
    
    [faceView setContentMode:UIViewContentModeScaleAspectFill];
    [bodyView setContentMode:UIViewContentModeScaleToFill];
    [helmetView setContentMode:UIViewContentModeScaleAspectFill];
    [hammerView setContentMode:UIViewContentModeScaleAspectFill];
    [shieldView setContentMode:UIViewContentModeScaleAspectFill];
    
    //need to cache user's previous image
    UserInfo *usr = [UserInfo sharedInstance];
    if (usr.usrImg == nil){
        UIAlertView *takePicAlert = [[UIAlertView alloc] initWithTitle:@"Newbie?" message:@"Take a photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        takePicAlert.tag = 1;
        [takePicAlert show];
    }
}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        if (buttonIndex == 0){
            [self performSegueWithIdentifier:@"goToAvatar" sender:nil];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    UIImage *face_DB = [[UserInfo sharedInstance] croppedImage];
    
    if (faceView.image == face_DB && face_DB != nil)
        return;
        
    //!!!!!!!! need to retrive from database the current equipment!
    UserInfo *usinfo = [UserInfo sharedInstance];
    CurrentEquip *ce = usinfo.currentEquip;
    
    [faceView setImage:face_DB];
    
    [bodyView setImage:[UIImage imageNamed:ce.body]];
    [body setImage:[UIImage imageNamed:ce.body]];
    
    [helmetView setImage:[UIImage imageNamed:ce.helmet]];
    [helmet setImage:[UIImage imageNamed:ce.helmet]];
    
    [hammerView setImage:[UIImage imageNamed:ce.hammerArm]];
    [hammer_hand setImage:[UIImage imageNamed:ce.hammerArm]];
    
    [shieldView setImage:[UIImage imageNamed:ce.shieldArm]];
    [shield_hand setImage:[UIImage imageNamed:ce.shieldArm]];
    
    //animations
    //CCMoveBy *moveHeadUp = [CCMoveBy actionWithDuration:2.5 position:ccp(0,10)];
    //CCMoveBy *moveHeadDown = [CCMoveBy actionWithDuration:2.5 position:ccp(0,-10)];
    //[helmet runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:moveHeadUp two:moveHeadDown]]];
    
    //!!!!!!!! need to retrive from database the current storage!
    //will need to set tags for each item as well
    //tempmainarray max count = 10
    StorageInv *si = usinfo.storageInv;
    NSArray *tempMainArray = [[NSArray alloc] initWithArray:si.helmetsArrayInFileName];
    tempMainArray = [tempMainArray arrayByAddingObjectsFromArray:si.bodiesArrayInFileName];
    tempMainArray = [tempMainArray arrayByAddingObjectsFromArray:si.hammerArmsArrayInFileName];
    tempMainArray = [tempMainArray arrayByAddingObjectsFromArray:si.shieldArmsArrayInFileName];
    
    int numHelmets = si.helmetsArrayInFileName.count;
    int numBodies = si.bodiesArrayInFileName.count;
    int numHammer = si.hammerArmsArrayInFileName.count;
    //int numShield = si.shieldArmsArrayInFileName.count;
    
    for (int i = 0; i < tempMainArray.count; i++) {
        UIImageView *temp = [stashItems objectAtIndex:i];
        if (i < numHelmets) {
            temp.tag = helmet_Label;
            temp.image = nil;
            temp.image = [UIImage imageNamed:[tempMainArray objectAtIndex:i]];
        } else if (i < (numHelmets + numBodies)) {
            temp.tag = body_Label;
            temp.image = nil;
            temp.image = [UIImage imageNamed:[tempMainArray objectAtIndex:i]];
        } else if (i < (numHelmets + numBodies + numHammer)) {
            temp.tag = hammerHand_Label;
            temp.image = nil;
            temp.image = [UIImage imageNamed:[tempMainArray objectAtIndex:i]];
        } else {
            temp.tag = shieldHand_Label;
            temp.image = nil;
            temp.image = [UIImage imageNamed:[tempMainArray objectAtIndex:i]];
        }
    }
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
                    [helmetView setImage:[UIImage imageNamed:transparent_helmet]];
                    break;
                case body_Label:
                    [bodyView setImage:[UIImage imageNamed:standard_blue_body]];
                    break;
                case hammerHand_Label:
                    [hammerView setImage:nil];
                    break;
                case shieldHand_Label:
                    [shieldView setImage:nil];
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
                [UIView animateWithDuration:0.5f
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

//update Database:
-(void)updateDB{
    User *user = [[User alloc]init];
    UserInfo *uinfo = [UserInfo sharedInstance];
    user.whackWhoId = [uinfo whackWhoId];
    user.headId = uinfo.headId;
    user.currentEquip = [[[UserInfo sharedInstance] currentEquip] currentEquipInIDs];
    user.storageInv = [[[UserInfo sharedInstance] storageInv] setStorageStringInIDs];
    
    [[RKObjectManager sharedManager] putObject:user usingBlock:^(RKObjectLoader *loader){
        loader.targetObject = nil;
        loader.delegate = self;
    }];
}

- (IBAction)saveToDB_Touched:(id)sender {
    [self updateDB];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    NSLog(@"Load Database Failed:%@",error);
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    NSLog(@"loaded responses:%@",object);
    
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"request body:%@",[request HTTPBodyString]);
    NSLog(@"request url:%@",[request URL]);
    NSLog(@"response statue: %d", [response statusCode]);
    NSLog(@"response body:%@",[response bodyAsString]);
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
    //[self updateDB];
    [self performSegueWithIdentifier:@"StatusToModeSegue" sender:self];
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

@end
