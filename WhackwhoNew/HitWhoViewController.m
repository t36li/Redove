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
@synthesize resultFriends;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    
    shieldNumber = 0;
    
    selectedHits = [[NSMutableArray alloc] initWithObjects:hit1, hit2, hit3, hit4, nil];
    selectedHitsNames = [[NSMutableArray alloc] init];
    
    //!!!decommissioned!
    //noHits = [[NSMutableArray alloc] initWithObjects:noHit1, noHit2, noHit3, noHit4, nil];
    //noHitsNames = [[NSMutableArray alloc] init];
    
    arrayOfFinalImages = [[NSMutableArray alloc] init];
    //change this to something else later
    [self setDefaultImage:[UIImage imageNamed:@"vlad.png"]];
    
    [[FBSingleton sharedInstance] setDelegate:self];
    [[FBSingleton sharedInstance] RequestFriendUsing];
    //resultFriends = [[[UserInfo sharedInstance] friendArray] friends];
    
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
    
    //Lock the amount of ppl they can hit. Put locked or something
    //MAX HIT = 3
    
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
    if (! [resultFriends count])
        return;
    
    hitFriendCell *cell = (hitFriendCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    UIImage *tempImage = cell.profileImage.image;
    NSString *usrId = cell.identity;
    
    //Find which friend the user has selected
    for (Friend *frd in resultFriends) {
        if (frd.user_id == usrId) {
            friendSelected = frd;
            break;
        }
    }
    
    if ([selectedHitsNames containsObject:friendSelected.whackwho_id]) {
        //display alert showing already selected
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"You're already hitting this guy! You can't overkill..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    //determines which hitwindow to use
    int whereCancelled;
    if ([selectedHitsNames containsObject:dummyString]) {
        whereCancelled = [selectedHitsNames indexOfObject:dummyString];
    } else {
        whereCancelled = [selectedHitsNames count];
    }
    
    HitWindow *temp = [selectedHits objectAtIndex:whereCancelled];
    
    if (leftHammer.center.y > 100) {
        [self sendHammersUp];
    }
    
    //add tap gesture (to view the glview)
    if (![temp gestureRecognizers]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnImage:)];
        tap.numberOfTapsRequired = 1;
        [temp addGestureRecognizer:tap];
    }
    
    [self changeShieldNumber:temp.tag];

    temp.image = tempImage;
    [temp setWhackID:friendSelected.whackwho_id];
    
    faceView.image = tempImage;
    helmetView.image = [UIImage imageNamed:standard_blue_head];
    bodyView.image = [UIImage imageNamed:standard_blue_body];
    hammerView.image = [UIImage imageNamed:starting_hammer];
    shieldView.image = [UIImage imageNamed:starting_shield];
    
    //selectedHitsNames -> an array that stores currently selected friends' whackwho_id
    //noHitsNames -> an array that contains names of people not selected
    /*if (!([selectedHitsNames containsObject:friend.whackwho_id])){// || [noHitsNames containsObject:friend.whackwho_id])) {
        
        if (![selectedHitsNames containsObject:dummyString]) {
            [selectedHitsNames addObject:friend.whackwho_id];
        } else {
            [selectedHitsNames replaceObjectAtIndex:[selectedHitsNames indexOfObject:dummyString] withObject:friend.whackwho_id];
        }
        
        //selectedHits -> an array of UIImageView
        for (UIImageView *temp in selectedHits) {
            if (temp.image == nil) {
                temp.image = tempImage;
                
                faceView.image = tempImage;
                helmetView.image = [UIImage imageNamed:standard_blue_head];
                bodyView.image = [UIImage imageNamed:standard_blue_body];
                hammerView.image = [UIImage imageNamed:starting_hammer];
                shieldView.image = [UIImage imageNamed:starting_shield];
                                
                //add tap gesture (to view the glview)
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnImage:)];
                tap.numberOfTapsRequired = 1;
                [temp addGestureRecognizer:tap];

                [self changeShieldNumber:temp.tag];
                
                break;
            }
        }
    }*/
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
    [[UserInfo sharedInstance] setFriendArray:friendArray];
    self.resultFriends = friendArray.friends;
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
    int whichOne = ((UIImageView *)(tap.view)).tag;

    if (temp.image == nil) {
        return;
    }
    
    //if in selectedHitsnames
    if ([selectedHitsNames containsObject:temp.whackID]) {
        if (leftHammer.center.y < 100) {
            [self sendHammersDown];
        }
    } else {
        if (leftHammer.center.y > 100) {
            [self sendHammersUp];
        }
    }
    
    [self changeShieldNumber:whichOne];
    
    //should be updating every gear, not just face
    
    //this is what is happening!!
    faceView.image = temp.image;
    helmetView.image = [UIImage imageNamed:standard_blue_head];
    bodyView.image = [UIImage imageNamed:standard_blue_body];
    hammerView.image = [UIImage imageNamed:starting_hammer];
    shieldView.image = [UIImage imageNamed:starting_shield];
}

-(IBAction)cancelTouched:(id)sender {
    CGPoint origPt_r = rightHammer.center;
    
    //if hammers are down, then this button is valided
    if (origPt_r.y > 100) {
        [self.view bringSubviewToFront:leftHammer];
        [self.view bringSubviewToFront:rightHammer];
        
        [self sendHammersUp];
        
        int whichOne = shieldNumber;
        
        HitWindow *tempView = [selectedHits objectAtIndex:whichOne];
        //set mini-portrait to nil
        tempView.image = nil;
        tempView.whackID = nil;
        
        //set image of all subviews to nil in the containerView
        for (UIImageView *view in self.containerView.subviews) {
            [view setImage:nil];
        }
        
        hitNumber.image = nil;
        
        //now need to remove that uiimage from the arrayOfImages
        [arrayOfFinalImages replaceObjectAtIndex:whichOne withObject:defaultImage];//[UIImage imageNamed:@"vlad.png"]];
        //numDefaultImage++;
        
        [selectedHitsNames replaceObjectAtIndex:whichOne withObject:dummyString];
    } else {
        //display alert showing cant cancel if you didn't ok
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Can't cancel without ok-ing first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}

-(IBAction) okTouched:(id)sender {
    
    CGPoint origPt_r = rightHammer.center;
    
    //if hammers are up, bring them down and do stuff
    if (origPt_r.y < 100) {
        [self.view bringSubviewToFront:leftHammer];
        [self.view bringSubviewToFront:rightHammer];
        
        [self sendHammersDown];
        
        UIImage *guy = [self captureImageOnSelect];
        
        if (![arrayOfFinalImages containsObject:defaultImage]) {
            [arrayOfFinalImages addObject:guy];
        } else {
            [arrayOfFinalImages replaceObjectAtIndex:[arrayOfFinalImages indexOfObject:defaultImage] withObject:guy];
            //numDefaultImage--;
        }
        
        if (![selectedHitsNames containsObject:dummyString]) {
            [selectedHitsNames addObject:friendSelected.whackwho_id];
        } else {
            [selectedHitsNames replaceObjectAtIndex:[selectedHitsNames indexOfObject:dummyString] withObject:friendSelected.whackwho_id];
        }
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"You already pressed ok" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}

-(IBAction)battleTouched:(id)sender {
    //if did not select all hits or did not press random
    if ([selectedHitsNames containsObject:dummyString] || [selectedHitsNames count] < 1) {
        //display alert showing must select all b4 game
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"You can still pick more friends to hit OR press OK!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        return;
    } else {
        //first count number of friends. Then count number of selected hits
        //if total friends < 2 * selected + 1, then need to fill with void faces...
        //else, select random friends from resultFriends
        //
        
        //!!! if not enough friends, need to use void head (i.e. heads without faces)
        // else, random friends from list...
        
        int totalFriends = [resultFriends count];
        int selectedHitsCount = [selectedHitsNames count];
        
        if (totalFriends < (2*selectedHitsCount+1)) {
            for (int i = 0; i < selectedHitsCount + 1; i++) {
                [arrayOfFinalImages addObject:defaultImage];
            }
        } else {
            //if enough friends, random through friends
            
            for (int i = 0; i < selectedHitsCount + 1; i++) {
                //NSLog(@"%i", i);
                while (TRUE) {
                    int rand = arc4random() % totalFriends;
                    //rand = 2;
                    Friend *frd = [resultFriends objectAtIndex:rand];
                    //NSLog(@"%@", frd.whackwho_id);
                    if (![selectedHitsNames containsObject:frd.whackwho_id]) {
                        
                        hitFriendCell *cell = (hitFriendCell *) [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rand inSection:0]];
                        
                        //this is what is happening!!
                        faceView.image = cell.profileImage.image;
                        helmetView.image = [UIImage imageNamed:standard_blue_head];
                        bodyView.image = [UIImage imageNamed:standard_blue_body];
                        hammerView.image = [UIImage imageNamed:starting_hammer];
                        shieldView.image = [UIImage imageNamed:starting_shield];
                        UIImage *guy = [self captureImageOnSelect];
                        
                        [arrayOfFinalImages addObject:guy];
                        [selectedHitsNames addObject:frd.whackwho_id];
                        break;
                    }
                }//end while loop for randomization
            }//end for loop
        }//end "else" clause
        
        [[Game sharedGame] setSelectHeadCount:selectedHitsCount];
        [[Game sharedGame] setArrayOfAllPopups:arrayOfFinalImages];
        
        [self performSegueWithIdentifier:ChooseToGame sender:sender];
    }
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - capture image

- (UIImage *)captureImageOnSelect {
    // If scale is 0, it'll follows the screen scale for creating the bounds
    UIGraphicsBeginImageContextWithOptions(self.containerView.bounds.size, NO, 1.0f);
    
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get the image out of the context
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the result
    return copied;
}

- (void) changeShieldNumber: (int) whichTag {
    switch (whichTag) {
        case 0:
            hitNumber.image = [UIImage imageNamed:hitNumberOne];
            shieldNumber = 0;
            break;
        case 1:
            hitNumber.image = [UIImage imageNamed:hitNumberTwo];
            shieldNumber = 1;
            break;
        case 2:
            hitNumber.image = [UIImage imageNamed:hitNumberThree];
            shieldNumber = 2;
            break;
        case 3:
            hitNumber.image = [UIImage imageNamed:hitNumberFour];
            shieldNumber = 3;
            break;
    }
}

-(void) sendHammersDown {
    CGPoint origPt_l = leftHammer.center;
    CGPoint origPt_r = rightHammer.center;
    
    [UIView animateWithDuration:1.1f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         leftHammer.center = CGPointMake(origPt_l.x, origPt_l.y + 100);
                         rightHammer.center = CGPointMake(origPt_r.x, origPt_r.y + 100);
                     }
                     completion:nil];

}

-(void) sendHammersUp {
    CGPoint origPt_l = leftHammer.center;
    CGPoint origPt_r = rightHammer.center;
    
    [UIView animateWithDuration:1.1f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         leftHammer.center = CGPointMake(origPt_l.x, origPt_l.y - 100);
                         rightHammer.center = CGPointMake(origPt_r.x, origPt_r.y - 100);
                     }
                     completion:nil];
    
}

@end
