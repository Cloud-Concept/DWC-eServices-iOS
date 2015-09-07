//
//  CompanyInfoViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoTypeViewController.h"
#import "DWCCompanyInfo.h"
#import "CompanyInfoListViewController.h"
#import "SOQLQueries.h"
#import "RecordMainDetailsViewController.h"
#import "Globals.h"
#import "Account.h"
#import "TableViewSection.h"
#import "TableViewSectionField.h"
#import "HelperClass.h"
#import "License.h"
#import "LicenseActivity.h"
#import "BusinessActivity.h"
#import "RelatedService.h"
#import "SwipePageViewController.h"
#import "UIViewController+ChildViewController.h"
#import "SFRestAPI+Blocks.h"
#import "FVCustomAlertView.h"

@interface CompanyInfoTypeViewController ()

@end

@implementation CompanyInfoTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setNavigationBarTitle:NSLocalizedString(@"navBarCompanyInfoTitle", @"")];
    
    [self loadLicenseRenewInProgress];
}

- (void)loadLicenseRenewInProgress {
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                      Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *record in [dict objectForKey:@"records"]) {
            NSArray *invoicesArray = [record objectForKey:@"Invoices__r"];
            if (![invoicesArray isKindOfClass:[NSNull class]] && invoicesArray.count > 0) {
                hasLicenseRenewalInProgress = YES;
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setSwipeViewDisplay];
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries licenseRenewInProgressQuery:[Globals currentAccount].currentLicenseNumber.Id]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSwipeViewDisplay {
    dwcCompanyInfoTypesArray = [NSMutableArray new];
    
    /*
     [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
     initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoCompany", @"")
     NavBarTitle:NSLocalizedString(@"navBarDWCCompanyInfoCompanyTitle", @"")
     DWCCompanyInfoType:DWCCompanyInfoCompany]];
     
     [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
     initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLicenseInfo", @"")
     NavBarTitle:NSLocalizedString(@"navBarDWCCompanyInfoLicenseInfoTitle", @"")
     DWCCompanyInfoType:DWCCompanyInfoLicenseInfo]];
     */
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLeasingInfo", @"")
                                         NavBarTitle:NSLocalizedString(@"navBarDWCCompanyInfoLeasingInfoTitle", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoLeasingInfo
                                         Query:[SOQLQueries contractsQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoShareholders", @"")
                                         NavBarTitle:NSLocalizedString(@"navBarDWCCompanyInfoShareholdersTitle", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoShareholders
                                         Query:[SOQLQueries companyShareholdersQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoDirectors", @"")
                                         NavBarTitle:NSLocalizedString(@"navBarDWCCompanyInfoDirectorsTitle", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoDirectors
                                         Query:[SOQLQueries companyDirectorsQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoGeneralManagers", @"")
                                         NavBarTitle:NSLocalizedString(@"navBarDWCCompanyInfoGeneralManagersTitle", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoGeneralManagers
                                         Query:[SOQLQueries companyManagersQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLegalRepresentative", @"")
                                         NavBarTitle:NSLocalizedString(@"navBarDWCCompanyInfoLegalRepresentativeTitle", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoLegalRepresentative
                                         Query:[SOQLQueries companyLegalRepresentativesQuery]]];
    
    NSMutableArray *viewControllersMutableArray = [NSMutableArray new];
    NSMutableArray *pageLabelMutableArray = [NSMutableArray new];
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    RecordMainDetailsViewController *companyInfoMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    companyInfoMainVC.isBottomBarHidden = YES;
    
    RecordMainDetailsViewController *licenseInfoMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    licenseInfoMainVC.isBottomBarHidden = YES;
    
    [self configureRecordMainViewController:companyInfoMainVC ForCompany:[Globals currentAccount]];
    [self configureRecordMainViewController:licenseInfoMainVC ForLicense:[Globals currentAccount].currentLicenseNumber Company:[Globals currentAccount]];
    
    [viewControllersMutableArray addObjectsFromArray:@[companyInfoMainVC, licenseInfoMainVC]];
    [pageLabelMutableArray addObjectsFromArray:@[NSLocalizedString(@"DWCCompanyInfoCompany", @""), NSLocalizedString(@"DWCCompanyInfoLicenseInfo", @"")]];
    
    SwipePageViewController *swipePageVC = [SwipePageViewController new];
    for (DWCCompanyInfo *dwcCompanyInfo in dwcCompanyInfoTypesArray) {
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        CompanyInfoListViewController *companyInfoListVC = [storybord instantiateViewControllerWithIdentifier:@"Company Info List Page"];
        companyInfoListVC.currentDWCCompanyInfo = dwcCompanyInfo;
        [viewControllersMutableArray addObject:companyInfoListVC];
        [pageLabelMutableArray addObject:dwcCompanyInfo.Label];
    }
    
    swipePageVC.viewControllerArray = viewControllersMutableArray;
    swipePageVC.pageLabelArray = pageLabelMutableArray;
    
    [self addChildViewController:swipePageVC toView:self.containerView];
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController *)recordVC ForCompany:(Account *)account {
    recordVC.NameValue = account.name;
    recordVC.PhotoId = account.companyLogo;
    recordVC.hideImageNameSection = YES;
    
    NSMutableArray *sectionsArray = [NSMutableArray new];
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"AccountName", @"")
                                                                         FieldValue:account.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"RegistrationDate", @"")
                                                                         FieldValue:[HelperClass formatDateToString:account.companyRegistrationDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"LegalForm", @"")
                                                                         FieldValue:account.legalForm]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"RegistrationNumber", @"")
                                                                         FieldValue:account.registrationNumberValue]];
    
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:NSLocalizedString(@"RegistrationInformation", @"") Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"Phone", @"")
                                                                        FieldValue:account.phone]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"Fax", @"")
                                                                         FieldValue:account.fax]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"Email", @"")
                                                                         FieldValue:account.email]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"Mobile", @"")
                                                                         FieldValue:account.mobile]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"PROEmail", @"")
                                                                         FieldValue:account.proEmail]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"PROMobile", @"")
                                                                         FieldValue:account.proMobileNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"BillingAddress", @"")
                                                                         FieldValue:[account billingAddress]]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:NSLocalizedString(@"ContactInformation", @"") Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    servicesMask |= RelatedServiceTypeNewCompanyNOC;
    servicesMask |= RelatedServiceTypeCompanyAddressChange;
    servicesMask |= RelatedServiceTypeCompanyNameChange;
    
    // added by george
    servicesMask |= RelatedServiceTypeNameReservation;
    servicesMask |= RelatedServiceTypeCapitalChange;


    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController *)recordVC ForLicense:(License *)license Company:(Account *)account{
    recordVC.NameValue = account.name;
    recordVC.PhotoId = account.companyLogo;
    recordVC.hideImageNameSection = YES;
    
    NSMutableArray *sectionsArray = [NSMutableArray new];
    NSMutableArray *fieldsArray = [NSMutableArray new];

    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"CommercialName", @"")
                                                                         FieldValue:license.commercialName]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"LicenseNumber", @"")
                                                                         FieldValue:license.licenseNumberValue]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"IssueDate", @"")
                                                                         FieldValue:[HelperClass formatDateToString:license.licenseIssueDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:NSLocalizedString(@"ExpiryDate", @"")
                                                                         FieldValue:[HelperClass formatDateToString:license.licenseExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:NSLocalizedString(@"LicenseInformation", @"") Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    for (LicenseActivity *licActivity in license.licenseActivityArray) {
        [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:licActivity.originalBusinessActivity.name
                                                                             FieldValue:licActivity.originalBusinessActivity.businessActivityName]];
    }
    
    if (fieldsArray.count > 0) {
        [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:NSLocalizedString(@"ActivityInformation", @"") Fields:fieldsArray]];
    }
    
    recordVC.DetailsSectionsArray = sectionsArray;
    recordVC.licenseObject = license;
    
    
    NSUInteger relatedServices = 0;
    NSTimeInterval daysToExpire = [[Globals currentAccount].currentLicenseNumber.licenseExpiryDate timeIntervalSinceNow] / (3600 * 24);
    
    
    if (daysToExpire <= 60 && !hasLicenseRenewalInProgress) {
        relatedServices |= RelatedServiceTypeLicenseRenewal;
        relatedServices |= RelatedServiceTypeLicenseRenewActivityChange;
    }
    // added By george
    relatedServices |= RelatedServiceTypeLicenseCancelation;
    // george Renew License
    relatedServices |= RelatedServiceTypeLicenseChangeActivityChange;
    
    
    recordVC.RelatedServicesMask = relatedServices;
}

@end
