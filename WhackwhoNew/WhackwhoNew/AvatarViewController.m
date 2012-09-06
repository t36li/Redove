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

@interface AvatarViewController ()

@end

@implementation AvatarViewController

@synthesize imageView, overlay, cameraController, wtfView;

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
    
    newPhoto = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
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
        cameraController.showsCameraControls = YES;

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
    [self presentModalViewController:cameraController animated:NO];
}

-(void)saveUsrImageToServer{
    //User: a static class for loading userInfo
    User *user = [User alloc];
    UserInfo *usrInfo = [UserInfo sharedInstance];
    [user getFromUserInfo];
    /*
    [[RKObjectManager sharedManager] postObject delegate:(id<RKObjectLoaderDelegate>):user usingBlock:^(RKObjectLoader *loader){
        //loader.targetObject = nil;
        RKParams* params = [RKParams params];
        //[params setValue:[NSString stringWithFormat:@"%d",user.whackWhoId] forParam:@"whackwho_id"];
        //[params setValue:[NSString stringWithFormat:@"%d",user.headId] forParam:@"head_id"];
        //[params setValue:user.leftEyePosition forParam:@"leftEyePosition"];
        //[params setValue:user.rightEyePosition forParam:@"rightEyePosition"];
        //[params setValue:user.mouthPosition forParam:@"mouthPosition"];
        //[params setValue:user.faceRect forParam:@"faceRect"];
        
        NSData* imageData = UIImagePNGRepresentation(usrInfo->usrImg);
        [params setData:imageData MIMEType:@"image/png" forParam:[NSString stringWithFormat:@"%i",user.headId]];
        
        loader.params = params;
        loader.delegate = self;
    }];//put usrImg
     */
    RKParams* params = [RKParams params];
    [params setValue:[NSString stringWithFormat:@"%d",user.whackWhoId] forParam:@"whackwho_id"];
    [params setValue:[NSString stringWithFormat:@"%d",user.headId] forParam:@"head_id"];
    [params setValue:user.leftEyePosition forParam:@"leftEyePosition"];
    [params setValue:user.rightEyePosition forParam:@"rightEyePosition"];
    [params setValue:user.mouthPosition forParam:@"mouthPosition"];
    [params setValue:user.faceRect forParam:@"faceRect"];
    UIImage *uploadImage = usrInfo->croppedImage;//[UIImage imageNamed:@"pause.png"];//usrInfo->usrImg;
    NSData* imageData = UIImagePNGRepresentation(uploadImage);
    [params setData:imageData MIMEType:@"image/png" forParam:[NSString stringWithFormat:@"%d",user.headId]];
    
    // Log info about the serialization
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    
    [[RKObjectManager sharedManager].client post:@"/userImage" params:params delegate:self];
    //[[RKObjectManager sharedManager].client put:@"/userImage" params:params delegate:self];
     
}

-(void)validImageCaptured:(UIImage *)image croppedImage:(UIImage *)croppedImg{
    //photoView.image = image;
    //self.imageView.image = image;
    UserInfo *usr = [UserInfo sharedInstance];
    if (image != nil){
        //photoView.image = image;
        //[usr setUserPicture:image];
        [usr setUserPicture:image delegate:self];
        //headView.image = croppedImg;
        backgroundView.image = usr.exportImage;
        newPhoto = YES;
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
}


-(void)viewDidAppear:(BOOL)animated {
    if (newPhoto) {
        // Create a new image view, from the image made by our gradient metho
        //[self performSelectorInBackground:@selector(markFaces:) withObject:photoView];
        
        newPhoto = NO;
    }
}

-(IBAction) addPicture:(id)sender {
    //headView.image = [[UserInfo sharedInstance] getCroppedImage];
    backgroundView.image = [[UserInfo sharedInstance] exportImage];
}

- (IBAction)Back_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) Back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
