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

@end

@implementation FriendsViewController

@synthesize resultData, resultAction;
@synthesize tableCell,friendTable, spinner, loadingView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GlobalMethods alloc] setViewBackground:FriendList_bg viewSender:self.view];
    friendsTable.dataSource = self;
    friendsTable.delegate = self;
    friendsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    spinner = [[SpinnerView alloc] initWithFrame:loadingView.bounds];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!resultData.count)
        [spinner startSpinnerInView:loadingView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    
    cell.name.text = friend.name;
    cell.name.lineBreakMode  = UILineBreakModeWordWrap;
    cell.gender.text = friend.gender;
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)back_Touched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
