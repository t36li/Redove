//
//  InBetweenViewController.m
//  WhackwhoNew
//
//  Created by Bob Li on 2013-01-23.
//  Copyright (c) 2013 Waterloo. All rights reserved.
//

#import "InBetweenViewController.h"

#define center_x 189
#define center_y 144

@implementation InBetweenViewController

@synthesize head1, head2, head3, head4;
@synthesize image1, image2, image3, image4;
@synthesize num_of_hits;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [head1 setContentMode:UIViewContentModeScaleAspectFit];
    [head2 setContentMode:UIViewContentModeScaleAspectFit];
    [head3 setContentMode:UIViewContentModeScaleAspectFit];
    [head4 setContentMode:UIViewContentModeScaleAspectFit];

    head1.image = self.image1;
    head2.image = self.image2;
    head3.image = self.image3;
    head4.image = self.image4;
    
    /*
    switch (num_of_hits) {
        case 1:
            [head1 setCenter:CGPointMake(winSize.width/2, winSize.height/2)];
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
    }*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
