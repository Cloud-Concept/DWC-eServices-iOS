//
//  CompanyInfoListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListViewController.h"
#import "CompanyInfoListTableViewCell.h"
#import "DWCCompanyInfo.h"
#import "FVCustomAlertView.h"
#import "SFRestAPI+Blocks.h"
#import "RecordMainViewController.h"
#import "Globals.h"
#import "Account.h"
#import "ShareOwnership.h"
#import "ManagementMember.h"
#import "Directorship.h"
#import "LegalRepresentative.h"
#import "TenancyContract.h"
#import "HelperClass.h"
#import "Passport.h"
#import "TableViewSectionField.h"
#import "TableViewSection.h"
#import "RelatedService.h"
#import "TenancyContractPayment.h"
#import "ContractLineItem.h"
#import "InventoryUnit.h"

@interface CompanyInfoListViewController ()

@end

@implementation CompanyInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showSlidingMenu = NO;
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            [self loadCompanyShareholders];
            break;
        case DWCCompanyInfoGeneralManagers:
            [self loadCompanyManagers];
            break;
        case DWCCompanyInfoDirectors:
            [self loadCompanyDirectors];
            break;
        case DWCCompanyInfoLegalRepresentative:
            [self loadCompanyLegalRepresentatives];
            break;
        case DWCCompanyInfoLeasingInfo:
            [self loadTenancyContracts];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCompanyShareholders {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            
            
            [dataRows addObject:[[ShareOwnership alloc] initShareOwnership:recordDict]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
}

- (void)loadCompanyManagers {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            [dataRows addObject:[[ManagementMember alloc] initManagementMember:recordDict]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadCompanyDirectors {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            [dataRows addObject:[[Directorship alloc] initDirectorship:recordDict]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadCompanyLegalRepresentatives {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        for (NSDictionary *recordDict in records) {
            
            [dataRows addObject:[[LegalRepresentative alloc] initLegalRepresentative:recordDict]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadTenancyContracts {    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    SFRestRequest *tenantContractsRequest = [[SFRestRequest alloc] init];
    tenantContractsRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileTenantContractsWebService"];
    tenantContractsRequest.method = SFRestMethodGET;
    tenantContractsRequest.path = @"/services/apexrest/MobileTenantContractsWebService";
    tenantContractsRequest.queryParams = [NSDictionary dictionaryWithObject:[Globals currentAccount].Id forKey:@"AccountId"];
    
    [[SFRestAPI sharedInstance] send:tenantContractsRequest delegate:self];
}

- (UITableViewCell *)cellContractsForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    TenancyContract *currentTenancyContract = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentTenancyContract.name;
    cell.roleLabel.text = NSLocalizedString(@"ExpiryLabel", @"");
    cell.roleValueLabel.text = [HelperClass formatDateToString:currentTenancyContract.contractExpiryDate];
    
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)cellShareholdersForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    ShareOwnership *currentShareOwnership = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentShareOwnership.shareholder.name;
    cell.roleValueLabel.text = @"Shareholder";
    cell.shareOwnershipValueLabel.text = [NSString stringWithFormat:@"%@ %%",[HelperClass formatNumberToString:currentShareOwnership.ownershipOfShare FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]];
    
    return cell;
}

- (UITableViewCell *)cellManagersForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    ManagementMember *currentManagementMember = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentManagementMember.manager.name;
    cell.roleValueLabel.text = currentManagementMember.role;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)cellDirectorsForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    Directorship *currentDirectorship = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentDirectorship.director.name;
    cell.roleValueLabel.text = currentDirectorship.roles;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)cellLegalRepresentativeForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    LegalRepresentative *currentLegalRepresentative = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentLegalRepresentative.legalRepresentative.name;
    cell.roleValueLabel.text = currentLegalRepresentative.role;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForShareholder:(ShareOwnership *)shareOwnership {
    recordVC.NameValue = shareOwnership.shareholder.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderName", @"")
                            FieldValue:shareOwnership.shareholder.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderNationality", @"")
                            FieldValue:shareOwnership.shareholder.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderPassportNumber", @"")
                            FieldValue:shareOwnership.shareholder.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.shareholder.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ShareholderPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    
    NSString *ownershipPercent = [NSString stringWithFormat:@"%@ %%",[HelperClass formatNumberToString:shareOwnership.ownershipOfShare FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderOwnership", @"")
                            FieldValue:ownershipPercent]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderNoOfShare", @"")
                            FieldValue:[HelperClass formatNumberToString:shareOwnership.noOfShares
                                                             FormatStyle:NSNumberFormatterDecimalStyle
                                                   MaximumFractionDigits:2]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.ownershipStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.ownershipEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ShareholderInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForManager:(ManagementMember *)managementMember {
    
    recordVC.NameValue = managementMember.manager.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerName", @"")
                            FieldValue:managementMember.manager.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerNationality", @"")
                            FieldValue:managementMember.manager.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerPassportNumber", @"")
                            FieldValue:managementMember.manager.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.manager.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ManagerPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerRole", @"")
                            FieldValue:managementMember.role]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.managerStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.managerEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ManagerInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForDirector:(Directorship *)directorship {
    
    recordVC.NameValue = directorship.director.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorName", @"")
                            FieldValue:directorship.director.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorNationality", @"")
                            FieldValue:directorship.director.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorPassportNumber", @"")
                            FieldValue:directorship.director.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:directorship.director.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"DirectorPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorRole", @"")
                            FieldValue:directorship.roles]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:directorship.directorshipStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:directorship.directorshipEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"DirectorInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForLegalRepresentative:(LegalRepresentative *)legalRepresentative {
    
    recordVC.NameValue = legalRepresentative.legalRepresentative.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeName", @"")
                            FieldValue:legalRepresentative.legalRepresentative.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeNationality", @"")
                            FieldValue:legalRepresentative.legalRepresentative.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativePassportNumber", @"")
                            FieldValue:legalRepresentative.legalRepresentative.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativePassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:legalRepresentative.legalRepresentative.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"LegalRepresentativePersonalInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeRole", @"")
                            FieldValue:legalRepresentative.role]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:legalRepresentative.legalRepresentativeStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:legalRepresentative.legalRepresentativeEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"LegalRepresentativeInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForLeasingInfo:(TenancyContract *)tenancyContract {
    
    recordVC.NameValue = tenancyContract.name;

    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractName", @"")
                            FieldValue:tenancyContract.contractNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractType", @"")
                            FieldValue:tenancyContract.contractType]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.contractStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractExpireDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.contractExpiryDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractRentStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.rentStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractActivatedDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.activatedDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractDurationYear", @"")
                            FieldValue:[HelperClass formatNumberToString:tenancyContract.contractDurationYear
                                                             FormatStyle:NSNumberFormatterNoStyle
                                                   MaximumFractionDigits:0]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractDurationMonth", @"")
                            FieldValue:tenancyContract.contractDurationMonth]];
    
    NSString *priceString = [HelperClass formatNumberToString:tenancyContract.totalRentPrice
                                                  FormatStyle:NSNumberFormatterDecimalStyle
                                        MaximumFractionDigits:2];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractRentPrice", @"")
                            FieldValue:[NSString stringWithFormat:@"AED %@", priceString]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"TenancyContractInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    for (ContractLineItem *contractLineItem in tenancyContract.contractLineItems) {
        [fieldsArray addObject:[[TableViewSectionField alloc]
                                initTableViewSectionField:NSLocalizedString(@"TenancyContractLineItemUnitName", @"")
                                FieldValue:contractLineItem.inventoryUnit.name]];
    }
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"TenancyContractLeasingUnitDetails", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    for (TenancyContractPayment *tenancyContractPayment in tenancyContract.tenancyContractPayments) {
        NSString *paymentAmountString = [HelperClass formatNumberToString:tenancyContractPayment.paymentAmount
                                                             FormatStyle:NSNumberFormatterDecimalStyle
                                                   MaximumFractionDigits:2];
        NSString *dateString = [HelperClass formatDateToString:tenancyContractPayment.dueDate];
        [fieldsArray addObject:[[TableViewSectionField alloc]
                                initTableViewSectionField:tenancyContractPayment.descriptionPayment
                                FieldValue:[NSString stringWithFormat:@"AED %@ is due on %@", paymentAmountString, dateString]]];
    }
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"TenancyContractUpcomingPayments", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    NSTimeInterval daysToExpire = [tenancyContract.contractExpiryDate timeIntervalSinceNow] / (3600 * 24);
    if (tenancyContract.isBCContract && daysToExpire <= 60)
        servicesMask |= RelatedServiceTypeContractRenewal;
    
    recordVC.RelatedServicesMask = servicesMask;
    
    recordVC.contractObject = tenancyContract;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell;
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            cell = [self cellShareholdersForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoGeneralManagers:
            cell = [self cellManagersForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoDirectors:
            cell = [self cellDirectorsForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoLegalRepresentative:
            cell = [self cellLegalRepresentativeForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoLeasingInfo:
            cell = [self cellContractsForRowAtIndexPath:indexPath tableView:tableView];
            break;
        default:
            break;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RecordMainViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            [self configureRecordMainViewController:recordMainVC ForShareholder:[dataRows objectAtIndex:indexPath.row]];
            break;
        case DWCCompanyInfoGeneralManagers:
            [self configureRecordMainViewController:recordMainVC ForManager:[dataRows objectAtIndex:indexPath.row]];
            break;
        case DWCCompanyInfoDirectors:
            [self configureRecordMainViewController:recordMainVC ForDirector:[dataRows objectAtIndex:indexPath.row]];
            break;
        case DWCCompanyInfoLegalRepresentative:
            [self configureRecordMainViewController:recordMainVC ForLegalRepresentative:[dataRows objectAtIndex:indexPath.row]];
            break;
        case DWCCompanyInfoLeasingInfo:
            [self configureRecordMainViewController:recordMainVC ForLeasingInfo:[dataRows objectAtIndex:indexPath.row]];
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

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", resultsArray);
    
    dataRows = [NSMutableArray new];
    for (NSDictionary *recordDict in resultsArray) {
        [dataRows addObject:[[TenancyContract alloc] initTenancyContract:recordDict]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        
        [self.tableView reloadData];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
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
