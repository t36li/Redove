//
//  GlobalMethods.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "GlobalMethods.h"

@implementation GlobalMethods

@synthesize responseData, delegate;

-(void) setViewBackground:(NSString *)BackgroundImage viewSender:(id)sender{
    UIView *theView = sender;
    int width;
    int height;
    if (theView){
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        
            width = theView.frame.size.height;
            height = theView.frame.size.width;
        }else {
            width = theView.frame.size.width;
            height = theView.frame.size.height;
        }
        UIGraphicsBeginImageContext(CGSizeMake(width,height));
        [[UIImage imageNamed:BackgroundImage] drawInRect:CGRectMake(0, 0, width, height)];
        UIImage *BgImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        theView.backgroundColor = [UIColor colorWithPatternImage:BgImg];
        NSLog(@"Background loaded");
    }
}

/*
 * Helper method to return the picture endpoint for a given Facebook
 * object. Useful for displaying user, friend, or location pictures.
 */

/*
+ (UIImage *)imageForObject:(NSString *)objectID {
    // Get the object image
    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return image;
}
*/

-(void) RequestProfilePic:(NSString *)profileID
{
    NSString *formatting = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", profileID];        
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:formatting] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData that will hold
        // the received data
        // receivedData is declared as a method instance elsewhere
        responseData=[[NSMutableData data] retain];
    } else {
        // inform the user that the download could not be made
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [responseData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    
    UIImage *image = [UIImage imageWithData:responseData];
    [delegate FBProfilePictureLoaded:image];
    // release the connection, and the data object
    [connection release];
    [responseData release];
}

@end