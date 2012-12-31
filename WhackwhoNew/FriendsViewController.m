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

@interface FriendsViewController ()

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

- (void)fillTextBoxAndDismiss:(NSString *)text;

@end

@implementation FriendsViewController

@synthesize resultData, resultAction;
@synthesize tableCell,friendTable, spinner, loadingView;
@synthesize friendPickerController,selectedFriendsView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //**[[FBSingleton sharedInstance] RequestFriendsNotUsing];
    
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
    //**[FBSingleton sharedInstance].delegate = self;
    if (!resultData.count)
        [spinner startSpinnerInView:loadingView];
}


- (void)viewDidUnload
{
    self.selectedFriendsView = nil;
    self.friendPickerController = nil;
    [self setInviteMessage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) filterFriendsNotUsingApp{
    //NSPredicate *predicate = [NSPredicate ]
}

- (IBAction)FriendListClick:(id)sender {
    if(self.friendPickerController == nil){
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSMutableString *text = [[NSMutableString alloc] init];
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
    }
    
    [self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self fillTextBoxAndDismiss:@"<Cancelled>"];
}

- (void)fillTextBoxAndDismiss:(NSString *)text {
    self.inviteMessage.text = text;
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    cell.name.lineBreakMode  = NSLineBreakByWordWrapping;
    cell.gender.text = friend.gender;
    if (friend.isPlayer){
        cell.isPlayer.text = @"玩家";
        cell.Invite_but.hidden = YES;
        
    }else{
        cell.isPlayer.text = @"傻逼";
        cell.Invite_but.hidden = NO;
    }
    
    //NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", friend.user_id];

    /*[cell.FBprofileImageView setImageWithURL:[NSURL URLWithString:formatting] success:^(UIImage *image) {
        [cell.spinner removeSpinner];
    }failure:^(NSError *error) {
        [cell.spinner removeSpinner];
    }];*/
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableCell *celler = (FriendsTableCell *)cell;
    if (celler.FBprofileImageView == nil)
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
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}




- (IBAction)back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SendTouched:(id)sender {
    // User has clicked on the Tell Friends button
    [[FBSingletonNew sharedInstance] performSelector:@selector(sendRequest) withObject:nil afterDelay:0.5];
}
@end
