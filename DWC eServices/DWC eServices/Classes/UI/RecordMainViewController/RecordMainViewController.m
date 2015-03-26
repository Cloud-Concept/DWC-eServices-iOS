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
#import "BaseServicesViewController.h"
#import "NewNOCViewController.h"
#import "ContractRenewalEditViewController.h"

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    RecordDetailsTableViewController *recordDetailsVC = [RecordDetailsTableViewController new];
    recordDetailsVC.SectionsArray = self.DetailsSectionsArray;
    RecordRelatedViewController *recordRelatedVC = [RecordRelatedViewController new];
    recordRelatedVC.RelatedServicesMask = self.RelatedServicesMask;
    recordRelatedVC.delegate = self;
    
    [navigationController.viewControllerArray addObjectsFromArray:@[recordDetailsVC, recordRelatedVC]];
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

#pragma mark - RecordRelatedViewControllerDelegate

- (void)relatedServiceNewNOCButtonClicked {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeNewNOC;
    baseServicesVC.currentVisaObject = self.visaObject;
    baseServicesVC.createServiceRecord = YES;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)relatedServiceNewCardButtonClicked {
    
}

- (void)relatedServiceRenewCardButtonClicked {
    
}

- (void)relatedServiceCancelCardButtonClicked {
    
}

- (void)relatedServiceReplaceCardButtonClicked {
    
}

- (void)relatedServiceNewVisaButtonClicked {
    
}

- (void)relatedServiceRenewVisaButtonClicked {
    
}

- (void)relatedServiceCancelVisaButtonClicked {
    
}

- (void)relatedServiceContractRenewalButtonClicked {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeContractRenewal;
    baseServicesVC.currentContract = self.contractObject;
    baseServicesVC.createServiceRecord = YES;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

@end
