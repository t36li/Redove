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
@synthesize tableCell,friendTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GlobalMethods alloc] setViewBackground:FriendList_bg viewSender:self.view];
    if (resultData){
        //NSLog(@"%@",resultData);
        friendsTable.dataSource = self;
        friendsTable.delegate = self;
        friendsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

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
    }
    
    cell.name.text = (NSString *)[[resultData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.name.lineBreakMode  = UILineBreakModeWordWrap;
    cell.gender.text = (NSString *)[[resultData objectAtIndex:indexPath.row] objectForKey:@"gender"];
    cell.profileImageView.image = [[GlobalMethods alloc] imageForObject:[[resultData objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only handle taps if the view is related to showing nearby places that
    // the user can check-in to.
    
    if ([self.myAction isEqualToString:@"places"]) {
        [self apiGraphUserCheckins:indexPath.row];
    }
     
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)back_Touched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
