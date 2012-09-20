//
//  GlobalMethods.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "GlobalMethods.h"


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

+ (NSString *)generateHashForUIImage:(UIImage *)img {
    unsigned char result[16];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
    CC_MD5([imageData bytes], [imageData length], result);
    NSString *imageHash = [NSString stringWithFormat:
                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return imageHash;
}


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