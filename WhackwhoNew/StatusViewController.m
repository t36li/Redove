//
//  StatusBarController.m
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "StatusViewController.h"
#import "FacebookShareViewController.h"
#import "User.h"
#import "HitUpdate.h"
#import "UserInfo.h"
#import "SpinnerView.h"
#import "WEPopoverContentViewController.h"
#import "WEPopoverController.h"
#import "StatusViewTutorialPopover.h"
#import "Game.h"

//define tags
//#define helmet_Label 1
//#define body_Label 2
//#define hammerHand_Label 3
//#define shieldHand_Label 4



// iPhone screen dimensions:
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

@implementation StatusViewController

@synthesize containerView;
@synthesize faceView, bodyView;
@synthesize popularity_lbl, games_played_lbl, high_score_lbl, unlocks_lbl;
//@synthesize popoverController;



-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [faceView setContentMode:UIViewContentModeScaleAspectFit];
    [bodyView setContentMode:UIViewContentModeScaleToFill];
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    
    shown = NO;
    
    //need to cache user's previous image
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

//newbie alert view
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        if (buttonIndex == 0){
            //[self performSegueWithIdentifier:@"goToAvatar" sender:nil];
            [self pushCamera:nil];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    

    UIImage *face_DB = [[UserInfo sharedInstance] croppedImage];
            
    [faceView setImage:face_DB];
    int whichBody = (arc4random() % 5) + 1;
    [[Game sharedGame] setRandomed_body:whichBody];
    [bodyView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"body%i_1.png", whichBody]]];
}

-(void)setLabels {
    NSString *path = [self dataFilepath];
    NSDictionary *newDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    dic = newDic;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //if popularity changes... then what
    [high_score_lbl setText:[numberFormatter stringFromNumber:[self readPlist:@"High_Score"]]];
    
    int hammers_unlocked = [[self readPlist:@"Hammers_Unlocked"] intValue];
    int bgs_unlocked = [[self readPlist:@"Bgs_Unlocked"] intValue];
    NSString *unlocked = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(hammers_unlocked + bgs_unlocked)]];
    [unlocks_lbl setText:[NSString stringWithFormat:@"%@ / 5", unlocked]];
    
    [games_played_lbl setText:[numberFormatter stringFromNumber:[self readPlist:@"Games_Played"] ]];
    
    [RKClient clientWithBaseURL:[NSURL URLWithString:BaseURL]];
    NSString *whackID = [NSString stringWithFormat:@"%i",[[UserInfo sharedInstance] whackWhoId]];
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/hits/%@", whackID] delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [self setLabels];
}

-(void)closedAboutPage:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished) {
        [popUp removeFromSuperview];
    }];
}

- (void) popTutorial {
    popUp = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tut_personal_v2.png"]];
    imgView.frame = popUp.frame;
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:self.view.frame];
    [okBtn addTarget:self action:@selector(closedAboutPage:) forControlEvents:UIControlEventTouchUpInside];
    [popUp addSubview:imgView];
    [popUp addSubview:okBtn];
    
    popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self.view addSubview:popUp];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popUp.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//Plist methods
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

- (IBAction)deletePlist:(id)sender {
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"ScorePlist.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:destPath]) {
        [fileManager removeItemAtPath:destPath error:nil];
    }
}

- (NSNumber *)readPlist: (NSString *) whichLbl {
    NSNumber *ret = [dic objectForKey:whichLbl];
    
    //NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSLog(@"%@: %i", whichLbl, [ret intValue]);
    
    return ret;
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
    
    //moved below to ViewWillAppear
    //[popularity_lbl setText:[NSString stringWithFormat:@"%d",[[UserInfo sharedInstance] popularity]]];
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    NSLog(@"loaded responses:%@",object);
    
    
}   

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    //NSLog(@"request body:%@",[request HTTPBodyString]);
    //NSLog(@"request url:%@",[request URL]);
    //NSLog(@"request resourcePath: %@",[request resourcePath]);
    //NSLog(@"response statue: %d", [response statusCode]);
    //NSLog(@"response body:%@",[response bodyAsString]);
    int popular = [[response bodyAsString] intValue];
    int old_popular = [[UserInfo sharedInstance] popularity];
    int difference = popular - old_popular;
    
    [popularity_lbl setText:[NSString stringWithFormat:@" %@ / +%i", [response bodyAsString], difference]];
    
    if ([[UserInfo sharedInstance] popularity] != popular){
        [[UserInfo sharedInstance] setPopularity:popular];
    }
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
    [self performSegueWithIdentifier:@"StatusToHitWhoSegue" sender:self];
}

-(IBAction)pushCamera:(id)sender {
    CustomDrawViewController *drawController = [[CustomDrawViewController alloc] initWithNibName:@"CustomDrawViewController" bundle:nil];
    [self presentViewController:drawController animated:YES completion:nil];
    drawController.containerView.photo = [[UserInfo sharedInstance] croppedImage];
    drawController.containerView.drawImageView.image = [[UserInfo sharedInstance] croppedImage];
}

- (IBAction)Help_Pressed:(id)sender {
    [self popTutorial];
}

@end
