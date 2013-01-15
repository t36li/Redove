//
//  CustomDrawViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-11-29.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "CustomDrawViewController.h"
#import "UserInfo.h"
#import "User.h"

@interface CustomDrawViewController ()

@end

@implementation CustomDrawViewController

@synthesize containerView;
@synthesize leftEarButton, leftEyeButton, lipsButton, noseButton, rightEarButton, rightEyeButton;
@synthesize buttonSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [containerView setPrePreviousPoint:CGPointZero];
    [containerView setPreviousPoint:CGPointZero];
    [containerView setLineWidth:1.0f];
    [containerView setCurrentColor:[UIColor blackColor]];
    
    buttonSet = [[NSMutableSet alloc] init];
    [buttonSet addObject:leftEyeButton];
    [buttonSet addObject:rightEyeButton];
    [buttonSet addObject:noseButton];
    [buttonSet addObject:lipsButton];
    [buttonSet addObject:leftEarButton];
    [buttonSet addObject:rightEarButton];
    
    for (UIButton *btn in buttonSet) {
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanButton:)];
        [btn addGestureRecognizer:gestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}



-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)backTouched:(id)sender {
    [containerView resetPaths];
}

-(IBAction)crop:(id)sender {
    [containerView commitPaths];
}

-(IBAction)done:(id)sender {
    UserInfo *user = [UserInfo sharedInstance];
    
    for (UIButton *btn in buttonSet) {
        switch (btn.tag) {
            case LEFT_EYE:
                [user setLeftEyePosition:[self.view convertPoint:btn.center toView:containerView]];
                break;
            case RIGHT_EYE:
                [user setRightEyePosition:[self.view convertPoint:btn.center toView:containerView]];
                break;
            case LIPS:
                [user setMouthPosition:[self.view convertPoint:btn.center toView:containerView]];
                break;
            case NOSE:
                [user setNosePosition:[self.view convertPoint:btn.center toView:containerView]];
                break;
            case LEFT_EAR:
                [user setLeftEarPosition:[self.view convertPoint:btn.center toView:containerView]];
                break;
            case RIGHT_EAR:
                [user setRightEarPosition:[self.view convertPoint:btn.center toView:containerView]];
                break;
        }
    }
    /*
    UIImage *leftEye = [UIImage imageNamed:@"eye1.png"];
    UIImage *rightEye = [UIImage imageNamed:@"eye2.png"];
    UIImage *lip = [UIImage imageNamed:@"lip 1.png"];
    UIImage *nose = [UIImage imageNamed:@"sworn1.png"];
    UIImage *leftEar = [UIImage imageNamed:@"ear 1.png"];
    UIImage *rightEar = [UIImage imageNamed:@"ear 2.png"];
    
    CGPoint leftEyePos = user.leftEyePosition;
    CGPoint mouthPos = user.mouthPosition;
    CGRect faceRect = user.faceRect;
    
    CGSize mouthSize = lip.size;
    
    UIGraphicsBeginImageContext(user.faceRect.size);
    [user.croppedImage drawInRect:CGRectMake(0, 0, user.faceRect.size.width, user.faceRect.size.height)];
    [leftEye drawInRect:CGRectMake(user.leftEyePosition.x-leftEye.size.width/2, user.leftEyePosition.y-leftEye.size.height/2, leftEye.size.width, leftEye.size.height)];
    [lip drawInRect:CGRectMake(user.mouthPosition.x-lip.size.width/2, user.mouthPosition.y-lip.size.height/2, lip.size.width, lip.size.height)];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.containerView.drawImageView.image = ret;
    */
    [self saveUsrImageToServer];
}

-(void)didPanButton:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void) viewDidUnload {
    for (UIButton *btn in buttonSet) {
        while ([btn.gestureRecognizers count] > 0) {
            [btn removeGestureRecognizer:[btn.gestureRecognizers objectAtIndex:0]];
        }
    }
    
    [buttonSet removeAllObjects];
    buttonSet = nil;
    
    [super viewDidUnload];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error.description);
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"request: '%@'",[request HTTPBodyString]);
    NSLog(@"request Params: %@", [request params]);
    NSLog(@"response code: %d",[response statusCode]);
    
    if ([request isPUT]) {
        if ([response isOK]){
            NSLog(@"image stored.");
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveUsrImageToServer{
    //User: a static class for loading userInfo
    User *user = [User alloc];
    UserInfo *usrInfo = [UserInfo sharedInstance];
    [user getFromUserInfo];
    
    RKParams* params = [RKParams params];
    [params setValue:[NSString stringWithFormat:@"%d",user.whackWhoId] forParam:@"whackwho_id"];
    [params setValue:[NSString stringWithFormat:@"%d",user.headId] forParam:@"head_id"];
    [params setValue:user.leftEyePosition forParam:@"leftEyePosition"];
    [params setValue:user.rightEyePosition forParam:@"rightEyePosition"];
    [params setValue:user.mouthPosition forParam:@"mouthPosition"];
    [params setValue:user.faceRect forParam:@"faceRect"];
    [params setValue:user.nosePosition forParam:@"nosePosition"];
    [params setValue:user.leftEarPosition forParam:@"leftEarPosition"];
    [params setValue:user.rightEarPosition forParam:@"rightEarPosition"];
    UIImage *uploadImage = usrInfo.croppedImage;
    NSData* imageData = UIImagePNGRepresentation(uploadImage);
    [params setData:imageData MIMEType:@"image/png" forParam:[NSString stringWithFormat:@"%d",user.headId]];
    
    // Log info about the serialization
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    
    [[RKObjectManager sharedManager].client post:@"/user/head" params:params delegate:self];
    //[[RKObjectManager sharedManager].client put:@"/userImage" params:params delegate:self];
    
}

@end
