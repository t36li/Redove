//
//  OptionsViewController.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "OptionsViewController.h"
#import "FBSingletonNew.h"
#import "RootViewController.h"
#import "UserInfo.h"

@implementation OptionsViewController
@synthesize back, logout_but, tutSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    usr = [UserInfo sharedInstance];
    fbs = [FBSingletonNew sharedInstance];
    if ((int)[[UserInfo sharedInstance] currentLogInType] != NotLogIn) {
        logout_but.hidden = NO;
    }
    else {
        logout_but.hidden = YES;
    }
    NSString *path = [self dataFilepath];
    dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated{
    [[FBSingletonNew sharedInstance] setDelegate:self];
    if ([self readPlist]) {
        [tutSwitch setOn:YES animated:NO];
    } else {
        [tutSwitch setOn:NO animated:NO];
    }
}

-(IBAction)back_touched:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)logout_touched:(id)sender{
    switch ([usr currentLogInType]) {
        case LogInFacebook:{
            if ([fbs isLogin]){
                [fbs performLogout];
            }
            break;
        }
        default:
            break;
    }
    //[self performSelector:@selector(back_Touched) withObject:self afterDelay:1.5];
    //**if ([[FBSingleton sharedInstance] isLogIn]){
    //**    [[FBSingleton sharedInstance] logout]; //logout facebook with authorized info
        //[[FBSingleton sharedInstance] unauthorized]; //facebook user info unauthorized
   // }
}

-(void)FBLogOutSuccess{
    [[UserInfo sharedInstance] setCurrentLogInType:NotLogIn];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

-(void)closedAboutPage:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished) {
        [popUp removeFromSuperview];
    }];
}

-(IBAction)about_touched:(id)sender {
    popUp = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about us.png"]];
    imgView.frame = popUp.frame;
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:self.view.frame];
    [okBtn addTarget:self action:@selector(closedAboutPage:) forControlEvents:UIControlEventTouchUpInside];
    [popUp addSubview:imgView];
    [popUp addSubview:okBtn];
    
    
    
    popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self.view addSubview:popUp];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popUp.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

-(IBAction)tutorial_touched:(id)sender {
    if (tutSwitch.on) {
        //NSLog(@"switch is on");
        [self writePlist:YES];
    } else {
        //NSLog(@"switch is off");
        [self writePlist:NO];
    }
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

- (void) writePlist: (BOOL) onOff {
    [dic setObject: [NSNumber numberWithBool:onOff] forKey:@"Tutorial"];
    [dic writeToFile:[self dataFilepath] atomically:NO];
    
}

- (int) readPlist {
    NSNumber *ret = [dic objectForKey:@"Tutorial"];
    return [ret intValue];
}

@end
