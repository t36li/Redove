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
    
    whichNumber = 0;
    numDefaultImage = 0;
    
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
    
    Friend *friend;
    
    //Find which friend the user has selected
    for (Friend *frd in resultFriends) {
        if (frd.user_id == usrId) {
            friend = frd;
            break;
        }
    }
    
    //depending on how many objects are in arrayOfFinalImages,
    //that is the index of the selectedHit that you use
    //however, that has to exclude the num of default images added...
    int numOfValidImages = [arrayOfFinalImages count] - numDefaultImage;
    
    UIImageView *temp = [selectedHits objectAtIndex:numOfValidImages];
    
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
    
    //selectedHitsNames -> an array that stores currently selected friends' whackwho_id
    //noHitsNames -> an array that contains names of people not selected
    if (!([selectedHitsNames containsObject:friend.whackwho_id])){// || [noHitsNames containsObject:friend.whackwho_id])) {
        
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
    }
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
    UIImage *tempImage = ((UIImageView *)(tap.view)).image;
    
    if (tempImage == nil) {
        return;
    }
    
    int whichOne = ((UIImageView *)(tap.view)).tag;
    
    [self changeShieldNumber:whichOne];
    
    //should be updating every gear, not just face
    
    //this is what is happening!!
    faceView.image = tempImage;
    helmetView.image = [UIImage imageNamed:standard_blue_head];
    bodyView.image = [UIImage imageNamed:standard_blue_body];
    hammerView.image = [UIImage imageNamed:starting_hammer];
    shieldView.image = [UIImage imageNamed:starting_shield];
}

-(IBAction)cancelTouched:(id)sender {
    CGPoint origPt_l = leftHammer.center;
    CGPoint origPt_r = rightHammer.center;
    
    //if hammers are down, bring them up AND replace arrays/shit
    if (origPt_r.y > 100) {
        [self.view bringSubviewToFront:leftHammer];
        [self.view bringSubviewToFront:rightHammer];
        
        [UIView animateWithDuration:2.1f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             leftHammer.center = CGPointMake(origPt_l.x, origPt_l.y - 100);
                             rightHammer.center = CGPointMake(origPt_r.x, origPt_r.y - 100);
                         }
                         completion:nil];
        
        
        int whichOne = whichNumber;
        UIImageView *tempView = [selectedHits objectAtIndex:whichOne];
        
        //set image of all subviews to nil in the containerView
        for (UIImageView *view in self.containerView.subviews) {
            [view setImage:nil];
        }
        
        hitNumber.image = nil;
        
        //now need to remove that uiimage from the arrayOfImages
        [arrayOfFinalImages replaceObjectAtIndex:whichOne withObject:defaultImage];//[UIImage imageNamed:@"vlad.png"]];
        numDefaultImage++;
        [selectedHitsNames replaceObjectAtIndex:whichOne withObject:dummyString];
        
        //set mini-portrait to nil
        tempView.image = nil;
    }
}

-(IBAction) okTouched:(id)sender {
    
    CGPoint origPt_l = leftHammer.center;
    CGPoint origPt_r = rightHammer.center;
    
    //if hammers are up, bring them down and do stuff
    if (origPt_r.y < 100) {
        [self.view bringSubviewToFront:leftHammer];
        [self.view bringSubviewToFront:rightHammer];
        
        [UIView animateWithDuration:2.1f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             leftHammer.center = CGPointMake(origPt_l.x, origPt_l.y + 100);
                             rightHammer.center = CGPointMake(origPt_r.x, origPt_r.y + 100);
                         }
                         completion:nil];
        
        UIImage *guy = [self captureImageOnSelect];
        
        if (![arrayOfFinalImages containsObject:defaultImage]) {
            [arrayOfFinalImages addObject:guy];
        } else {
            [arrayOfFinalImages replaceObjectAtIndex:[arrayOfFinalImages indexOfObject:defaultImage] withObject:guy];
            numDefaultImage--;
        }
    }
}

/*- (void) handleSwipeOnImage:(id)sender {
    UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)sender;
    if (portrait.image == ((UIImageView *)(swipe.view)).image) {
        portrait.image = nil;
    }
    
    ((UIImageView *)(swipe.view)).image = nil;
    
    //remove the object from the "taken" array
    int index = ((UIImageView *)(swipe.view)).tag;
    
    [selectedHitsNames removeObjectAtIndex:index];
}*/

/*-(IBAction) handleRandomButton:(id)sender {
    //first remove all previous names from the NameArray
    if (!resultFriends.count)
        return;
    
    [noHitsNames removeAllObjects];

    for (UIImageView *temp in noHits) {
        //if (temp.image == nil) {
        // do not generate if already selected
        while (TRUE) {
            int randFriend = arc4random() % [resultFriends count];
            Friend *friend = [resultFriends objectAtIndex:randFriend];
            if (![noHitsNames containsObject:friend]) {
                [noHitsNames addObject:friend];
                NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", friend.user_id];
                [temp setImageWithURL:[NSURL URLWithString:formatting]];
                break;
                
                temp.userInteractionEnabled = YES;
                
                //add tap gesture (to view the glview)
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnImage:)];
                tap.numberOfTapsRequired = 1;
                [temp addGestureRecognizer:tap];
            }
        }
    }
}*/

-(IBAction)battleTouched:(id)sender {
    //if did not select all hits or did not press random
    if ([selectedHitsNames containsObject:dummyString] || [selectedHitsNames count] < 1) {
        //display alert showing must select all b4 game
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"You can still pick more friends to hit!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
                while (TRUE) {
                    int rand = arc4random() % totalFriends;
                    Friend *frd = [resultFriends objectAtIndex:rand];
                    
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
                        break;
                    }
                }//end while loop for randomization
            }//end for loop
            
            
            [[Game sharedGame] setSelectHeadCount:selectedHitsCount];
            [[Game sharedGame] setArrayOfAllPopups:arrayOfFinalImages];
            
            [self performSegueWithIdentifier:ChooseToGame sender:sender];
        }
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
            whichNumber = 0;
            break;
        case 1:
            hitNumber.image = [UIImage imageNamed:hitNumberTwo];
            whichNumber = 1;
            break;
        case 2:
            hitNumber.image = [UIImage imageNamed:hitNumberThree];
            whichNumber = 2;
            break;
        case 3:
            hitNumber.image = [UIImage imageNamed:hitNumberFour];
            whichNumber = 3;
            break;
    }
}

@end
