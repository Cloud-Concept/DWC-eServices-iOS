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
    self.showBottomTabBar = !self.isBottomBarHidden;
    
    [super setNavigationBarTitle:self.NavBarTitle];
    
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
    
    NSMutableArray *pagesArray = [NSMutableArray new];
    NSMutableArray *pagesTitleArray = [NSMutableArray new];
    
    RecordDetailsTableViewController *recordDetailsVC = [RecordDetailsTableViewController new];
    recordDetailsVC.SectionsArray = self.DetailsSectionsArray;
    [pagesArray addObject:recordDetailsVC];
    [pagesTitleArray addObject:NSLocalizedString(@"RecordMainRecordDetialsTitle", @"")];
    
    RecordRelatedViewController *recordRelatedVC = [RecordRelatedViewController new];
    recordRelatedVC.RelatedServicesMask = self.RelatedServicesMask;
    recordRelatedVC.delegate = self;
    if (self.RelatedServicesMask != 0 ) {
        [pagesArray addObject:recordRelatedVC];
        [pagesTitleArray addObject:NSLocalizedString(@"RecordMainRecordRelatedServicesTitle", @"")];
    }
    
    [navigationController.viewControllerArray addObjectsFromArray:pagesArray];
    navigationController.buttonText = pagesTitleArray;
    
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

- (void)openNewNOCFlow:(RelatedServiceType)serviceType {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = serviceType;
    baseServicesVC.currentVisaObject = self.visaObject;
    baseServicesVC.createServiceRecord = YES;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)openCardManagementFlow:(RelatedServiceType)serviceType CreateServiceRecord:(BOOL)CreateServiceRecord {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = serviceType;
    baseServicesVC.currentCardManagement = self.cardManagementObject;
    baseServicesVC.createServiceRecord = CreateServiceRecord;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
    
}

#pragma mark - RecordRelatedViewControllerDelegate

- (void)relatedServiceNewEmployeeNOCButtonClicked {
    [self openNewNOCFlow:RelatedServiceTypeNewEmoloyeeNOC];
}

- (void)relatedServiceNewCompanyNOCButtonClicked {
    [self openNewNOCFlow:RelatedServiceTypeNewCompanyNOC];
}

- (void)relatedServiceNewCardButtonClicked {
    
}

- (void)relatedServiceRenewCardButtonClicked {
    [self openCardManagementFlow:RelatedServiceTypeRenewCard CreateServiceRecord:YES];
}

- (void)relatedServiceCancelCardButtonClicked {
    [self openCardManagementFlow:RelatedServiceTypeCancelCard CreateServiceRecord:NO];
}

- (void)relatedServiceReplaceCardButtonClicked {
    [self openCardManagementFlow:RelatedServiceTypeReplaceCard CreateServiceRecord:YES];
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
    baseServicesVC.createServiceRecord = NO;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)relatedServiceLicenseRenewalButtonClicked {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeLicenseRenewal;
    baseServicesVC.currentLicense = self.licenseObject;
    baseServicesVC.createServiceRecord = NO;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

@end
