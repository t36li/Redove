//
//  ModeSelectionViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-07-12.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "HitWhoViewController.h"
#import "FBSingleton.h"

@implementation HitWhoViewController

@synthesize selectedHits;
@synthesize hit1, hit2, hit3;
@synthesize noHit1, noHit2, noHit3, noHit4;
@synthesize portrait;
@synthesize table;

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
    selectedHitsNames = [[NSMutableArray alloc] initWithObjects:@"test", @"test", @"test", nil];
    noHits = [[NSMutableArray alloc] initWithObjects:noHit1, noHit2, noHit3, noHit4, nil];
    
    for (UIImageView *temp in selectedHits) {
        temp.userInteractionEnabled = YES;
    }
    
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

-(void) FBUserFriendsAppNotUsing:(NSMutableArray *)friends{
    resultFriends = friends;
    if (resultFriends){
        table.delegate = self;
        table.dataSource = self;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.table reloadData];
        }); 
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
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:FriendListCell]];
        [cell setContentMode:UIViewContentModeScaleAspectFit];
    } 
    
    cell.identity = [[resultFriends objectAtIndex:indexPath.row] objectForKey:@"id"];
    cell.name.text = (NSString *)[[resultFriends objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.name.lineBreakMode  = UILineBreakModeWordWrap;
    cell.gender.text = (NSString *)[[resultFriends objectAtIndex:indexPath.row] objectForKey:@"gender"];
    cell.profileImage.image = [[GlobalMethods alloc] imageForObject:[[resultFriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only handle taps if the view is related to showing nearby places that
    // the user can check-in to.
    
    hitFriendCell *cell = (hitFriendCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    UIImage *tempImage = cell.profileImage.image;
    NSString *usrId = cell.identity;
    int index = 0;
    
    for (UIImageView *temp in selectedHits) {
        if (temp.image == nil) { //if no image there
            
            //set little circle image, check if already picked
            if ([selectedHitsNames containsObject:usrId]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Picked!" message:@"Press the button to..." delegate:self cancelButtonTitle:@"Resume" otherButtonTitles:nil];
                [alert show];
                return;
            }
            //if not picked, 
            temp.image = tempImage;
            temp.tag = index;
            [selectedHitsNames replaceObjectAtIndex:index withObject:usrId];
            
            //set up big portraint image glview
            //chooseWholayer has to obtain image from Game.h
            // do something like [[game sharedgame] setHead: tempImage];
            
            //add tap gesture (to view the glview)
            
            //add swipe to cancel gesture (little cancel mark)
            UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnImage:)];
            gesture.numberOfTouchesRequired = 1;
            temp.userInteractionEnabled = YES;
            [temp addGestureRecognizer:gesture];
            
            break;
        }
        index++;
    }//ends for loop
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) handleTapOnImage:(id)sender {
    UISwipeGestureRecognizer *tap = (UISwipeGestureRecognizer *)sender;
    ((UIImageView *)(tap.view)).image = nil;
    
    //remove the object from the "taken" array
    int index = ((UIImageView *)(tap.view)).tag;
    [selectedHitsNames replaceObjectAtIndex:index withObject:@"test"];
}

-(IBAction) handleRandomButton:(id)sender {
    for (UIImageView *temp in noHits) {
        //if (temp.image == nil) {
            int randFriend = arc4random() % [resultFriends count];
            UIImage *tempImage = [[GlobalMethods alloc] imageForObject:[[resultFriends objectAtIndex:randFriend] objectForKey:@"id"]];
            
            temp.image = tempImage;
        //}
    }
}

//-(void) scrollview method... {
    // .... add the friend name to the list of strings
//}

@end
