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
@synthesize selectedHits;
@synthesize hit1, hit2, hit3;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GlobalMethods alloc] setViewBackground:FriendList_bg viewSender:self.view];
    if (resultData){
        //NSLog(@"%@",resultData);
        friendsTable.dataSource = self;
        friendsTable.delegate = self;
        friendsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        selectedHits = [[NSMutableArray alloc] initWithObjects:hit1, hit2, hit3, nil];
        selectedHitsNames = [[NSMutableArray alloc] initWithObjects:@"test", @"test", @"test", nil];
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
    
    cell.identity = [[resultData objectAtIndex:indexPath.row] objectForKey:@"id"];
    cell.name.text = (NSString *)[[resultData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.name.lineBreakMode  = UILineBreakModeWordWrap;
    cell.gender.text = (NSString *)[[resultData objectAtIndex:indexPath.row] objectForKey:@"gender"];
    cell.profileImageView.image = [[GlobalMethods alloc] imageForObject:[[resultData objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only handle taps if the view is related to showing nearby places that
    // the user can check-in to.
    
    FriendsTableCell *cell = (FriendsTableCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    UIImage *tempImage = cell.profileImageView.image;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)back_Touched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
