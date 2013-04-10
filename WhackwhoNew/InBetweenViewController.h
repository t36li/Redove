//
//  InBetweenViewController.h
//  WhackwhoNew
//
//  Created by Bob Li on 2013-01-23.
//  Copyright (c) 2013 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InBetweenViewController : UIViewController {
    IBOutlet UIImageView *head1, *head2, *head3, *head4;
    UIImage *image1, *image2, *image3, *image4;
    int num_of_hits;
}
@property (nonatomic, strong) IBOutlet UIImageView *head1;
@property (nonatomic, strong) IBOutlet UIImageView *head2;
@property (nonatomic, strong) IBOutlet UIImageView *head3;
@property (nonatomic, strong) IBOutlet UIImageView *head4;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property (nonatomic, strong) UIImage *image4;


@end
