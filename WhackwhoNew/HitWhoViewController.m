//
//  ModeSelectionViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HitWhoViewController.h"
#import "Friend.h"
#import "UserInfo.h"
#import "FBSingletonNew.h"

#define ChooseToGame @"chooseToGame"
#define dummyString @"testobject"
#define pi 3.14159265359
//#define MAX_HIT 2

@implementation HitWhoViewController

@synthesize hit1, hit2, hit3, hit4;
//@synthesize defaultImage;

@synthesize containerView;
@synthesize faceView, helmetView, bodyView, hammerView, shieldView;
@synthesize hitNumber, leftHammer, rightHammer;

@synthesize table;
@synthesize spinner, loadingView;
@synthesize resultFriends, resultStrangers, hitWindows;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    friendSelected = nil;
    
    hitWindows = [[NSArray alloc] initWithObjects:hit1, hit2, hit3, hit4, nil];
    for (HitWindow *hit in hitWindows) {
        if (![hit gestureRecognizers]) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnImage:)];
            tap.numberOfTapsRequired = 1;
            [hit addGestureRecognizer:tap];
        }
    }
    
    // meant to be used as a stack. Only need to contain strings. No need to access friends as the hitwindows already have a friend element
    selectedHits = [[NSMutableArray alloc] init];
    
    
    //change this to something else later
    //[self setDefaultImage:[UIImage imageNamed:@"vlad.png"]];
    
    //**[[FBSingleton sharedInstance] setDelegate:self];
    //**[[FBSingleton sharedInstance] RequestHitWhoList];
    
    table.delegate = self;
    table.dataSource = self;
    
    spinner = [SpinnerView loadSpinnerIntoView:loadingView];
    tablepull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.table];
    
    [self.table addSubview:tablepull];
    
    isHammerDown = NO;
}

// viewdidload gets called before this
-(void)viewWillAppear:(BOOL)animated {
    
    CGRect frame = table.frame;
    frame.size = CGSizeMake(140, 228);
    table.frame = frame;
    self.navigationController.navigationBarHidden = YES;
    
    [faceView setContentMode:UIViewContentModeScaleToFill];
    [bodyView setContentMode:UIViewContentModeScaleToFill];
    [helmetView setContentMode:UIViewContentModeScaleToFill];
    [hammerView setContentMode:UIViewContentModeScaleToFill];
    hammerView.transform = CGAffineTransformMakeRotation(45*pi/180);
    [shieldView setContentMode:UIViewContentModeScaleToFill];
    
    faceView.image = nil;
    bodyView.image = nil;
    helmetView.image = nil;
    hammerView.image = nil;
    shieldView.image = nil;
}

-(void) viewDidAppear:(BOOL)animated{
    
    [[FBSingletonNew sharedInstance] setDelegate:self];
    [tablepull setDelegate:self];
    
    if (isHammerDown) {
        [self sendHammersUpWithBlock:^(BOOL finished) {
            isHammerDown = NO;
        }];
    }
    [self loadPlayersList];
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

-(void)loadPlayersList{
    if ([[UserInfo sharedInstance] friendArray] == nil){
        [[FBSingletonNew sharedInstance] requestFriendsUsing];
    }else{
        //call database to reload strangers list:
        [self getFriendDBInfo:[[UserInfo sharedInstance] friendArray]];
    }
}

-(void)loadPlayerListCompleted:(FriendArray *)friendArray{
    [self getFriendDBInfo:friendArray];
}

//-(void) FBSingletonHitWhoIDListLoaded:(NSArray *)friendUsingAppID{
//    NSLog(@"%@",friendUsingAppID);
//    
//    //comment might be userful when cache the friendsArray [straighters remain the same unless pull to refresh]
//    
//    //if ([[[UserInfo sharedInstance] friendArray] friends] == nil){
//        [self getFriendDBInfo:friendUsingAppID];
//    //}
//    //else{
//    //    resultFriends = [NSArray arrayWithArray:[[[UserInfo sharedInstance] friendArray] friends]];
//    //}
//}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!
#pragma mark - UITableView Datasource and Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultFriends count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"hitFriendCell";
    
    hitFriendCell *cell = (hitFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"hitFriendCell" owner:nil options:nil];
        cell = (hitFriendCell *)[nib objectAtIndex:0];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:HitWhoFriendListCell]];
        [cell.backgroundView setClipsToBounds:YES];
        [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
        cell.spinner = [[SpinnerView alloc] initWithFrame:cell.containerView.bounds];
    }
        
    Friend *friend = [resultFriends objectAtIndex:indexPath.row];
    cell.identity = friend.user_id;
    cell.name.text = (NSString *)friend.name;
    cell.name.lineBreakMode  = UILineBreakModeWordWrap;
    cell.gender.text = friend.gender;
    NSString *formatting = [NSString stringWithFormat:@"http://www.whackwho.com/userImages/%@.png", friend.head_id];
    
    [cell.profileImage setImageWithURL:[NSURL URLWithString:formatting] success:^(UIImage *image) {
        [cell.spinner removeSpinner];
        friend.head.headImage = image;
    }failure:^(NSError *error) {
        [cell.spinner removeSpinner];
    }];

    [cell.profileImage setClipsToBounds:YES];
    [cell.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    hitFriendCell *celler = (hitFriendCell *)cell;
    if (celler.profileImage.image == nil)
        [celler.spinner startSpinnerInView:celler.containerView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only handle taps if the view is related to showing nearby places that
    // the user can check-in to.
    if (![resultFriends count] || [selectedHits count] >= 4) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
        
    //Find which friend the user has selected
    Friend *friend = [resultFriends objectAtIndex:indexPath.row];
    
    if (![selectedHits containsObject:friend]) {
        [selectedHits addObject:friend];
    }
    friendSelected = friend;
    
    [self switchMainViewToIndex];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self updateHitWindow];
}

/*********handle database connections:*****************/
-(void)getFriendDBInfo:(FriendArray *) friendArray{
    if (friendArray.friends.count){
        //[[RKObjectManager sharedManager] postObject:friendArray delegate:self];
        [[RKObjectManager sharedManager] putObject:friendArray usingBlock:^(RKObjectLoader *loader){
            loader.delegate = self;
            loader.targetObject = nil;
        }];
    }
}


-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    NSLog(@"Load Database Failed:%@",error);
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    NSLog(@"loaded responses:%@",object);
    FriendArray *friendArray = object;
    [friendArray copyToUserInfo];

    self.resultFriends = [NSArray arrayWithArray:[[[UserInfo sharedInstance] friendArray] friends]];
    self.resultStrangers = [NSMutableArray arrayWithArray:[[[UserInfo sharedInstance] friendArray] strangers]];
    
    for (int i = 0; i < resultStrangers.count; i++) {
        Friend *tempFriend = [resultStrangers objectAtIndex:i];
        if ([tempFriend.whackwho_id isEqualToString:[NSString stringWithFormat:@"%i", [[UserInfo sharedInstance] whackWhoId]]]) {
            [resultStrangers removeObject:tempFriend];
            break;
        }
    }
    
    [self.table reloadData];
    [spinner removeSpinner];
    [tablepull finishedLoading];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"request body:%@",[request HTTPBodyString]);
    NSLog(@"request url:%@",[request URL]);
    NSLog(@"response statue: %d", [response statusCode]);
    NSLog(@"response body:%@",[response bodyAsString]);
}

//////pull the table///////////

-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view{
    //**[[FBSingleton sharedInstance] setSavedFriendsUsingApp:nil];
    //might be userful:
    //[[[UserInfo sharedInstance] friendArray] setFriends:nil];
    //**[[FBSingleton sharedInstance] RequestHitWhoList];
    [[FBSingletonNew sharedInstance] requestFriendsUsing];
}

#pragma mark - Touch methods

//set the portrait view to the image of the user's current status
-(void) handleTapOnImage:(id)sender {
    //NSLog(@"touched!!");
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    HitWindow *temp = ((HitWindow *)(tap.view));
    friendSelected = temp.friend;
    
    if (temp.image == nil)
        return;
    
    [self switchMainViewToIndex];
}

-(IBAction)cancelTouched:(id)sender {
    if (friendSelected == nil)
        return;
    
    [selectedHits removeObject:friendSelected];
    
    if (selectedHits.count > 0)
        friendSelected = [selectedHits lastObject];
    else
        friendSelected = nil;
    
    [self updateHitWindow];
    [self switchMainViewToIndex];
}

-(IBAction)battleTouched:(id)sender {
    int max_popups = 2 * [selectedHits count] + 1;
    //max_popups = 2;
    void (^block)(BOOL) = ^(BOOL finished) {
        if (finished) {
            NSMutableArray *finalImages = [[NSMutableArray alloc] initWithCapacity:max_popups];
            
            for (int i = 0; i < max_popups; ++i) {
                if (selectedHits.count > i) {
                    [finalImages addObject:[self captureImageInHitBox:i withArray:0]];
                } else {
                    //[finalImages addObject:defaultImage];
                    //going to decide in captureimagefunction stranger selection criteria
                    [finalImages addObject:[self captureImageInHitBox:0 withArray:1]];
                }
            }
            
            [[Game sharedGame] setSelectHeadCount:selectedHits.count];
            [[Game sharedGame] setArrayOfAllPopups:finalImages];
            
            [self performSegueWithIdentifier:ChooseToGame sender:sender];
            isHammerDown = YES;
        }
    };
    
    [self sendHammersDownWithBlock:block];
    
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - capture image

//you do not capture the different equipments. etc
- (UIImage *)captureImageInHitBox:(NSInteger)number withArray: (NSInteger)array {
    //capturing image from friends
    //!!!!!!YOU ARE NOT CAPTURING INFO ABOUT THEIR EQUIPMENTS
    Friend *friend;
    if (array == 0) {
        friend = [selectedHits objectAtIndex:number];
        faceView.image = friend.head.headImage;
        
        CurrentEquip *ce = friend.currentEquip;
        faceView.image = friend.head.headImage;
        helmetView.image = [UIImage imageNamed:ce.helmet];
        bodyView.image = [UIImage imageNamed:ce.body];
        hammerView.image = [UIImage imageNamed:ce.hammerArm];
        shieldView.image = [UIImage imageNamed:ce.shieldArm];
        
    } else {//capturing image from strangers
        int randInt;
        while (TRUE) {
            randInt = arc4random() % resultStrangers.count;
            friend = [resultStrangers objectAtIndex:randInt];
            
            NSString *selfGender = [[UserInfo sharedInstance] gender];
            
            if (arc4random() % 100 < 70) {
                if (![friend.gender isEqualToString:selfGender]) {
                    break;
                }
            } else {
                if ([friend.gender isEqualToString:selfGender]) {
                    break;
                }
            }
        }
        
        if (!friend.head.headImage) {
            friend.head.headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.whackwho.com/userImages/%@.png", friend.head_id]]]];
        }
        faceView.image = friend.head.headImage;
        CurrentEquip *ce = friend.currentEquip;
        faceView.image = friend.head.headImage;
        helmetView.image = [UIImage imageNamed:ce.helmet];
        bodyView.image = [UIImage imageNamed:ce.body];
        hammerView.image = [UIImage imageNamed:ce.hammerArm];
        shieldView.image = [UIImage imageNamed:ce.shieldArm];
    }
    
    // If scale is 0, it'll follows the screen scale for creating the bounds
    UIGraphicsBeginImageContextWithOptions(self.containerView.bounds.size, NO, 1.0f);
    
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get the image out of the context
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the result
    return copied;
}

- (void) updateHitWindow {
    for (int i = 0; i < selectedHits.count; ++i) {
        Friend *friend = [selectedHits objectAtIndex:i];
        HitWindow *hit = [hitWindows objectAtIndex:i];
        if (friend.head.headImage != hit.image) {
            hit.image = friend.head.headImage;
            hit.friend = friend;
        }
    }
    
    for (int i = selectedHits.count; i < 4; ++i) {
        HitWindow *hit = [hitWindows objectAtIndex:i];
        hit.image = nil;
        hit.friend = nil;
    }
}

-(void) switchMainViewToIndex {
    if (selectedHits.count <= 0) {
        faceView.image = nil;
        helmetView.image = nil;
        bodyView.image = nil;
        hammerView.image = nil;
        shieldView.image = nil;
        return;
    }
    
    NSInteger index = [selectedHits indexOfObject:friendSelected];
    switch (index) {
        case 0:
            hitNumber.image = [UIImage imageNamed:hitNumberOne];
            break;
        case 1:
            hitNumber.image = [UIImage imageNamed:hitNumberTwo];
            break;
        case 2:
            hitNumber.image = [UIImage imageNamed:hitNumberThree];
            break;
        case 3:
            hitNumber.image = [UIImage imageNamed:hitNumberFour];
            break;
    }
    
    CurrentEquip *ce = friendSelected.currentEquip;
    faceView.image = friendSelected.head.headImage;
    helmetView.image = [UIImage imageNamed:ce.helmet];
    bodyView.image = [UIImage imageNamed:ce.body];
    hammerView.image = [UIImage imageNamed:ce.hammerArm];
    shieldView.image = [UIImage imageNamed:ce.shieldArm];
}

-(void) sendHammersDownWithBlock:(void(^)(BOOL finished))block {
    if (isHammerDown)
        return;
    
    [self.view bringSubviewToFront:leftHammer];
    [self.view bringSubviewToFront:rightHammer];
    
    CGPoint origPt_l = leftHammer.center;
    CGPoint origPt_r = rightHammer.center;
    
    [UIView animateWithDuration:1.1f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         leftHammer.center = CGPointMake(origPt_l.x, origPt_l.y + 100);
                         rightHammer.center = CGPointMake(origPt_r.x, origPt_r.y + 100);
                     }
                     completion:block];
}

-(void) sendHammersUpWithBlock:(void(^)(BOOL finished))block {
    if (!isHammerDown)
        return;
    
    [self.view bringSubviewToFront:leftHammer];
    [self.view bringSubviewToFront:rightHammer];
    
    CGPoint origPt_l = leftHammer.center;
    CGPoint origPt_r = rightHammer.center;
    
    [UIView animateWithDuration:1.1f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         leftHammer.center = CGPointMake(origPt_l.x, origPt_l.y - 100);
                         rightHammer.center = CGPointMake(origPt_r.x, origPt_r.y - 100);
                     }
                     completion:block];
}

@end
