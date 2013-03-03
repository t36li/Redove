//
//  FacebookShareViewController.m
//  WhackwhoNew
//
//  Created by chun su on 2012-12-24.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "FacebookShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>


NSString *const kPlaceholderPostMessage = @"This is my WhackWho Avatar![Enter your personalized message here!]";

@interface FacebookShareViewController ()

@end

@implementation FacebookShareViewController
@synthesize postMessageTextView;
@synthesize postImageView;
//@synthesize postNameLabel;
//@synthesize postCaptionLabel;
//@synthesize postDescriptionLabel;
@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;
@synthesize publishedImage;

#pragma mark - Helper methods

- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-60,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,460)];
}


/*
 * This sets up the placeholder text.
 */
- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor blackColor];
}

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
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
             
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           @"MY WHACK WHO HEAD",@"message",
                           @"Whack Who for iOS [testing]", @"name",
                           @"You got WHACK! ", @"caption",
                           @"description....", @"description",
                           nil];
    }   
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Show placeholder text
    [self resetPostMessage];
    // Set up the post information, hard-coded for this sample
    //self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    //self.postCaptionLabel.text = [self.postParams
    //                              objectForKey:@"caption"];
    //[self.postCaptionLabel sizeToFit];
    //self.postDescriptionLabel.text = [self.postParams
    //                                  objectForKey:@"description"];
    //[self.postDescriptionLabel sizeToFit];
    
    // Kick off loading of image data asynchronously so as not
    // to block the UI.
//    self.imageData = [[NSMutableData alloc] init];
//    NSURLRequest *imageRequest = [NSURLRequest
//                                  requestWithURL:
//                                  [NSURL URLWithString:
//                                   [self.postParams objectForKey:@"picture"]]];
//    self.imageConnection = [[NSURLConnection alloc] initWithRequest:
//                            imageRequest delegate:self];
    self.postImageView.image = self.publishedImage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [self setPostMessageTextView:nil];
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

/*
 * A simple way to dismiss the message text view:
 * whenever the user clicks outside the view.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}

#pragma mark - Action methods
- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonAction:(id)sender {
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
    if (![self.postMessageTextView.text
          isEqualToString:kPlaceholderPostMessage] &&
        ![self.postMessageTextView.text isEqualToString:@""]) {
        [self.postParams setObject:self.postMessageTextView.text
                            forKey:@"message"];
    }
    
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

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:nil]) {
        [self resetPostMessage];
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
- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
