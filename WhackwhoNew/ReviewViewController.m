//
//  ReviewViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-10-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "ReviewViewController.h"
#import "AvatarBaseController.h"

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
    NSArray *friends = [[Game sharedGame] friendArray];

    
    for (int i = 0; i < friends.count; i ++) {
        Friend *friend = [friends objectAtIndex:i];
        
        Head *head = friend.head;
        
        UIImage *pic = head.headImage;
        
        UIImage *leftEye = [UIImage imageNamed:@"eye1.png"];
        UIImage *rightEye = [UIImage imageNamed:@"eye2.png"];
        UIImage *lip = [UIImage imageNamed:@"lip 1.png"];
        UIImage *nose = [UIImage imageNamed:@"sworn1.png"];
        UIImage *leftEar = [UIImage imageNamed:@"ear 1.png"];
        UIImage *rightEar = [UIImage imageNamed:@"ear 2.png"];
        
        CGSize screenSize = pic.size;
        UIGraphicsBeginImageContext(screenSize);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGPoint leftEyePosition = CGPointFromString(head.leftEyePosition);
        [pic drawInRect:CGRectMake(0, 0, pic.size.width, pic.size.height)];
        [leftEye drawInRect:CGRectMake(leftEyePosition.x, leftEyePosition.y, leftEye.size.width, leftEye.size.height)];        
        
        UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
                
        if (pic != defaultImage) {
            [avatarArray addObject:[UserInfo resizeImage:ret toSize:portraitView.frame.size]];
        }

    }
    /*
    for (UIImage *img in images) {
        if (img != defaultImage) {
            [avatarArray addObject:[UserInfo resizeImage:img toSize:portraitView.frame.size]];
            
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            [containerView addSubview:imgView];
            
            Head *head = friends 
            
            UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, NO, 1.0f);
            
            [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            // Get the image out of the context
            UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }*/
    if (avatarArray.count > 0) {
        self.avatarImageView.image = [avatarArray objectAtIndex:0];
        //[user performSelector:@selector(markFaces:withDelegate:) withObject:self.avatarImageView.image withObject:self];
        selectedIndex = 0;
    }
    
    int n = [[Game sharedGame] selectHeadCount];
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
        self.avatarImageView.image = [avatarArray objectAtIndex:selectedIndex];
        //[[UserInfo sharedInstance] performSelector:@selector(markFaces:withDelegate:) withObject:self.avatarImageView.image withObject:self];
    }
}

-(IBAction) hitRight:(id)sender {
    if (selectedIndex < avatarArray.count - 1) {
        selectedIndex ++;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
