//
//  ReviewUploadViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2013-02-19.
//  Copyright (c) 2013 Waterloo. All rights reserved.
//


#import "ReviewUploadViewController.h"
#import <FacebookSDK.h>

@interface ReviewUploadViewController ()

@end

@implementation ReviewUploadViewController
@synthesize postImageView;
//@synthesize postNameLabel;
//@synthesize postCaptionLabel;
//@synthesize postDescriptionLabel;
@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;
@synthesize publishedImage;


/*
 * Publish the story
 */
- (void)publishStory
{
    [self.postParams setObject:UIImagePNGRepresentation(self.publishedImage) forKey:@"picture"];
    [FBRequestConnection
     startWithGraphPath:@"me/photos"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d", error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:@"Posted action, id: %@", [result objectForKey:@"id"]];
             
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.postImageView.image = self.publishedImage;
    
    self.postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       @"MY WHACK WHO HEAD",@"message",
                       @"Whack Who for iOS [testing]", @"name",
                       @"You got WHACK! ", @"caption",
                       @"description....", @"description",
                       nil];
}

- (void)viewDidUnload
{
    [self setPostImageView:nil];
    //[self setPostNameLabel:nil];
    //[self setPostCaptionLabel:nil];
    //[self setPostDescriptionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //    if (self.imageConnection) {
    //        [self.imageConnection cancel];
    //        self.imageConnection = nil;
    //    }
}


#pragma mark - Action methods
- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonAction:(id)sender {
    
    // Add user message parameter if user filled it in
    [self.postParams setObject:@"Got Whacked!"
                            forKey:@"message"];

    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

#pragma mark - UIAlertViewDelegate methods
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 5] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
