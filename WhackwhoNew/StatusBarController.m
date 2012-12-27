//
//  StatusBarController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusBarController.h"
#import "StatusViewLayer.h"
#import "HelloWorldLayer.h"
#import "FacebookShareViewController.h"
#import "Dragbox.h"
#import "User.h"
#import "HitUpdate.h"
#import "UserInfo.h"

//define tags
//#define helmet_Label 1
//#define body_Label 2
//#define hammerHand_Label 3
//#define shieldHand_Label 4
#define hs_lbl 1
#define gold_lbl 2
#define gp_lbl 3
#define pop_lbl 4

@implementation StatusBarController

@synthesize containerView;
@synthesize faceView, bodyView;
@synthesize popularity_lbl, total_gold_lbl, total_gp_lbl, high_score_lbl;

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [faceView setContentMode:UIViewContentModeScaleAspectFit];
    [bodyView setContentMode:UIViewContentModeScaleToFill];
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    
    NSString *path = [self dataFilepath];
    
    dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    //need to cache user's previous image
    UserInfo *usr = [UserInfo sharedInstance];
    if (usr.usrImg == nil){
        UIAlertView *takePicAlert = [[UIAlertView alloc] initWithTitle:@"Newbie?" message:@"Take a photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        takePicAlert.tag = 1;
        [takePicAlert show];
    }
}

//newbie alert view
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        if (buttonIndex == 0){
            [self performSegueWithIdentifier:@"goToAvatar" sender:nil];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    UIImage *face_DB = [[UserInfo sharedInstance] croppedImage];
    
    [faceView setImage:face_DB];
    //[bodyView setImage:[UIImage imageNamed:standard_blue_body]];
        
    [high_score_lbl setText:[self readPlist:hs_lbl]];
    [total_gold_lbl setText:[self readPlist:gold_lbl]];
    [total_gp_lbl setText:[self readPlist:gp_lbl]];
        
    [RKClient clientWithBaseURL:[NSURL URLWithString:BaseURL]];
    NSString *whackID = [NSString stringWithFormat:@"%i",[[UserInfo sharedInstance] whackWhoId]];
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/hits/%@", whackID] delegate:self];
    
    //if (faceView.image == face_DB && face_DB != nil)
      //  return;
        
    //UserInfo *usinfo = [UserInfo sharedInstance];
    //CurrentEquip *ce = usinfo.currentEquip;
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

//Plist methods
- (NSString *) dataFilepath {
    //read the plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ScorePlist" ofType:@"plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"The file exists");
        return path;
    } else {
        NSLog(@"The file does not exist");
        return nil;
    }
}

- (NSString *) readPlist: (int) whichLbl {
    NSNumber *ret;
    
    switch (whichLbl) {
        case hs_lbl:
            ret = [dic objectForKey:@"High_Score"];
            break;
        case gold_lbl:
            ret = [dic objectForKey:@"Total_Gold"];
            break;
        case gp_lbl:
            ret = [dic objectForKey:@"Games_Played"];
            break;
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [numberFormatter stringFromNumber:ret];
    
}


//update Database:
/*-(void)updateDB{
    User *user = [[User alloc]init];
    UserInfo *uinfo = [UserInfo sharedInstance];
    user.whackWhoId = [uinfo whackWhoId];
    user.headId = uinfo.headId;
    //user.currentEquip = [[[UserInfo sharedInstance] currentEquip] currentEquipInIDs];
    //user.storageInv = [[[UserInfo sharedInstance] storageInv] setStorageStringInIDs];
    
    [[RKObjectManager sharedManager] putObject:user usingBlock:^(RKObjectLoader *loader){
        loader.targetObject = nil;
        loader.delegate = self;
    }];
}*/

- (IBAction)publish_touched:(id)sender {
    // If scale is 0, it'll follows the screen scale for creating the bounds
    UIGraphicsBeginImageContextWithOptions(self.containerView.bounds.size, NO, 1.0f);
    
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get the image out of the context
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    FacebookShareViewController *fbshare = [[FacebookShareViewController alloc]
                                           initWithNibName:@"FacebookShareViewController"
                                           bundle:nil];
    [fbshare setPublishedImage:copied];
    //[fbshare setPostImageView:imageView];
    //[self presentViewController:fbshare animated:YES completion:nil];
    [self.navigationController pushViewController:fbshare animated:YES];
}

//- (IBAction)saveToDB_Touched:(id)sender {
//    [self updateDB];
//}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    NSLog(@"Load Database Failed:%@",error);
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    NSLog(@"loaded responses:%@",object);
    
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    //NSLog(@"request body:%@",[request HTTPBodyString]);
    //NSLog(@"request url:%@",[request URL]);
    //NSLog(@"response statue: %d", [response statusCode]);
    NSLog(@"response body:%@",[response bodyAsString]);
    
    [popularity_lbl setText:[response bodyAsString]];
}

#pragma mark - touch methods

- (IBAction)Back_Touched:(id)sender {
    //if total stacks = 5, came from email..
    //else, came from facebook
    //int totalStacks = [self.navigationController.viewControllers count];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Ok_Pressed:(id)sender {
    //if no records with current whackwho_id, then insert.
    //else, update
    //[self updateDB];
    [self performSegueWithIdentifier:@"StatusToModeSegue" sender:self];
}

@end
