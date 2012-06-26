//
//  AvatarViewController.h
//  WhackwhoNew
//
//  Created by ShaoCheng Xu on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIImageView *imageView;
    IBOutlet UIView *photoView;
    UIImagePickerController *cameraController;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIView *photoView;

@property (nonatomic, retain) UIImagePickerController *cameraController;

-(IBAction) startCamera:(id)sender;

@end
