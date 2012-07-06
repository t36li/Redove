//
//  GlobalMethods.m
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "GlobalMethods.h"

@implementation GlobalMethods

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
@end