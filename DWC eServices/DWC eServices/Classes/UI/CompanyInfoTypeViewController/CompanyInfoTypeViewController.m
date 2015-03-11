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
#import "RecordMainViewController.h"
#import "Globals.h"
#import "Account.h"
#import "TableViewSection.h"
#import "TableViewSectionField.h"
#import "HelperClass.h"
#import "License.h"
#import "LicenseActivity.h"
#import "BusinessActivity.h"

@interface CompanyInfoTypeViewController ()

@end

@implementation CompanyInfoTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dwcCompanyInfoTypesArray = [NSMutableArray new];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoCompany", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoCompany]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLicenseInfo", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoLicenseInfo]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLeasingInfo", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoLeasingInfo]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoShareholders", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoShareholders
                                         Query:[SOQLQueries companyShareholdersQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoDirectors", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoDirectors
                                         Query:[SOQLQueries companyDirectorsQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoGeneralManagers", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoGeneralManagers
                                         Query:[SOQLQueries companyManagersQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLegalRepresentative", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoLegalRepresentative
                                         Query:[SOQLQueries companyLegalRepresentativesQuery]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureRecordMainViewController:(RecordMainViewController *)recordVC ForCompany:(Account *)account {
    recordVC.NameValue = account.name;
    
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
    recordVC.RelatedServicesMask = 0;
}

- (void)configureRecordMainViewController:(RecordMainViewController *)recordVC ForLicense:(License *)license Company:(Account *)account{
    recordVC.NameValue = account.name;
    
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
    recordVC.RelatedServicesMask = 0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dwcCompanyInfoTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    DWCCompanyInfo *companyInfoType = [dwcCompanyInfoTypesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = companyInfoType.Label;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DWCCompanyInfo *currentDWCCompanyInfo = [dwcCompanyInfoTypesArray objectAtIndex:indexPath.row];
    
    if (currentDWCCompanyInfo.Type != DWCCompanyInfoCompany && currentDWCCompanyInfo.Type != DWCCompanyInfoLicenseInfo)
        return;
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RecordMainViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    
    
    switch (currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoCompany:
            [self configureRecordMainViewController:recordMainVC ForCompany:[Globals currentAccount]];
            break;
            case DWCCompanyInfoLicenseInfo:
            [self configureRecordMainViewController:recordMainVC ForLicense:[Globals currentAccount].currentLicenseNumber Company:[Globals currentAccount]];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:recordMainVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destinationVC = [segue destinationViewController];
    if ([destinationVC isKindOfClass:[CompanyInfoListViewController class]]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        ((CompanyInfoListViewController*)destinationVC).currentDWCCompanyInfo = [dwcCompanyInfoTypesArray objectAtIndex:selectedIndexPath.row];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    BOOL shouldPerformSegue = YES;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    DWCCompanyInfo *currentDWCCompanyInfo = [dwcCompanyInfoTypesArray objectAtIndex:indexPath.row];
    
    if (currentDWCCompanyInfo.Type == DWCCompanyInfoCompany || currentDWCCompanyInfo.Type == DWCCompanyInfoLicenseInfo)
        shouldPerformSegue = NO;
    
    return shouldPerformSegue;
}

@end
