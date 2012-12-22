//
//  ReviewViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-10-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

@synthesize portraitView, backBtn, uploadBtn, leftBtn, rightBtn, avatarImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSArray *images = [[Game sharedGame] arrayOfAllPopups];
    for (UIImage *img in images) {
        if (img != defaultImage) {
            [avatarArray addObject:[UserInfo resizeImage:img toSize:portraitView.frame.size]];
        }
    }
    if (avatarArray.count > 0) {
        self.avatarImageView.image = [avatarArray objectAtIndex:0];
        //[user performSelector:@selector(markFaces:withDelegate:) withObject:self.avatarImageView.image withObject:self];
        selectedIndex = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    avatarArray = [[NSMutableArray alloc] init];
    defaultImage = [UIImage imageNamed:@"vlad.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hitBack:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] animated:YES];
}

-(void) clearImageViews {
    for (UIView *view in portraitView.subviews) {
        if (view == avatarImageView)
            continue;
        [view removeFromSuperview];
    }
}

-(IBAction) hitLeft:(id)sender {
    if (selectedIndex > 0) {
        selectedIndex --;
        [self clearImageViews];
        self.avatarImageView.image = [avatarArray objectAtIndex:selectedIndex];
        //[[UserInfo sharedInstance] performSelector:@selector(markFaces:withDelegate:) withObject:self.avatarImageView.image withObject:self];
    }
}

-(IBAction) hitRight:(id)sender {
    if (selectedIndex < avatarArray.count - 1) {
        selectedIndex ++;
        [self clearImageViews];
        self.avatarImageView.image = [avatarArray objectAtIndex:selectedIndex];
        //[[UserInfo sharedInstance] performSelector:@selector(markFaces:withDelegate:) withObject:self.avatarImageView.image withObject:self];
    }
}

-(void)setUserPictureCompleted {
    UserInfo *user = [UserInfo sharedInstance];
    CGFloat faceWidth = user.faceRect.size.width;
    
    UIImageView *leftEye = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye1.png"]];
    CGRect leftEyeFrame = CGRectMake(user.leftEyePosition.x-faceWidth*0.15, user.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3);
    leftEye.frame = leftEyeFrame;
    leftEye.center = user.leftEyePosition;
    [portraitView addSubview:leftEye];
    
    UIImageView *rightEye = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye2.png"]];
    CGRect rightEyeFrame = CGRectMake(user.rightEyePosition.x-faceWidth*0.15, user.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3);
    rightEye.frame = rightEyeFrame;
    rightEye.center = user.rightEyePosition;
    [portraitView addSubview:rightEye];
    
    UIImageView *mouth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lip 1.png"]];
    CGRect mouthFrame = CGRectMake(user.mouthPosition.x-faceWidth*0.2, user.mouthPosition.y-faceWidth*0.15, faceWidth*0.4, faceWidth*0.3);
    mouth.frame = mouthFrame;
    mouth.center = user.mouthPosition;
    [portraitView addSubview:mouth];
}
@end
