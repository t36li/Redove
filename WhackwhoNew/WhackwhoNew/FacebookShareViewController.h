//
//  FacebookShareViewController.h
//  WhackwhoNew
//
//  Created by chun su on 2012-12-24.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookShareViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *postImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;
@property (strong, nonatomic) UIImage *publishedImage;

@end
