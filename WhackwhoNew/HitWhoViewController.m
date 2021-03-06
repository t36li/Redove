//
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HitWhoViewController.h"
#import "Friend.h"
#import "UserInfo.h"
#import "FBSingletonNew.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "WEPopoverContentViewController.h"
#import "WEPopoverController.h"
#import "InBetweenViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ChooseToGame @"chooseToGame"
//#define dummyString @"testobject"
#define pi 3.14159265359
//#define MAX_HIT 2

@implementation HitWhoViewController

@synthesize namelabel;
@synthesize hit1, hit2, hit3, hit4;

@synthesize containerView;
@synthesize faceView, bodyView;
@synthesize hitNumber, leftHammer, rightHammer;

@synthesize table;
@synthesize spinner, loadingView;
@synthesize resultFriends, resultStrangers, hitWindows;
@synthesize popoverController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self.containerView setBackgroundColor:[UIColor clearColor]];
    
    [faceView setContentMode:UIViewContentModeScaleAspectFit];
    [bodyView setContentMode:UIViewContentModeScaleToFill];
    
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
    selectedStrangers = [[NSMutableArray alloc] init];
    
    //**[[FBSingleton sharedInstance] setDelegate:self];
    //**[[FBSingleton sharedInstance] RequestHitWhoList];
    
    table.delegate = self;
    table.dataSource = self;
    
    namelabel.numberOfLines = 1;
    namelabel.adjustsFontSizeToFitWidth = YES;
    
    spinner = [SpinnerView loadSpinnerIntoView:loadingView];
    tablepull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.table];
    self.popoverController = [[WEPopoverController alloc] init];
    
    [self.table addSubview:tablepull];
    
    isHammerDown = NO;
    isTableLoaded = NO;
    
    NSString *path = [self dataFilepath];
    dic = [[NSDictionary alloc] initWithContentsOfFile:path];

}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [[FBSingletonNew sharedInstance] setDelegate:self];
    [tablepull setDelegate:self];
    
    //[table setFrame:CGRectMake(308, 42, 162, 250)];
    
    //set initial portrait to be empty
    faceView.image = nil;
    bodyView.image = nil;
    hitNumber.image = nil;
    
    //if hammers are down, send them up
    if (isHammerDown) {
        [self sendHammersUpWithBlock:^(BOOL finished) {
            isHammerDown = NO;
        }];
    }
    [self loadPlayersList];
}

-(void) viewDidAppear:(BOOL)animated {
    BOOL showTut = [[dic objectForKey:@"Tutorial"] boolValue];
    if (showTut) {
        [self popTutorial];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
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

/*-(void) FBSingletonHitWhoIDListLoaded:(NSArray *)friendUsingAppID{
    NSLog(@"%@",friendUsingAppID);
    
    //comment might be userful when cache the friendsArray [straighters remain the same unless pull to refresh]
    
    if ([[[UserInfo sharedInstance] friendArray] friends] == nil){
        [self getFriendDBInfo:friendUsingAppID];
    }
    else{
        resultFriends = [NSArray arrayWithArray:[[[UserInfo sharedInstance] friendArray] friends]];
    }
}*/

-(void)closedAboutPage:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished) {
        [popUp removeFromSuperview];
    }];
}

- (void) popTutorial {
    popUp = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tut_hitWho_v2.png"]];
    imgView.frame = popUp.frame;
    
    UIButton *okBtnTut = [[UIButton alloc] initWithFrame:self.view.frame];
    [okBtnTut addTarget:self action:@selector(closedAboutPage:) forControlEvents:UIControlEventTouchUpInside];
    [popUp addSubview:imgView];
    [popUp addSubview:okBtnTut];
    
    popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self.view addSubview:popUp];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            }];
        }];
    }];
}

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
        [cell.backgroundView setContentMode:UIViewContentModeScaleToFill];
        cell.spinner = [[SpinnerView alloc] initWithFrame:cell.containerView.bounds];
    }
        
    Friend *friend = [resultFriends objectAtIndex:indexPath.row];
    cell.identity = friend.user_id;
    
    NSArray *temp = [friend.name componentsSeparatedByString:@" "];
    NSString *firstName = [temp objectAtIndex:0];
    NSString *lastName = [temp objectAtIndex:1];
    NSString *firstInitial = [lastName substringToIndex:1];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@.", firstName, firstInitial];
    cell.name.text = fullName;
    cell.name.lineBreakMode  = NSLineBreakByWordWrapping;
    
    //cell.gender.text = friend.gender;
    cell.popularity.text = [NSString stringWithFormat:@"%d",friend.popularity];
    NSString *formatting = [NSString stringWithFormat:@"http://www.whackwho.com/userImages/%@.png", friend.head_id];
    
    [cell.profileImage setImageWithURL:[NSURL URLWithString:formatting] success:^(UIImage *image) {
        [cell.spinner removeSpinner];
        friend.head.headImage = image;
    }failure:^(NSError *error) {
        [cell.spinner removeSpinner];
    }];

    //[cell.profileImage setClipsToBounds:YES];
    [cell.profileImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.profileImage.layer setBorderColor:[[UIColor brownColor] CGColor]];
    [cell.profileImage.layer setBorderWidth:2.0];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You have selected maximum number of hits! Press undo to clear your selections!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
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
    //NSLog(@"loaded responses:%@",object);
    FriendArray *friendArray = object;
    [friendArray copyToUserInfo];

    self.resultFriends = [NSMutableArray arrayWithArray:[(FriendArray *)[[UserInfo sharedInstance] friendArray] friends]];
    self.resultStrangers = [NSMutableArray arrayWithArray:[(FriendArray *)[[UserInfo sharedInstance] friendArray] strangers]];
    
    NSUInteger count = [resultFriends count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [resultFriends exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    //remove urself from the list of strangers
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
    isTableLoaded = YES;
    
    [self.table setContentSize:CGSizeMake(160, 70*resultFriends.count)];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    //NSLog(@"request body:%@",[request HTTPBodyString]);
    //NSLog(@"request url:%@",[request URL]);
    //NSLog(@"response statue: %d", [response statusCode]);
    //NSLog(@"response body:%@",[response bodyAsString]);
    
    //GAME START WITHOUT CHECKING HITS UPDATE ERRORS.
    if ([[request resourcePath] isEqual: @"/hits/update"]){
        [[Game sharedGame] setReadyToStart:YES];
    }
}

//////pull the table///////////
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view{

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
    friendSelected = nil;
    [selectedHits removeAllObjects];
    //[selectedHits removeObject:friendSelected];
    
    //if (selectedHits.count > 0)
      //  friendSelected = [selectedHits lastObject];
    //else
      //  friendSelected = nil;
    
    [self updateHitWindow];
    [self switchMainViewToIndex];
}

-(IBAction)battleTouched:(id)sender {
    if (!isTableLoaded) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please wait for list to be loaded" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (selectedHits.count == 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:resultFriends];
        [array addObjectsFromArray:resultStrangers];
        int numberOfStrangers = arc4random() % 4 + 1;
        for (int i = 0; i < numberOfStrangers; ++i) {
            while (true) {
                int index = arc4random() % array.count;
                Friend *fr = [array objectAtIndex:index];
                if (![selectedHits containsObject:fr]) {
                    if (fr.head.headImage == nil) {
                        NSString *MyURL = [NSString stringWithFormat:@"http://www.whackwho.com/userImages/%@.png", fr.head_id];
                        fr.head.headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
                    }
                    [selectedHits addObject:fr];
                    break;
                }
            }
        }
    }
    
    InBetweenViewController *contentViewController = [[InBetweenViewController alloc] initWithNibName: @"InBetweenViewController" bundle:nil];
    switch (selectedHits.count) {
        case 4:
            contentViewController.image4 = [[[selectedHits objectAtIndex:3] head] headImage];
        case 3:
            contentViewController.image3 = [[[selectedHits objectAtIndex:2] head] headImage];
        case 2:
            contentViewController.image2 = [[[selectedHits objectAtIndex:1] head] headImage];
        case 1:
            contentViewController.image1 = [[[selectedHits objectAtIndex:0] head] headImage];
            break;
    }
    
    [self.popoverController setContentViewController:contentViewController];
    [self.popoverController presentPopoverFromRect:CGRectZero
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    [self.popoverController.view setFrame:self.view.frame];
    self.popoverController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    
    [self performSelectorInBackground:@selector(processImagesInBackground) withObject:nil];
    
    void (^block)(BOOL) = ^(BOOL finished) {
        if (finished) {
            
            [self updateFriendsHit];
            
            while (![Game sharedGame].readyToStart);
            isHammerDown = YES;
            [Game sharedGame].readyToStart = NO;
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:selectedHits];
            [tempArray addObjectsFromArray:selectedStrangers];
            [[Game sharedGame] setFriendArray:tempArray];
            [self performSelector:@selector(playgame) withObject:nil afterDelay:1.5f];
        }
    };
    
    [self sendHammersDownWithBlock:block];
}

-(void) playgame {
    [self performSegueWithIdentifier:ChooseToGame sender:nil];
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void) processImagesInBackground {
    int max_popups = 2 * [selectedHits count] + 1;

    NSMutableArray *finalImages = [[NSMutableArray alloc] initWithCapacity:max_popups];
    
    for (int i = 0; i < max_popups; ++i) {
        if (selectedHits.count > i) {
            [finalImages addObject:[self captureImageInHitBox:i withArray:0]];
        } else {
            //going to decide in captureimagefunction stranger selection criteria
            [finalImages addObject:[self captureImageInHitBox:0 withArray:1]];
        }
    }
    
    [[Game sharedGame] setSelectHeadCount:selectedHits.count];
    [[Game sharedGame] setArrayOfAllPopups:finalImages];
    
    CCDirector *shared = [CCDirector sharedDirector];
    if (shared.runningScene != nil) {
        [shared replaceScene:[[HelloWorldScene alloc] init]];
    }
    [[Game sharedGame] setReadyToStart:YES];

}

- (IBAction)Back_Touched:(id)sender {
    if (!isTableLoaded) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please wait for list to be loaded. Be patient!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - capture image

//you do not capture the different equipments. etc
- (UIImage *)captureImageInHitBox:(NSInteger)number withArray: (NSInteger)array {
    //capturing image from friends
    Friend *friend;
    if (array == 0) {
        friend = [selectedHits objectAtIndex:number];
        faceView.image = friend.head.headImage;
        int randomBody = (arc4random() % 5) + 1;
        bodyView.image = [UIImage imageNamed:[NSString stringWithFormat:@"body%i_1.png", randomBody]];
        
        //CurrentEquip *ce = friend.currentEquip;
        //faceView.image = friend.head.headImage;
        //bodyView.image = [UIImage imageNamed:ce.body];
        
    } else {//capturing image from strangers
        int randInt;
        
        //testing purposes
        //for (Friend *friend in resultStrangers) {
        //NSLog(@"%@", friend.name);
        //}
        
        while (TRUE) {
            randInt = arc4random() % resultStrangers.count;
            friend = [resultStrangers objectAtIndex:randInt];
            
            if (![selectedStrangers containsObject:friend] && ![selectedHits containsObject:friend]) {
                [selectedStrangers addObject:friend];
                break;
            }
        }
        
        if (!friend.head.headImage) {
            friend.head.headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.whackwho.com/userImages/%@.png", friend.head_id]]]];
        }
        faceView.image = friend.head.headImage;
        int whichBody = [[Game sharedGame] randomed_body];
        bodyView.image = [UIImage imageNamed:[NSString stringWithFormat:@"body%i_1.png", whichBody]];
        
        //CurrentEquip *ce = friend.currentEquip;
        //faceView.image = friend.head.headImage;
        //bodyView.image = [UIImage imageNamed:ce.body];
    }
    
    // If scale is 0, it'll follows the screen scale for creating the bounds
    UIGraphicsBeginImageContextWithOptions(self.faceView.bounds.size, NO, 1.0f);
    
    [self.faceView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
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
        bodyView.image = nil;
        hitNumber.image = nil;
        [namelabel setText:nil];
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
    
    //CurrentEquip *ce = friendSelected.currentEquip;
    faceView.image = friendSelected.head.headImage;
    int randomBody = (arc4random() % 5) + 1;
    bodyView.image = [UIImage imageNamed:[NSString stringWithFormat:@"body%i_1.png", randomBody]];
    
    NSArray *temp = [friendSelected.name componentsSeparatedByString:@" "];
    NSString *firstName = [temp objectAtIndex:0];
    NSString *lastName = [temp objectAtIndex:1];
    NSString *firstInitial = [lastName substringToIndex:1];
    namelabel.text = [NSString stringWithFormat:@"%@ %@.", firstName, firstInitial];
}

- (IBAction)Help_Pressed:(id)sender {
    if (!isTableLoaded) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please wait for list to be loaded. Be patient!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![self.view.subviews containsObject:popUp]) {
        [self popTutorial];
    }
}

#pragma mark - hammer animations
-(void) sendHammersDownWithBlock:(void(^)(BOOL finished))block {
    if (isHammerDown)
        return;
    
    [self.view bringSubviewToFront:leftHammer];
    [self.view bringSubviewToFront:rightHammer];
    
    CGPoint origPt_l = leftHammer.center;
    CGPoint origPt_r = rightHammer.center;
    
    [UIView animateWithDuration:1.5f
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

-(void)updateFriendsHit{
    RKParams* params = [RKParams params];
    NSMutableArray *requestArray = [[NSMutableArray alloc] init];
    for (Friend *f in selectedHits){
        [requestArray addObject:[NSString stringWithFormat:@"%@,%@",f.whackwho_id,f.mediaType_id]];
    }
    [params setValue:[requestArray componentsJoinedByString:@"|"] forParam:@"hitmembers"];//e.g "45,1|23,1|46,1" (whackID|mediatype_id)
    NSLog(@"%@",[requestArray componentsJoinedByString:@"|"]);
    
    // Log info about the serialization
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    
    [[RKObjectManager sharedManager].client post:@"/hits/update" params:params delegate:self];
}

- (NSString *) dataFilepath {
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"ScorePlist.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"ScorePlist" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    
    return destPath;
}

@end
