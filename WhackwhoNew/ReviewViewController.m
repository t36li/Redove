//
//  ReviewViewController.m
//  WhackwhoNew
//
//  Created by Peter on 2012-10-11.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

@synthesize portraitView, backBtn, uploadBtn, leftBtn, rightBtn, avatarImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSArray *images = [[Game sharedGame] arrayOfAllPopups];
    for (UIImage *img in images) {
        if (img != defaultImage) {
            [avatarArray addObject:img];
        }
    }
    if (avatarArray.count > 0) {
        self.avatarImageView.image = [avatarArray objectAtIndex:0];
        selectedIndex = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    avatarArray = [[NSMutableArray alloc] init];
    defaultImage = [UIImage imageNamed:@"vlad.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hitBack:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
}

-(IBAction) hitLeft:(id)sender {
    if (selectedIndex > 0) {
        selectedIndex --;
        self.avatarImageView.image = [avatarArray objectAtIndex:selectedIndex];
    }
}

-(IBAction) hitRight:(id)sender {
    if (selectedIndex < avatarArray.count - 1) {
        selectedIndex ++;
        self.avatarImageView.image = [avatarArray objectAtIndex:selectedIndex];
    }
}
@end
