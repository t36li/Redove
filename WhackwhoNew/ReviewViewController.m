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
#import "ReviewUploadViewController.h"
#import "AppDelegate.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

@synthesize portraitView, backBtn, uploadBtn, leftBtn, rightBtn, avatarImageView;
@synthesize star1, star2, star3;
@synthesize scorelbl, goldlbl;
@synthesize sendToFBMsg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    if (!once) {
        once = true;
    } else {
        return;
    }
    
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
    
    //int n = [[Game sharedGame] selectHeadCount];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *last_game_score = [NSNumber numberWithInt:[[Game sharedGame] baseScore]];
    [scorelbl setText:[numberFormatter stringFromNumber:last_game_score]];
    NSNumber *highest_combo = [NSNumber numberWithInt:[[Game sharedGame] max_combo]];
    [goldlbl setText:[numberFormatter stringFromNumber:highest_combo]];
    
    //[[Game sharedGame] setUnlocked_new_bg:YES];
    
    if ([[Game sharedGame]unlocked_new_bg] || [[Game sharedGame] unlocked_new_hammer]) {
        UIAlertView *unlock_alert = [[UIAlertView alloc] initWithTitle:nil message:@"Congratulations! You have unlocked a new background and/or hammer! There will now be a random chance for you to experience this! Play more games and achieve higher scores to unlock more!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [unlock_alert show];
    }
    
    if ([last_game_score intValue] > 500) {
        star1.hidden = NO;
        star2.hidden = NO;
        star3.hidden = NO;
    } else if ([last_game_score intValue] > 250) {
        star1.hidden = NO;
        star2.hidden = NO;
        star3.hidden = YES;
    } else {
        star1.hidden = NO;
        star2.hidden = YES;
        star3.hidden = YES;
    }
    
    [[Game sharedGame] resetGameState];
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
    
    once = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hitBack:(id)sender {
    [[Game sharedGame] resetGameState];

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 5] animated:YES];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (IBAction) shareToFacebook:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Post on Facebook" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        NSLog(@"Send to Facebook Cancelled");
    }else{
        sendToFBMsg = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        [self performSegueWithIdentifier:@"ReviewToUpload" sender:self];
    }
    
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReviewToUpload"]) {
        ReviewUploadViewController *vc = [segue destinationViewController];
        
        int counter = 0;
        
        UIImage *bg = [UIImage imageNamed:review_upload_bg];
        
        int headWidth = 150;
        
        UIGraphicsBeginImageContext(CGSizeMake(bg.size.width, bg.size.height));
        [bg drawInRect:CGRectMake(0, 0, bg.size.width, bg.size.height)];
        
        int height = 150;
        int gap = 10;
        
        int x_offset = (bg.size.width - (headWidth + gap) * avatarArray.count) / 2;
        
        for (UIImage *pic in avatarArray) {
            
            int whichBody = (arc4random() % 5) + 1;
            UIImage *bodyImage = [UIImage imageNamed:[NSString stringWithFormat:@"body%i_1.png", whichBody]];

            if (whichBody == 2) {
                [bodyImage drawInRect:CGRectMake(x_offset + (headWidth + gap) * counter + (headWidth - bodyImage.size.width)/2 + 30, height + pic.size.height - 30, bodyImage.size.width, bodyImage.size.height)];
            } else if (whichBody == 1) {
                [bodyImage drawInRect:CGRectMake(x_offset + (headWidth + gap) * counter + (headWidth - bodyImage.size.width)/2, height + pic.size.height - 60, bodyImage.size.width, bodyImage.size.height)];
            } else {
                [bodyImage drawInRect:CGRectMake(x_offset + (headWidth + gap) * counter + (headWidth - bodyImage.size.width)/2, height + pic.size.height - 10, bodyImage.size.width, bodyImage.size.height)];
            }
            
            [pic drawInRect:CGRectMake(x_offset + (headWidth + gap) * counter, height, headWidth, pic.size.height)];
            
            counter ++;
            height += 12;
        }
        
        UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [vc setPublishedImage:ret];
        [vc setPublishedMsg:sendToFBMsg];
    }
}

@end
