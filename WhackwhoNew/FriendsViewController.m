//
//  FriendsViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-05.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsTableCell.h"
#import "GlobalMethods.h"
#import "FBSingleton.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

@synthesize resultData, resultAction;
@synthesize tableCell,friendTable, spinner, loadingView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[FBSingleton sharedInstance] RequestFriendsNotUsing];
    
    [[GlobalMethods alloc] setViewBackground:FriendList_bg viewSender:self.view];
    friendsTable.dataSource = self;
    friendsTable.delegate = self;
    friendsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    spinner = [[SpinnerView alloc] initWithFrame:loadingView.bounds];
    //[FBSingleton sharedInstance].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (!resultData.count)
        [spinner startSpinnerInView:loadingView];
}

-(void)viewDidAppear:(BOOL)animated{
    [FBSingleton sharedInstance].delegate = self;
    if (!resultData.count)
        [spinner startSpinnerInView:loadingView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) filterFriendsNotUsingApp{
    //NSPredicate *predicate = [NSPredicate ]
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
    return [resultData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FriendsTableCell";
    
    FriendsTableCell *cell = (FriendsTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsTableCell" owner:self options:nil];
        cell = (FriendsTableCell *)[nib objectAtIndex:0];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:FriendListCell]];
        [cell setContentMode:UIViewContentModeScaleAspectFit];
        cell.spinner = [[SpinnerView alloc] initWithFrame:cell.containerView.bounds];   
    }
    
    Friend *friend = [resultData objectAtIndex:indexPath.row];
    cell.user_id = friend.user_id;
    cell.name.text = friend.name;
    cell.name.lineBreakMode  = UILineBreakModeWordWrap;
    cell.gender.text = friend.gender;
    if (friend.isPlayer){
        cell.isPlayer.text = @"玩家";
        cell.Invite_but.hidden = YES;
        
    }else{
        cell.isPlayer.text = @"傻逼";
        cell.Invite_but.hidden = NO;
    }
    
    NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", friend.user_id];

    [cell.profileImageView setImageWithURL:[NSURL URLWithString:formatting] success:^(UIImage *image) {
        [cell.spinner removeSpinner];
    }failure:^(NSError *error) {
        [cell.spinner removeSpinner];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableCell *celler = (FriendsTableCell *)cell;
    if (celler.profileImageView.image == nil)
        [celler.spinner startSpinnerInView:celler.containerView];
}


////FBSingletonDelegation:
-(void) FBSIngletonFriendsDidLoaded:(NSDictionary *)friends{
    self.resultData = [[NSArray alloc] initWithArray:[friends allValues]];
    [self.spinner removeSpinner];
    [self.friendTable reloadData];
}

-(void)FBSingletonInviteYouCompleted:(BOOL)success :(NSArray *)fbIDs{
        NSArray *cells = [self findCells:fbIDs];
    if (success == YES){
        for (FriendsTableCell *cell in cells){
            cell.Invite_but.titleLabel.text = @"Invited";
            cell.Invite_but.enabled = NO;
        }
    }else {
        for (FriendsTableCell *cell in cells){
            cell.Invite_but.titleLabel.text = @"Failed";
        }
    }
}

//return the searched cell:
-(NSArray *)findCells:(NSArray*)userIDs{
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (FriendsTableCell *cell in [friendTable visibleCells]){
        if ([userIDs containsObject:cell.user_id]){
            [cells addObject:cell];
        }
    }
    return [[NSArray alloc] initWithArray:cells];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
