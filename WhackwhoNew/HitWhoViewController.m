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
#define MAX_HIT 2

@implementation HitWhoViewController

@synthesize hit1, hit2, hit3;
@synthesize defaultImage;
//@synthesize noHit1, noHit2, noHit3, noHit4;
@synthesize containerView;
@synthesize table;
@synthesize spinner, loadingView;
@synthesize resultFriends;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    
    selectedHits = [[NSMutableArray alloc] initWithObjects:hit1, hit2, hit3, nil];
    selectedHitsNames = [[NSMutableArray alloc] init];
    //noHits = [[NSMutableArray alloc] initWithObjects:noHit1, noHit2, noHit3, noHit4, nil];
    //noHitsNames = [[NSMutableArray alloc] init];
    arrayOfFinalImages = [[NSMutableArray alloc] init];
    [self setDefaultImage:[UIImage imageNamed:@"vlad.png"]];
    
    [[FBSingleton sharedInstance] RequestFriendUsing];
    
    table.delegate = self;
    table.dataSource = self;
    
    spinner = [SpinnerView loadSpinnerIntoView:loadingView];
    tablepull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.table];
    [self.table addSubview:tablepull];
        
}

// viewdidload gets called before this
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
    //UIImage *face_DB = [[UserInfo sharedInstance] croppedImage];
    
    //we will initialize all body part sprite here, then change the texture
    //!!! need to retrive from database the current equipment!
    
    //init face with image from DB, if none exists, give it blank (use pause.png for now)
    faceView = [[UIImageView alloc] initWithFrame:CGRectMake(48, 90, 75, 35)];
    [faceView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:faceView];
    //[faceView setImage:face_DB];
    
    //init body
    bodyView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 145, 88, 63)];
    [bodyView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:bodyView];
    //[bodyView setImage:[UIImage imageNamed:standard_blue_body]];
    
    //init helmet
    helmetView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 33, 120, 135)];
    [helmetView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:helmetView];
    //[helmetView setImage:[UIImage imageNamed:standard_blue_head]];
    
    //init hammerHand
    hammerView = [[UIImageView alloc] initWithFrame:CGRectMake(118, 132, 32, 39)];
    [hammerView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:hammerView];
    //[hammerView setImage:[UIImage imageNamed:starting_hammer]];
    
    //init shieldHand
    shieldView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 145, 40, 40)];
    [shieldView setContentMode:UIViewContentModeScaleAspectFill];
    [self.containerView addSubview:shieldView];
    //[shieldView setImage:[UIImage imageNamed:starting_shield]];

    
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

-(void) FBUserFriendsAppUsingLoaded:(NSArray *)friendsUsingApp{
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
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:FriendListBWCell]];
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
                
                //selectedHitsNames contain an array of whackWhoID
                //obtain from database the names(string) of the current equipment images
                //update the uiimageview accordingly
                //call print screen function
                //save to array
                
                    //this is what should happen!!!
                    //Items *guy = [Items alloc];
                    //guy.headID = friend.head_id;
                    //guy.helmet = standard_blue_head;
                
                //this is what is happening!!
                faceView.image = tempImage;
                helmetView.image = [UIImage imageNamed:standard_blue_head];
                bodyView.image = [UIImage imageNamed:standard_blue_body];
                hammerView.image = [UIImage imageNamed:starting_hammer];
                shieldView.image = [UIImage imageNamed:starting_shield];
                UIImage *guy = [self captureImageOnSelect];
                
                if (![arrayOfFinalImages containsObject:defaultImage]) {
                    [arrayOfFinalImages addObject:guy];
                } else {
                    [arrayOfFinalImages replaceObjectAtIndex:[arrayOfFinalImages indexOfObject:defaultImage] withObject:guy];
                }
               //[arrayOfFinalImages addObject:guy];
                
                //add tap gesture (to view the glview)
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnImage:)];
                tap.numberOfTapsRequired = 1;
                [temp addGestureRecognizer:tap];
                    
                //add swipe to cancel gesture (little cancel mark)
                //UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(handleSwipeOnImage:)];
                //swipe.numberOfTouchesRequired = 1;
                //[temp addGestureRecognizer:swipe];
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
        [[RKObjectManager sharedManager] postObject:friendArray usingBlock:^(RKObjectLoader *loader){
            loader.delegate = self;
            loader.resourcePath = @"/getFriendUsingApp";
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
    self.resultFriends = friendArray.friends;
    [self.table reloadData];
    [spinner removeSpinner];
    [tablepull finishedLoading];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"request body:%@",[request HTTPBodyString]);
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
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIImage *tempImage = ((UIImageView *)(tap.view)).image;
    
    //obtain from database the names(string) of the current equipment images
    //update the uiimageview accordingly
    //call print screen function
    //save to aray
    
    //this is what should happen!!!
    //Items *guy = [Items alloc];
    //guy.headID = friend.head_id;
    //guy.helmet = standard_blue_head;
    
    //this is what is happening!!
    faceView.image = tempImage;
    helmetView.image = [UIImage imageNamed:standard_blue_head];
    bodyView.image = [UIImage imageNamed:standard_blue_body];
    hammerView.image = [UIImage imageNamed:starting_hammer];
    shieldView.image = [UIImage imageNamed:starting_shield];
}

-(IBAction)cancelTouched:(id)sender {
    
    int whichOne = [sender tag];
    UIImageView *tempView = [selectedHits objectAtIndex:whichOne];
    
    //set image of all subviews to nil in the containerView
    for (UIImageView *view in self.containerView.subviews) {
        [view setImage:nil];
    }
    
    //now need to remove that uiimage from the arrayOfImages
    [arrayOfFinalImages replaceObjectAtIndex:whichOne withObject:defaultImage];//[UIImage imageNamed:@"vlad.png"]];
    
    //set mini-portrait to nil
    tempView.image = nil;
    
    [selectedHitsNames replaceObjectAtIndex:whichOne withObject:dummyString];
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

-(IBAction) nextTouched:(id)sender {
    //if did not select all hits or did not press random
    if ([selectedHitsNames containsObject:dummyString] || [selectedHitsNames count] < MAX_HIT) {
        //display alert showing must select all b4 game
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"You can still pick more friends to hit!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        return;
    } else {
        //first count number of friends. Then count number of selected hits
        //if total friends < 2 * selected + 1, then need to fill with void faces...
        //if need to fil with void,
        //  create array of items (contains curr. equip. info of selected hits)
        //  + fill in the remaining with blank heads
        //else
        //  create array of items (contains curr.equip. info of selected + randomed friends)
        
        //!!! if not enough friends, need to use void head (i.e. heads without faces)
        
        int totalFriends = [resultFriends count];
        int selectedHitsCount = [selectedHitsNames count];
        
        if (totalFriends < (2*selectedHitsCount+1)) {
            for (int i = 0; i < selectedHitsCount + 1; i++) {
                [arrayOfFinalImages addObject:defaultImage];
            }
        }
        
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

@end
