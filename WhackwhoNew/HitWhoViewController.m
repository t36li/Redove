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

#define ChooseToGame @"chooseToGame"
#define dummyString @"testobject"
#define MAX_HIT 2

@implementation HitWhoViewController

@synthesize selectedHits;
@synthesize hit1, hit2, hit3;
//@synthesize noHit1, noHit2, noHit3, noHit4;
@synthesize portrait;
@synthesize table;
@synthesize spinner, loadingView;
@synthesize resultFriends;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    selectedHits = [[NSMutableArray alloc] initWithObjects:hit1, hit2, hit3, nil];
    selectedHitsNames = [[NSMutableArray alloc] init];
    //noHits = [[NSMutableArray alloc] initWithObjects:noHit1, noHit2, noHit3, noHit4, nil];
    //noHitsNames = [[NSMutableArray alloc] init];
    arrayOfItems = [[NSMutableArray alloc] init];
    
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
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if ([director isPaused]) {
        [director resume];
    }
    
    CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, 120, 170)
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
        
        [director runWithScene:[ChooseWhoLayer scene]]; // RUN THE SCENE
        
    } else {
        // THERE IS A SCENE, START SINCE IT WAS STOPPED AND REPLACE TO RESTART
        [director startAnimation];
        [director.view setFrame:CGRectMake(0, 0, 120, 170)];
        [director replaceScene:[ChooseWhoLayer scene]];
    }
    
    [director willMoveToParentViewController:nil];
    [director.view removeFromSuperview];
    [director removeFromParentViewController];
    [director willMoveToParentViewController:self];
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    [self.portrait addSubview: director.view];
    [self.portrait sendSubviewToBack:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
}
 
- (void) viewDidDisappear:(BOOL)animated {
    CCDirector *director = [CCDirector sharedDirector];
    [director removeFromParentViewController];
    [director.view removeFromSuperview];
    [director didMoveToParentViewController:nil];
 
    [director end];
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
        
        if ([selectedHitsNames count] < 1) {
            [selectedHitsNames addObject:friend.whackwho_id];
        } else {
            [selectedHitsNames replaceObjectAtIndex:[selectedHitsNames indexOfObject:dummyString] withObject:friend.whackwho_id];
        }
        
        //selectedHits -> an array of UIImageView
        for (UIImageView *temp in selectedHits) {
            if (temp.image == nil) {
                temp.image = tempImage;
                
                //selectedHitsNames contain an array of whackWhoID that has been selected
                //at completion, GET the other equipment from database, create an array of
                //Items. Then at cocos2d scene, just piece-wise the images together
                
                //!!! this is for displaying other player's status
                //call the cocos2d layer to update character
                //CCScene *scene = [[CCDirector sharedDirector] runningScene];
                //id layer = [[scene children] objectAtIndex:0];
                //[layer updatePortraitWitHHead:friend.head_id body:@"peter body.png" helmet:@"standard blue.png" hammer:@"hammer.png" shield:@"coin front.png"];
                
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
    //UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    //UIImage *tempImage = ((UIImageView *)(tap.view)).image;
    
    //portrait.image = tempImage;
    //[portrait setContentMode:UIViewContentModeScaleAspectFill];
}

-(IBAction)cancelTouched:(id)sender {
    
    int whichOne = [sender tag];
    UIImageView *tempView = [selectedHits objectAtIndex:whichOne];
    
    //if (portrait.image == tempView.image) {
    //    portrait.image = nil;
    //}
    
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
            //testing purpose, use headID 23/24
            int testHeadID = 23;
            for (int i = 0; i<2*selectedHitsCount+1; i++) {
                Items *person = [[Items alloc] init];
                if (i >= selectedHitsCount) {
                    //!!! fill with void faces
                    person.headID = nil;
                    person.helmet = standard_blue_head;
                    person.body = standard_blue_body;
                    person.hammerArm = starting_hammer;
                    person.shieldArm = starting_shield;
                } else {
                    //!!! use the whackwhoID here to obtain the headID, body, etc...
                    //for testing, assume default...
                    //whackwhoID = [selectedHitsNames objectAtIndex: i];
                    person.headID = [NSString stringWithFormat:@"%d", testHeadID];
                    person.helmet = standard_blue_head; //whatever returned from DB
                    person.body = standard_blue_body;
                    person.hammerArm = starting_hammer;
                    person.shieldArm = starting_shield;
                    testHeadID ++;
                }
                [arrayOfItems addObject:person];
            }
        } else {
            //this should not be executed now
            for (NSString *whackWhoID in selectedHitsNames) {
                //!!! use the whackwhoID here to obtain the headID, body, etc...
                //for testing, assume default...
                //whackwhoID = [selectedHitsNames objectAtIndex: i];
                Items *person = [[Items alloc] init];
                person.headID = nil;
                person.helmet = standard_blue_head; //whatever returned from DB
                person.body = standard_blue_body;
                person.hammerArm = starting_hammer;
                person.shieldArm = starting_shield;
                [arrayOfItems addObject:person];
            }
            for (int i = 0; i < selectedHitsCount + 1; i++) {
                while (TRUE) {
                    int randomFactor = arc4random() % ([resultFriends count] - selectedHitsCount);
                    Friend *temp = [resultFriends objectAtIndex:randomFactor];
                    if (![selectedHitsNames containsObject:temp.whackwho_id]) {
                        break;
                    }
                }
                //!!! use the whackwhoID here to obtain the headID, body, etc...
                //for testing, assume default...
                //whackwhoID = [selectedHitsNames objectAtIndex: i];
                Items *person = [[Items alloc] init];
                person.headID = nil;
                person.helmet = standard_blue_head; //whatever returned from DB
                person.body = standard_blue_body;
                person.hammerArm = starting_hammer;
                person.shieldArm = starting_shield;
                [arrayOfItems addObject:person];
            }
        }
        
        [[Game sharedGame] setArrayOfAllPopups:arrayOfItems];

        [self performSegueWithIdentifier:ChooseToGame sender:sender];
    }
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void) scrollview method... {
    // .... need to pass Helloworldlayer the bigfriendlist and selectedheadslist
    //bigfriendslist = all 7 possible popups
//}

- (UIImage *)toImageWithScale:(CGFloat)scale {
    // If scale is 0, it'll follows the screen scale for creating the bounds
    UIGraphicsBeginImageContextWithOptions(self.portrait.bounds.size, NO, scale);
    
    // - [CALayer renderInContext:] also renders subviews
    [self.portrait.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get the image out of the context
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the result
    return copied;
}

@end
