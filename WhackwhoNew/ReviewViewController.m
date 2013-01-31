//
//  ReviewViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-10-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "ReviewViewController.h"
#import "AvatarBaseController.h"
#import "Character.h"
#import "FacebookShareViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

@synthesize portraitView, backBtn, uploadBtn, leftBtn, rightBtn, avatarImageView;
@synthesize scorelbl, goldlbl;

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
    NSArray *hits = [[Game sharedGame] arrayOfHits];
    
    for (int i = 0; i < friends.count; i ++) {
        Friend *friend = [friends objectAtIndex:i];
        Character *character = [hits objectAtIndex:i];
        
        Head *head = friend.head;
        
        CGPoint leftEyePosition = CGPointFromString(head.leftEyePosition);
        CGPoint rightEyePosition = CGPointFromString(head.rightEyePosition);
        CGPoint mouthPosition = CGPointFromString(head.mouthPosition);
        CGPoint leftEarPosition = CGPointFromString(head.leftEarPosition);
        CGPoint rightEarPosition = CGPointFromString(head.rightEarPosition);
        CGPoint nosePosition = CGPointFromString(head.nosePosition);
        CGPoint headPosition = CGPointMake(leftEyePosition.x + 100, leftEyePosition.y - 100);
        CGPoint leftCheekPosition = CGPointMake(leftEyePosition.x, mouthPosition.y - nosePosition.y);
        CGPoint rightCheekPosition = CGPointMake(rightEyePosition.x, mouthPosition.y - nosePosition.y);
        
        UIImage *pic = head.headImage;
        
        int numberOfEffects = character.numberOfHits;
        
        NSMutableDictionary *effectsDict = [[NSMutableDictionary alloc] initWithCapacity:numberOfEffects];
        NSMutableArray *effectsArray = [NSMutableArray arrayWithArray:effects];
        
        for (int j = 0; j < numberOfEffects; ++j ) {
            if (effectsArray.count <= 0)
                break;
            
            int index = arc4random() % effectsArray.count;
            NSArray *individualEffect = [effectsArray objectAtIndex:index];
            
            if (individualEffect.count <= 0) {
                j--;
                [effectsArray removeObjectAtIndex:index];
                continue;
            } else {
                [effectsArray removeObjectAtIndex:index];
            }
            
            index = arc4random() % individualEffect.count;
            NSString *imageName = [individualEffect objectAtIndex:index];
            
            UIImage *effectImage = [imagesOfEffects objectForKey:imageName];
            if ( effectImage == nil) {
                effectImage = [UIImage imageNamed:imageName];
                [imagesOfEffects setObject:effectImage forKey:imageName];
            }
            
            if ([imageName hasPrefix:@"head"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:headPosition]];
            } else if ([imageName hasPrefix:@"right_eye"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:rightEyePosition]];
            } else if ([imageName hasPrefix:@"left_eye"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:leftEyePosition]];
            } else if ([imageName hasPrefix:@"right_ear"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:rightEarPosition]];
            } else if ([imageName hasPrefix:@"left_ear"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:leftEarPosition]];
            } else if ([imageName hasPrefix:@"left_cheek"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:leftCheekPosition]];
            } else if ([imageName hasPrefix:@"right_cheek"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:rightCheekPosition]];
            } else if ([imageName hasPrefix:@"mouth"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:mouthPosition]];
            } else if ([imageName hasPrefix:@"nose"]) {
                [effectsDict setObject:effectImage forKey:[NSValue valueWithCGPoint:nosePosition]];
            } else {
                NSLog(@"SHOULD NOT REACH HERE");
            }
        }
        
        CGRect faceRectSize = CGRectFromString(head.faceRect);
        UIGraphicsBeginImageContext(faceRectSize.size);
        [pic drawInRect:CGRectMake(0, 0, pic.size.width, pic.size.height)];
        //[leftEye drawInRect:CGRectMake(leftEyePosition.x-leftEye.size.width/2, leftEyePosition.y-leftEye.size.height/2, leftEye.size.width, leftEye.size.height)];
        
        for (NSValue *val in effectsDict) {
            UIImage *image = [effectsDict objectForKey:val];
            CGPoint point = [val CGPointValue];
            
            [image drawInRect:CGRectMake(point.x-image.size.width/2, point.y-image.size.height/2, image.size.width, image.size.height)];
        }
        /*
        [lip drawInRect:CGRectMake(mouthPosition.x-lip.size.width/2, mouthPosition.y-lip.size.height/2, lip.size.width, lip.size.height)];
        [leftEar drawInRect:CGRectMake(leftEarPosition.x-leftEar.size.width/2, leftEarPosition.y-leftEar.size.height/2, leftEar.size.width, leftEar.size.height)];
        [rightEar drawInRect:CGRectMake(rightEarPosition.x-rightEar.size.width/2, rightEarPosition.y-rightEar.size.height/2, rightEar.size.width, rightEar.size.height)];
        [nose drawInRect:CGRectMake(nosePosition.x-nose.size.width/2, nosePosition.y-nose.size.height/2, nose.size.width, nose.size.height)];
         */
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
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *last_game_score = [NSNumber numberWithInt:[[Game sharedGame] baseScore]];
    [scorelbl setText:[numberFormatter stringFromNumber:last_game_score]];
    NSNumber *last_game_gold = [NSNumber numberWithInt:[[Game sharedGame] moneyEarned]];
    [goldlbl setText:[numberFormatter stringFromNumber:last_game_gold]];
    
    if ([[Game sharedGame]unlocked_new_bg]) {
        UIAlertView *unlock_alert = [[UIAlertView alloc] initWithTitle:nil message:@"Congratulations! You have unlocked a new game background!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [unlock_alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    avatarArray = [[NSMutableArray alloc] init];
    defaultImage = [UIImage imageNamed:@"vlad.png"];
    
    //UIImage *leftEye = [UIImage imageNamed:@"eye1.png"];
    //UIImage *rightEye = [UIImage imageNamed:@"eye2.png"];
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:MOUTH_EFECT_SWELL];
    [temp addObject:MOUTH_EFFECT_TEETH];
    mouthEffects = temp;
    
    temp = [NSMutableArray array];
    [temp addObject:NOSE_EFFECT_BLOOD];
    [temp addObject:NOSE_EFFECT_SWELL];
    noseEffects = temp;
    
    temp = [NSMutableArray array];
    [temp addObject:EAR_EFFECT_BANDAGE];
    [temp addObject:EAR_EFFECT_BRUISE];
    rightEarEffects = temp;
    
    leftEarEffects = [NSArray arrayWithArray:rightEarEffects];
    
    temp = [NSMutableArray array];
    [temp addObject:CHEEK_EFFECT_BANDAGE];
    [temp addObject:CHEEK_EFFECT_CUT];
    rightCheekEffects = temp;
    
    leftCheekEffects = [NSArray arrayWithArray:rightCheekEffects];
    
    temp = [NSMutableArray array];
    [temp addObject:HEAD_EFFECT_BANDAGE];
    [temp addObject:HEAD_EFFECT_SWELL];
    headEffects = temp;
    
    leftEyeEffects = [NSArray array];
    rightEyeEffects = [NSArray array];
    
    effects = [NSArray arrayWithObjects:leftEyeEffects, rightEyeEffects, noseEffects, mouthEffects, leftCheekEffects, rightCheekEffects, leftEarEffects, rightEarEffects, headEffects, nil];
    
    imagesOfEffects = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hitBack:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 6] animated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
/*
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
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (IBAction) shareToFacebook:(id)sender {
    int width = self.portraitView.frame.size.width * avatarArray.count;
    int counter = 0;
    UIGraphicsBeginImageContext(CGSizeMake(width, portraitView.frame.size.height));
    for (UIImage *pic in avatarArray) {
        [pic drawInRect:CGRectMake(portraitView.frame.size.width*counter, 0, pic.size.width, pic.size.height)];
    }
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    FacebookShareViewController *fbshare = [[FacebookShareViewController alloc]
                                            initWithNibName:@"FacebookShareViewController"
                                            bundle:nil];
    [fbshare setPublishedImage:ret];
    //[fbshare setPostImageView:imageView];
    //[self presentViewController:fbshare animated:YES completion:nil];
    [self.navigationController pushViewController:fbshare animated:YES];
}

@end
