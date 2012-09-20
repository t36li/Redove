//
//  AvatarViewController.m
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "AvatarViewController.h"
#import "cocos2d.h"
#import "StatusViewLayer.h"
#import "User.h"

// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
//#define CAMERA_TRANSFORM_Y 1.12412 //use this is for iOS 3.x
#define CAMERA_TRANSFORM_Y 1.24299 // use this is for iOS 4.x

// iPhone screen dimensions:
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

@interface AvatarViewController ()

@end

@implementation AvatarViewController

@synthesize imageView, overlay, cameraController, wtfView;

typedef enum {
    PinchAxisNone,
    PinchAxisHorizontal,
    PinchAxisVertical
} PinchAxis;

PinchAxis pinchGestureRecognizerAxis(UIPinchGestureRecognizer *r) {
    if (r.numberOfTouches < 2)
        return PinchAxisNone;
    UIView *view = r.view;
    CGPoint touch0 = [r locationOfTouch:0 inView:view];
    CGPoint touch1 = [r locationOfTouch:1 inView:view];
    CGFloat tangent = fabsf((touch1.y - touch0.y) / (touch1.x - touch0.x));
    return
    tangent <= 0.2679491924f ? PinchAxisHorizontal // 15 degrees
    : tangent >= 3.7320508076f ? PinchAxisVertical   // 75 degrees
    : PinchAxisNone;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // initialize what you need here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set up background image
    GlobalMethods *gmethods = [[GlobalMethods alloc] init];
    [gmethods setViewBackground:FriendList_bg viewSender:self.view];
    
    cameraController = [[UIImagePickerController alloc] init];
    self.overlay = [[CameraOverlayControllerViewController alloc] initWithNibName:@"CameraOverlayControllerViewController" bundle:nil];
    self.overlay.pickerReference = cameraController;
    self.overlay.delegate = self;
    cameraController.delegate = self.overlay;
    cameraController.navigationBarHidden = YES;
    cameraController.toolbarHidden = YES;
    cameraController.wantsFullScreenLayout = YES;
    
    // Insert the overlay
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        cameraController.showsCameraControls = NO;
        cameraController.wantsFullScreenLayout = YES;
        cameraController.cameraViewTransform = CGAffineTransformScale(cameraController.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);

        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } else
            cameraController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        cameraController.cameraOverlayView = self.overlay.view;

    } else {
        [cameraController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    self.navigationController.navigationBarHidden = NO;
    //avatarView.frame = imageView.bounds;
    self.wtfView.backgroundColor = [UIColor clearColor];    
    
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 10.0;
    [self.imageView addSubview:avatarView];
}

- (void)viewWillAppear:(BOOL)animated {
    /*
    CGRect frame = imageView.bounds;
    CGRect frame2 = avatarView.frame;
    CGRect frame3 = headView.frame;
     */
    self.avatarView.frame = imageView.bounds;
    /*
    CGRect frame4 = imageView.bounds;
    CGRect frame5 = avatarView.frame;
    CGRect frame6 = headView.frame;
     */
    self.navigationController.navigationBarHidden = YES;
    
    UserInfo *usr = [UserInfo sharedInstance];
    if (!newPhoto) {
        [self startCamera:nil];
    } else {
        headView.image = usr.croppedImage;
        backgroundView.image = [UIImage imageNamed:@"white final.png"];
    }
}

-(void)scale:(id)sender {
    
    PinchAxis pinch;
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _xlastScale = 1.0;
        _ylastScale = 1.0;
        pinch = PinchAxisNone;
    } else if ([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        pinch = pinchGestureRecognizerAxis(sender);
    }
    
    CGFloat xScale = 1;
    CGFloat yScale = 1;
    if (pinch == PinchAxisHorizontal) {
        xScale = 1.0 - (_xlastScale - [(UIPinchGestureRecognizer*)sender scale]);
        _xlastScale = [(UIPinchGestureRecognizer*)sender scale];
    } else if (pinch == PinchAxisVertical) {
        yScale = 1.0 - (_ylastScale - [(UIPinchGestureRecognizer*)sender scale]);
        _ylastScale = [(UIPinchGestureRecognizer*)sender scale];
    } else {
//        xScale = 1.0 - (_xlastScale - [(UIPinchGestureRecognizer*)sender scale]);
//        yScale = 1.0 - (_ylastScale - [(UIPinchGestureRecognizer*)sender scale]);
//        _xlastScale = [(UIPinchGestureRecognizer*)sender scale];
//        _ylastScale = [(UIPinchGestureRecognizer*)sender scale];
        return;
    }
    
    
    CGAffineTransform currentTransform = photoView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, xScale, yScale);
    
    [photoView setTransform:newTransform];
    
//    NSLog(@"x = %f, y = %f", photoView.frame.size.width, photoView.frame.size.height);
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
//    if (!CGRectContainsRect(imageView.frame, photoView.frame))
//        return;
    
    CGPoint translation = [recognizer translationInView:self.view];
    photoView.center = CGPointMake(photoView.center.x + translation.x,
                                         photoView.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
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

-(IBAction)startCamera:(id)sender {
    headView.image = nil;
    [self presentModalViewController:cameraController animated:NO];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    
    self.navigationController.navigationBarHidden = YES;
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
    UIImage *uploadImage = usrInfo.croppedImage;//[UIImage imageNamed:@"pause.png"];//usrInfo->usrImg;
    NSData* imageData = UIImagePNGRepresentation(uploadImage);
    [params setData:imageData MIMEType:@"image/png" forParam:[NSString stringWithFormat:@"%d",user.headId]];
    
    // Log info about the serialization
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    
    [[RKObjectManager sharedManager].client post:@"/userImage" params:params delegate:self];
    //[[RKObjectManager sharedManager].client put:@"/userImage" params:params delegate:self];
     
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error.description);
    
}

-(void)validImageCaptured:(UIImage *)image croppedImage:(UIImage *)croppedImg{
    //photoView.image = image;
    //self.imageView.image = image;
    UserInfo *usr = [UserInfo sharedInstance];
    if (image != nil){
        photoView.image = [AvatarBaseController resizeImage:image toSize:photoView.frame.size];
        //[usr setUserPicture:image];
        usr.usrImg = image;
        usr.croppedImage = croppedImg;
        //headView.image = croppedImg;
        //headView.image = usr.croppedImage;
        newPhoto = YES;
        backgroundView.image = [UIImage imageNamed:@"white final.png"];
    }
}

-(void)setUserPictureCompleted{
    //upload to the server
    [self saveUsrImageToServer];
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
    
    [self Back:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    if (newPhoto) {
        newPhoto = NO;
    }
}

-(IBAction) addPicture:(id)sender {
    UserInfo *info = [UserInfo sharedInstance];
    
    if (headView.image != nil) {
        [self Back:nil];
        return;
    }
    [SpinnerView loadSpinnerIntoView:self.view];
    self.view.userInteractionEnabled = NO;

    CGRect newFrame = headView.frame;
    newFrame.origin.x -= photoView.frame.origin.x;
    newFrame.origin.y -= photoView.frame.origin.y;
    UIImage *resizedImage = [AvatarBaseController resizeImage:photoView.image toSize:photoView.frame.size];
    info.croppedImage = [AvatarBaseController cropImage:resizedImage inRect:newFrame];
    headView.image = info.croppedImage;
    photoView.image = nil;
    
    [info setUserPicture:photoView.image delegate:self];
}

- (IBAction) Back:(id)sender{
    UINavigationController *navCon = self.navigationController;

    [navCon popViewControllerAnimated:YES];
    UIViewController *control = [navCon topViewController];
    if ([control isKindOfClass: [LoadViewController class]]) {
        LoadViewController *con = (LoadViewController *)control;
        [con.myLabel setText:@"Loading Complete!"];
        [con performSelector:@selector(goToMenu) withObject:nil afterDelay:2.5];
    }
}

-(IBAction) Change_Skin:(id)sender {
    if (![sender isKindOfClass:[UIButton class]])
        return;
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 0:
            backgroundView.image = [UIImage imageNamed:@"pink final.png"];
            break;
        case 1:
            backgroundView.image = [UIImage imageNamed:@"yellow final.png"];
            break;
        case 2:
            backgroundView.image = [UIImage imageNamed:@"blue final.png"];
            break;
        case 3:
            backgroundView.image = [UIImage imageNamed:@"green final.png"];
            break;
    }
}
@end
