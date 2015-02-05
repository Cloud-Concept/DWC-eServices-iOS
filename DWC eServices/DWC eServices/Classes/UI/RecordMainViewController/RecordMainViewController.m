//
//  EmployeeMainViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/1/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RecordMainViewController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "UIView+RoundCorner.h"
#import "UIImageView+SFAttachment.h"
#import "RecordDetailsTableViewController.h"
#import "RecordRelatedViewController.h"

@interface RecordMainViewController ()

@end

@implementation RecordMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showSlidingMenu = NO;
    
    self.employeeNameLabel.text = self.NameValue;
    
    [self.profilePictureImageView loadImageFromSFAttachment:self.PhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView createRoundBorderedWithRadius:3.0 Shadows:NO ClipToBounds:YES];
    
    [self setupPaginationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupPaginationView {
    UIPageViewController *pageController =
    [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                  options:nil];
    
    RKSwipeBetweenViewControllers *navigationController =
    [[RKSwipeBetweenViewControllers alloc]initWithRootViewController:pageController];
    
    RecordDetailsTableViewController *demo = [RecordDetailsTableViewController new];
    demo.SectionsArray = self.DetailsSectionsArray;
    RecordRelatedViewController *demo2 = [RecordRelatedViewController new];
    //demo.view.backgroundColor = [UIColor redColor];
    //demo2.view.backgroundColor = [UIColor whiteColor];
    [navigationController.viewControllerArray addObjectsFromArray:@[demo,demo2]];
    navigationController.buttonText = @[@"DETAILS", @"RELATED"];
    
    
    [self.paginationView addSubview:navigationController.view];
    navigationController.view.frame = self.paginationView.bounds;
    navigationController.view.bounds = self.paginationView.bounds;
    [self addChildViewController:navigationController];
    [navigationController didMoveToParentViewController:self];
    
    [self.view layoutIfNeeded];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
