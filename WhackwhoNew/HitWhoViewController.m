//
//  ModeSelectionViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HitWhoViewController.h"
#import "FBSingleton.h"
#import "Friend.h"
#import "UserInfo.h"

#define ChooseToGame @"chooseToGame"
#define dummyString @"testobject"
//#define MAX_HIT 2

@implementation HitWhoViewController

@synthesize hit1, hit2, hit3, hit4;
@synthesize defaultImage;

@synthesize containerView;
@synthesize faceView, helmetView, bodyView, hammerView, shieldView;
@synthesize hitNumber, leftHammer, rightHammer;

@synthesize table;
@synthesize spinner, loadingView;
@synthesize resultFriends, hitWindows;

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
    [self setDefaultImage:[UIImage imageNamed:@"vlad.png"]];
    
    [[FBSingleton sharedInstance] setDelegate:self];
    [[FBSingleton sharedInstance] RequestFriendUsing];
    
    table.delegate = self;
    table.dataSource = self;
    
    spinner = [SpinnerView loadSpinnerIntoView:loadingView];
    tablepull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.table];
    
    [self.table addSubview:tablepull];
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
    [shieldView setContentMode:UIViewContentModeScaleToFill];
}

-(void) viewDidAppear:(BOOL)animated{
    [[FBSingleton sharedInstance] setDelegate:self];
    [tablepull setDelegate:self];
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

-(void) FBSingletonUserFriendsAppUsingLoaded:(NSArray *)friendsUsingApp{
    NSLog(@"%@",friendsUsingApp);
    [self getFriendDBInfo:friendsUsingApp];
}

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
    if ((![resultFriends count] || [selectedHits count] >= 4) && ![selectedHits containsObject:dummyString]) {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:nil message:@"Already selected maximum number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [error show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
        
    //Find which friend the user has selected
    Friend *friend = [resultFriends objectAtIndex:indexPath.row];
    friendSelected = friend;
    
    for (NSString *temp in selectedHits) {
        NSLog(@"%@", temp);
    }
    
    if (![selectedHits containsObject:friend.whackwho_id]) {
        if ([selectedHits containsObject:dummyString]) {
            [selectedHits replaceObjectAtIndex:[selectedHits indexOfObject:dummyString] withObject:friend.whackwho_id];
        } else {
            [selectedHits addObject:friend.whackwho_id];
        }
        
        //temporarily set to the image of the cell
        hitFriendCell *cell = (hitFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
        faceView.image = cell.profileImage.image;
        
        [self updateHitWindow];
    }
    //CurrentEquip *ce = friendSelected.currentEquip;
    //helmetView.image = [UIImage imageNamed:ce.helmet];
    //bodyView.image = [UIImage imageNamed:ce.body];
    //hammerView.image = [UIImage imageNamed:ce.hammerArm];
    //shieldView.image = [UIImage imageNamed:ce.shieldArm];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*********handle database connections:*****************/
-(void)getFriendDBInfo:(NSArray *) friendUsingAppIDs{
    if (friendUsingAppIDs){
        
        NSMutableArray *friends = [[NSMutableArray alloc] init];
        for (NSString* fID in friendUsingAppIDs) {
            Friend* f = [[Friend alloc] init];
            f.user_id = fID;
            [friends addObject:f];
        }
        FriendArray *friendArray = [[FriendArray alloc] init];
        friendArray.friends = friends;
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
    
    //NSLog(@"%@",[[resultFriends objectAtIndex:0] currentEquip].hammerArm);
    
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
    [[FBSingleton sharedInstance] RequestFriendUsing];
    
}

#pragma mark - Touch methods

//set the portrait view to the image of the user's current status
-(void) handleTapOnImage:(id)sender {
    //NSLog(@"touched!!");
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    HitWindow *temp = ((HitWindow *)(tap.view));
    
    if (temp.image == nil)
        return;
    
    friendSelected = temp.friend;
    faceView.image = temp.image;
    
    [self switchMainViewToIndex:temp.tag];
}

-(IBAction)cancelTouched:(id)sender {
    if (friendSelected == nil) {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:nil message:@"Cannot cancel without selecting anything" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [error show];
        return;
    }
    
    [selectedHits replaceObjectAtIndex:[selectedHits indexOfObject:friendSelected.whackwho_id] withObject:dummyString];
    //[self updateHitWindow];
    //[self switchMainViewToIndex:MAX(selectedHits.count-1, 0)];
    for (HitWindow *temp in hitWindows) {
        if (!temp.friend) {
            continue;
        }
        if ([temp.friend.whackwho_id isEqualToString:friendSelected.whackwho_id]) {
            temp.friend = nil;
            temp.image = nil;
            hitNumber.image = nil;
            break;
        }
    }
    
    for (UIImageView *temp in [self.containerView subviews]) {
        temp.image = nil;
    }
}

-(IBAction)battleTouched:(id)sender {
    if (![selectedHits count] || [selectedHits containsObject:dummyString]) {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:nil message:@"Please finish selecting first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [error show];
        return;
    }
    
    int max_popups = 2 * [selectedHits count] + 1;
    
    void (^block)(BOOL) = ^(BOOL finished) {
        if (finished) {
            NSMutableArray *finalImages = [[NSMutableArray alloc] initWithCapacity:max_popups];
            
            for (int i = 0; i < max_popups; ++i) {
                if (selectedHits.count > i) {
                    [finalImages addObject:[self captureImageInHitBox:i]];
                } else {
                    [finalImages addObject:defaultImage];
                }
            }
            
            [[Game sharedGame] setSelectHeadCount:selectedHits.count];
            [[Game sharedGame] setArrayOfAllPopups:finalImages];
            
            [self performSegueWithIdentifier:ChooseToGame sender:sender];
        }
    };
    
    [self sendHammersDownWithBlock:block];
    
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - capture image

//you do not capture the different equipments. etc
- (UIImage *)captureImageInHitBox:(NSInteger)number {
    HitWindow *temp = (HitWindow *)[hitWindows objectAtIndex:number];
    Friend *friend = temp.friend;
    CurrentEquip *ce = friend.currentEquip;
    //faceView.image = friend.head.headImage;
    faceView.image = temp.image;
    helmetView.image = [UIImage imageNamed:ce.helmet];
    bodyView.image = [UIImage imageNamed:ce.body];
    hammerView.image = [UIImage imageNamed:ce.hammerArm];
    shieldView.image = [UIImage imageNamed:ce.shieldArm];
    
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
    for (HitWindow *temp in hitWindows) {
        if (!temp.image) {
            temp.image = faceView.image;
            temp.friend = friendSelected;
            [self switchMainViewToIndex:temp.tag];
            break;
        }
    }
    
    //for (int i = 0; i < selectedHits.count; ++i) {
    //    Friend *friend = [selectedHits objectAtIndex:i];
    //    HitWindow *hit = [hitWindows objectAtIndex:i];
    //    if (friend.head.headImage != hit.image) {
    //        hit.image = friend.head.headImage;
    //        hit.friend = friend;
    //    }
    //}
}

-(void) switchMainViewToIndex:(NSInteger)index {
    //HitWindow *tempWindow;
    switch (index) {
        case 0:
            //tempWindow = hit1;
            hitNumber.image = [UIImage imageNamed:hitNumberOne];
            break;
        case 1:
            //tempWindow = hit2;
            hitNumber.image = [UIImage imageNamed:hitNumberTwo];
            break;
        case 2:
            //tempWindow = hit3;
            hitNumber.image = [UIImage imageNamed:hitNumberThree];
            break;
        case 3:
            //tempWindow = hit4;
            hitNumber.image = [UIImage imageNamed:hitNumberFour];
            break;
    }
    
   // faceView.image = tempWindow.friend.head.headImage;
    CurrentEquip *ce = friendSelected.currentEquip;
    helmetView.image = [UIImage imageNamed:ce.helmet];
    bodyView.image = [UIImage imageNamed:ce.body];
    hammerView.image = [UIImage imageNamed:ce.hammerArm];
    shieldView.image = [UIImage imageNamed:ce.shieldArm];
}

-(void) sendHammersDownWithBlock:(void(^)(BOOL finished))block {
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
