//
//  GlobalMethods.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "GlobalMethods.h"
#import "UserInfo.h"

@implementation GlobalMethods

@synthesize responseData;

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



-(void)RKInit{
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://localhost/PhpProject1/rest"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    //objectManager.client.requestQueue.delegate = self;
    //objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    RKObjectMapping *userInfoMapping = [RKObjectMapping mappingForClass:[UserInfo class]];
    [userInfoMapping mapKeyPath:@"ID" toAttribute:@""];
    
    
    [objectManager.mappingProvider setMapping:userInfoMapping forKeyPath:@""];

}

@end