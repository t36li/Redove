//
//  ModeSelectionViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HitWhoViewController.h"
#import "FBSingleton.h"

#define ChooseToGame @"chooseToGame"

@implementation HitWhoViewController

@synthesize selectedHits;
@synthesize hit1, hit2, hit3;
@synthesize noHit1, noHit2, noHit3, noHit4;
@synthesize portrait;
@synthesize table;
@synthesize spinner, loadingView;
@synthesize resultFriends;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    selectedHits = [[NSMutableArray alloc] initWithObjects:hit1, hit2, hit3, nil];
    selectedHitsNames = [[NSMutableArray alloc] init];
    noHits = [[NSMutableArray alloc] initWithObjects:noHit1, noHit2, noHit3, noHit4, nil];
    noHitsNames = [[NSMutableArray alloc] init];
    
    /* CCGLView *glview = [CCGLView viewWithFrame:CGRectMake(0, 0, 160,200)];
    [portrait addSubview:glview];
    
    CCDirector *director = [CCDirector sharedDirector];
    [director setView:glview];
    
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseWhoLayer *layer = [ChooseWhoLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer z:0];
    
    [director runWithScene:scene];*/
    
    [[FBSingleton sharedInstance] RequestFriendsNotUsing];
    
    table.delegate = self;
    table.dataSource = self;
    
    spinner = [SpinnerView loadSpinnerIntoView:loadingView];
}

-(void) viewWillAppear:(BOOL)animated{
    [[FBSingleton sharedInstance] setDelegate:self];
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

-(void) FBUserFriendsAppNotUsing:(NSArray *)friends{
    self.resultFriends = friends;
    if (resultFriends){
        [self.table reloadData];
        [spinner removeSpinner];
    }
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
    NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", friend.user_id];
    
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
    int index = 0;
    Friend *friend;
    for (Friend *frd in resultFriends) {
        if (frd.user_id == usrId) {
            friend = frd;
            break;
        }
    }
    
    if (!([selectedHitsNames containsObject:friend] || [noHitsNames containsObject:friend])) {
        if (selectedHitsNames.count < MAX_HITTABLE) {
            [selectedHitsNames addObject:friend];
            
            for (UIImageView *temp in selectedHits) {
                if (temp.image == nil) {
                    temp.image = tempImage;
                    portrait.image = tempImage;
                    [portrait setContentMode:UIViewContentModeScaleAspectFill];
                    temp.tag = index;
                    
                    //set up big portraint image glview
                    //chooseWholayer has to obtain image from Game.h
                    // do something like [[game sharedgame] setHead: tempImage];
                    
                    temp.userInteractionEnabled = YES;
                    
                    //add tap gesture (to view the glview)
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnImage:)];
                    tap.numberOfTapsRequired = 1;
                    [temp addGestureRecognizer:tap];
                    
                    //add swipe to cancel gesture (little cancel mark)
                    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(handleSwipeOnImage:)];
                    swipe.numberOfTouchesRequired = 1;
                    [temp addGestureRecognizer:swipe];
                    break;
                }
                index++;
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) handleTapOnImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIImage *tempImage = ((UIImageView *)(tap.view)).image;
    
    portrait.image = tempImage;
    [portrait setContentMode:UIViewContentModeScaleAspectFill];

}

- (void) handleSwipeOnImage:(id)sender {
    UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)sender;
    if (portrait.image == ((UIImageView *)(swipe.view)).image) {
        portrait.image = nil;
    }
    
    ((UIImageView *)(swipe.view)).image = nil;
    
    //remove the object from the "taken" array
    int index = ((UIImageView *)(swipe.view)).tag;
    
    [selectedHitsNames removeObjectAtIndex:index];
}

-(IBAction) handleRandomButton:(id)sender {
    //first remove all previous names from the NameArray
    if (!resultFriends.count)
        return;
    
    [noHitsNames removeAllObjects];

    for (UIImageView *temp in noHits) {
        //if (temp.image == nil) {
        NSString *tempName;
        // do not generate if already selected
        while (TRUE) {
            int randFriend = arc4random() % [resultFriends count];
            Friend *friend = [resultFriends objectAtIndex:randFriend];
            tempName = friend.user_id;
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
}

-(IBAction) nextTouched:(id)sender {
    //if did not select all hits or did not press random
   /* if ([selectedHitsNames containsObject:@"test"] || [noHitsNames count] < 1) {
        //display alert showing must select all b4 game
        return;
    } else {
    
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [tempArray addObjectsFromArray:selectedHitsNames];
        [tempArray addObjectsFromArray:noHitsNames];
        
        [[Game sharedGame] setFriendList:tempArray];
        [[Game sharedGame] setSelectedHeads:selectedHitsNames];
        
        [self performSegueWithIdentifier:ChooseToGame sender:sender];
    }*/
    [self performSegueWithIdentifier:ChooseToGame sender:sender];

}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void) scrollview method... {
    // .... need to pass Helloworldlayer the bigfriendlist and selectedheadslist
    //bigfriendslist = all 7 possible popups
//}

@end
