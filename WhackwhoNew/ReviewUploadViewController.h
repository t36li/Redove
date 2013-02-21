//
//  ReviewUploadViewController.h
//  WhackwhoNew
//
//  Created by Peter on 2013-02-19.
//  Copyright (c) 2013 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewUploadViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *postImageView;
//@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postNameLabel;
//@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postCaptionLabel;
//@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;
@property (strong, nonatomic) UIImage *publishedImage;

@end
