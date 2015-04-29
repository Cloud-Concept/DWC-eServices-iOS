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
#import "SFRestAPI+Blocks.h"
#import "RecordMainDetailsViewController.h"
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
#import "CompanyInfoListBaseTableViewCell.h"
#import "RelatedServicesBarScrollView.h"

@interface CompanyInfoListViewController ()

@end

@implementation CompanyInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[super setNavigationBarTitle:self.currentDWCCompanyInfo.NavBarTitle];
    
    //self.showSlidingMenu = NO;
    
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.tableView.queryLimit = 15;
    
    [self.tableView triggerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRecordsRefresh:(BOOL)isRefresh {
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
        case DWCCompanyInfoGeneralManagers:
        case DWCCompanyInfoDirectors:
        case DWCCompanyInfoLegalRepresentative:
            [self loadCompanyRefresh:isRefresh];
            break;
        case DWCCompanyInfoLeasingInfo:
            [self loadTenancyContractsRefresh:isRefresh];
            break;
        default:
            break;
    }
}

- (void)loadCompanyRefresh:(BOOL)isRefresh {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        if (isRefresh)
            dataRows = [NSArray new];
        
        NSMutableArray *dataMutableArray = [NSMutableArray arrayWithArray:dataRows];
        
        for (NSDictionary *recordDict in records) {
            switch (self.currentDWCCompanyInfo.Type) {
                case DWCCompanyInfoShareholders:
                    [dataMutableArray addObject:[[ShareOwnership alloc] initShareOwnership:recordDict]];
                    break;
                case DWCCompanyInfoGeneralManagers:
                    [dataMutableArray addObject:[[ManagementMember alloc] initManagementMember:recordDict]];
                    break;
                case DWCCompanyInfoDirectors:
                    [dataMutableArray addObject:[[Directorship alloc] initDirectorship:recordDict]];
                    break;
                case DWCCompanyInfoLegalRepresentative:
                    [dataMutableArray addObject:[[LegalRepresentative alloc] initLegalRepresentative:recordDict]];
                    break;
                default:
                    break;
            }
        }
        
        dataRows = [NSArray arrayWithArray:dataMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
            
            [self.tableView reloadData];
        });
    };
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[NSString stringWithFormat:self.currentDWCCompanyInfo.SOQLQuery,
                                                  self.tableView.queryLimit, self.tableView.queryOffset]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
}

- (void)loadTenancyContractsRefresh:(BOOL)isRefresh {
    restRequest = [[SFRestRequest alloc] init];
    restRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileTenantContractsWebService"];
    restRequest.method = SFRestMethodGET;
    restRequest.path = @"/services/apexrest/MobileTenantContractsWebService";
    
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjects:@[[Globals currentAccount].Id, [NSNumber numberWithInteger:self.tableView.queryLimit], [NSNumber numberWithInteger:self.tableView.queryOffset]]
                                                            forKeys:@[@"AccountId", @"Limit", @"Offset"]];
    
    restRequest.queryParams = paramsDict;
    
    [[SFRestAPI sharedInstance] send:restRequest delegate:self];
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForShareholder:(ShareOwnership *)shareOwnership {
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

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForManager:(ManagementMember *)managementMember {
    
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

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForDirector:(Directorship *)directorship {
    
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

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForLegalRepresentative:(LegalRepresentative *)legalRepresentative {
    
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

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForLeasingInfo:(TenancyContract *)tenancyContract {
    
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

- (void)tableLoadMore {
    self.tableView.queryOffset += self.tableView.queryLimit;
    [self loadRecordsRefresh:NO];
}

- (void)tableRefresh {
    self.tableView.queryOffset = 0;
    [self loadRecordsRefresh:YES];
}

- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath {
    return expandedRowIndexPath && expandedRowIndexPath.row == indexPath.row && expandedRowIndexPath.section == indexPath.section;
}

#pragma mark - EmployeeTableViewCell delegate
- (void)companyTableViewCell:(CompanyInfoListBaseTableViewCell *)companyTableViewCell detailsButtonClickAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RecordMainDetailsViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    
    recordMainVC.NavBarTitle = self.currentDWCCompanyInfo.NavBarTitle;
    
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
    NSMutableString *cellIdentifier = [NSMutableString new];
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            [cellIdentifier appendString:@"CompanyInfoListShareholderCell"];
            break;
        case DWCCompanyInfoLeasingInfo:
            [cellIdentifier appendString:@"CompanyInfoListLeasingCell"];
            break;
        case DWCCompanyInfoGeneralManagers:
        case DWCCompanyInfoDirectors:
        case DWCCompanyInfoLegalRepresentative:
            [cellIdentifier appendString:@"CompanyInfoListCell"];
            break;
        default:
            break;
    }
    
    if ([self isIndexPathExpanded:indexPath])
        [cellIdentifier appendString:@"Expanded"];
        
    
    CompanyInfoListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.parentViewController = self;
    cell.delegate = self;
    
    [cell refreshCellForObject:[dataRows objectAtIndex:indexPath.row]
               companyInfoType:self.currentDWCCompanyInfo.Type
                     indexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* rows = [NSMutableArray arrayWithCapacity:2];
    
    if (expandedRowIndexPath)
        [rows addObject:expandedRowIndexPath];
    
    if ([self isIndexPathExpanded:indexPath])
        expandedRowIndexPath = nil;
    else {
        expandedRowIndexPath = indexPath;
        [rows addObject:indexPath];
    }
    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 95;
    
    if (self.currentDWCCompanyInfo.Type == DWCCompanyInfoShareholders) {
        rowHeight = 110;
    }
    
    if ([self isIndexPathExpanded:indexPath]) {
        rowHeight += kRelatedServicesScrollViewHeight;
    }
    
    return rowHeight;
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
    
    NSMutableArray *dataMutableArray = [NSMutableArray new];
    for (NSDictionary *recordDict in resultsArray) {
        [dataMutableArray addObject:[[TenancyContract alloc] initTenancyContract:recordDict]];
    }
    
    dataRows = [NSArray arrayWithArray:dataMutableArray];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
        
        [self.tableView reloadData];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
    });
}


#pragma mark - Table view Drag Load
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView {
    [self tableRefresh];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView {
    [restRequest cancel];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView {
    [self tableLoadMore];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView {
    [restRequest cancel];
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
