//
//  EmployeeListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "EmployeeListViewController.h"
#import "DWCEmployee.h"
#import "SFRestAPI+Blocks.h"
#import "Account.h"
#import "Visa.h"
#import "HelperClass.h"
#import "Country.h"
#import "Occupation.h"
#import "RecordType.h"
#import "CardManagement.h"
#import "RecordMainViewController.h"
#import "TableViewSection.h"
#import "TableViewSectionField.h"
#import "RelatedService.h"
#import "BaseServicesViewController.h"
#import "PickerTableViewController.h"

@interface EmployeeListViewController ()

@end

@implementation EmployeeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[super setNavigationBarTitle:self.currentDWCEmployee.NavBarTitle];
    
    self.showSlidingMenu = NO;
    searchBarText = @"";
    
    [self initializeFilterStringArray];
    
    [self initializeSearchBar];
    [self initializeNewButton];
    
    [self.employeesTableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.employeesTableView.queryLimit = 15;
    
    [self.employeesTableView triggerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewButtonClicked:(id)sender {
    RelatedServiceType relatedServiceType;
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
        case VisitVisaEmployee:
            break;
        case ContractorEmployee:
            relatedServiceType = RelatedServiceTypeNewCard;
            break;
        default:
            break;
    }
    [self openNewServiceFlow:relatedServiceType];
}

- (IBAction)filterButtonClicked:(id)sender {
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = filterStringArray;
    pickerTableVC.selectedIndexPath = selectedFilterIndexPath;
    pickerTableVC.valuePicked = ^(NSString * value, NSIndexPath * indexPath, PickerTableViewController *picklist) {
        selectedFilterIndexPath = indexPath;
        selectedFilter = value;
        [self refreshFilterButton];
        [picklist dismissPopover:YES];
        [self refreshEmployeesTable];
    };
    
    [pickerTableVC showPopoverFromView:sender];
}

- (void)initializeFilterStringArray {
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
            filterStringArray = [NSArray arrayWithObjects:@"All", @"Issued", @"Expired", @"Cancelled", @"Under Process", @"Under Renewal", nil];
            selectedFilter = @"Issued";
            selectedFilterIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            break;
        case VisitVisaEmployee:
            filterStringArray = [NSArray arrayWithObjects:@"All", @"Issued", @"Expired", @"Cancelled", @"Under Process", nil];
            selectedFilter = @"Issued";
            selectedFilterIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            break;
        case ContractorEmployee:
            filterStringArray = [NSArray arrayWithObjects:@"All", @"Draft", @"Active", @"Expired", nil];
            selectedFilter = @"Active";
            selectedFilterIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            break;
        default:
            break;
    }
    [self refreshFilterButton];
}

- (void)initializeSearchBar {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.showsScopeBar = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[@""];
    
    self.employeesTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

- (void)initializeNewButton {
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
        case VisitVisaEmployee:
            hideNewButton = YES;
            break;
        case ContractorEmployee:
            hideNewButton = NO;
            break;
        default:
            hideNewButton = YES;
            break;
    }
    
    if (hideNewButton)
        [self.addNewButton removeFromSuperview];
}

- (void)refreshFilterButton {
    [self.filterButton setTitle:selectedFilter forState:UIControlStateNormal];
}

- (void)openNewServiceFlow:(RelatedServiceType)relatedServiceType {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = relatedServiceType;
    //baseServicesVC.currentVisaObject = self.visaObject;
    baseServicesVC.createServiceRecord = YES;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)loadEmployeesRefresh:(BOOL)isRefresh {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.employeesTableView finishRefresh];
            else
                [self.employeesTableView finishLoadMore];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        if (isRefresh)
            dataRows = [NSArray new];
        
        NSMutableArray *employeesMutableArray = [NSMutableArray arrayWithArray:dataRows];
        
        for (NSDictionary *recordDict in records) {
            switch (self.currentDWCEmployee.Type) {
                case PermanentEmployee:
                case VisitVisaEmployee:
                    [employeesMutableArray addObject:[[Visa alloc] initVisa:recordDict]];
                    break;
                case ContractorEmployee:
                    [employeesMutableArray addObject:[[CardManagement alloc] initCardManagement:recordDict]];
                    break;
                default:
                    break;
            }
        }
        
        dataRows = [NSArray arrayWithArray:employeesMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.employeesTableView finishRefresh];
            else
                [self.employeesTableView finishLoadMore];
            
            [self refreshEmployeesTable];
        });
    };
    
    restRequest = [[SFRestAPI sharedInstance] performSOQLQuery:[NSString stringWithFormat:self.currentDWCEmployee.SOQLQuery,
                                                                self.employeesTableView.queryLimit, self.employeesTableView.queryOffset]
                                                     failBlock:errorBlock
                                                 completeBlock:successBlock];
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForPermanentEmployee:(Visa*)visa {
    recordVC.visaObject = visa;
    recordVC.NameValue = visa.applicantFullName;
    recordVC.PhotoId = visa.personalPhotoId;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Employee ID"
                                                                         FieldValue:visa.employeeID]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Gender"
                                                                         FieldValue:visa.applicantGender]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Birth Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.dateOfBirth]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Mobile"
                                                                         FieldValue:visa.applicantMobileNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Email"
                                                                         FieldValue:visa.applicantEmail]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Employee Information" Fields:fieldsArray]];
    
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Visa Number"
                                                                         FieldValue:visa.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Status"
                                                                         FieldValue:visa.validityStatus]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expiry"
                                                                         FieldValue:[HelperClass formatDateToString:visa.expiryDate]]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Visa Information" Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Passport"
                                                                         FieldValue:visa.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expriry Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.passportExpiry]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Issue Country"
                                                                         FieldValue:visa.passportCountry]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Passport Information" Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    if ([visa.validityStatus isEqualToString:@"Issued"])
        servicesMask |= RelatedServiceTypeNewEmoloyeeNOC;
    
    /*
    if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"]) {
        servicesMask |= RelatedServiceTypeRenewVisa;
        servicesMask |= RelatedServiceTypeCancelVisa;
    }
    */
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForVisitVisa:(Visa*)visa {
    recordVC.NameValue = visa.applicantFullName;
    recordVC.PhotoId = visa.personalPhotoId;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Gender"
                                                                         FieldValue:visa.applicantGender]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Birth Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.dateOfBirth]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Mobile"
                                                                         FieldValue:visa.applicantMobileNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Email"
                                                                         FieldValue:visa.applicantEmail]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Employee Information" Fields:fieldsArray]];
    
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Visa Number"
                                                                         FieldValue:visa.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Status"
                                                                         FieldValue:visa.validityStatus]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expiry"
                                                                         FieldValue:[HelperClass formatDateToString:visa.expiryDate]]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Visa Information" Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Passport"
                                                                         FieldValue:visa.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expriry Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.passportExpiry]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Issue Country"
                                                                         FieldValue:visa.passportCountry]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Passport Information" Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    /*
    if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"])
        servicesMask |= RelatedServiceTypeCancelVisa;
    */
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForContractor:(CardManagement*)card {
    recordVC.NameValue = card.fullName;
    recordVC.PhotoId = card.personalPhoto;
    recordVC.cardManagementObject = card;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Card Number"
                                                                         FieldValue:card.cardNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Type"
                                                                         FieldValue:card.cardType]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expiry Date"
                                                                         FieldValue:[HelperClass formatDateToString:card.cardExpiryDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Status"
                                                                         FieldValue:card.status]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Card Details" Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Passport Number"
                                                                         FieldValue:card.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Nationality"
                                                                         FieldValue:card.nationality.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Designation"
                                                                         FieldValue:card.designation]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Sponsor Company"
                                                                         FieldValue:card.sponsor]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Person Details" Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    if ([card.status isEqualToString:@"Active"]) {
        servicesMask |= RelatedServiceTypeReplaceCard;
        servicesMask |= RelatedServiceTypeCancelCard;
    }
    
    NSTimeInterval daysToExpire = [card.cardExpiryDate timeIntervalSinceNow] / (3600 * 24);
    
    if (([card.status isEqualToString:@"Active"] && daysToExpire <= 7) || [card.status isEqualToString:@"Expired"]) {
        servicesMask |= RelatedServiceTypeRenewCard;
        
    }
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)refreshEmployeesTable {
    selectedRowIndexPath = nil;
    
    NSString *predicateString = [self getPredicateString];
    
    if ([predicateString isEqualToString:@""]) {
        filteredEmployeesArray = [NSMutableArray arrayWithArray:dataRows];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        filteredEmployeesArray = [NSMutableArray arrayWithArray:[dataRows filteredArrayUsingPredicate:predicate]];
    }
    
    [self.employeesTableView reloadData];
}

- (NSString *)getPredicateString {
    NSMutableString *predicateString = [NSMutableString new];
    NSString *statusFilter = @"";
    NSString *nameFilter = @"";
    
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
        case VisitVisaEmployee:
            statusFilter = [NSString stringWithFormat:@"validityStatus == '%@'", selectedFilter];
            nameFilter = [NSString stringWithFormat:@"applicantFullName contains[c] '%@'", searchBarText];
            break;
        case ContractorEmployee:
            statusFilter = [NSString stringWithFormat:@"status == '%@'", selectedFilter];
            nameFilter = [NSString stringWithFormat:@"fullName contains[c] '%@'", searchBarText];
            break;
        default:
            break;
    }
    
    if (![selectedFilter isEqualToString:@"All"])
        predicateString = [NSMutableString stringWithString:statusFilter];
    
    if (![searchBarText isEqualToString:@""]) {
        if ([predicateString isEqualToString:@""])
            predicateString = [NSMutableString stringWithString:nameFilter];
        else
            predicateString = [NSMutableString stringWithFormat:@"%@ AND %@", predicateString, nameFilter];
    }
    
    return predicateString;
}

- (void)tableLoadMore {
    self.employeesTableView.queryOffset += self.employeesTableView.queryLimit;
    [self loadEmployeesRefresh:NO];
}

- (void)tableRefresh {
    self.employeesTableView.queryOffset = 0;
    [self loadEmployeesRefresh:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return filteredEmployeesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"EmployeeTableViewCell";
    
    if (selectedRowIndexPath &&
        selectedRowIndexPath.row == indexPath.row &&
        selectedRowIndexPath.section == indexPath.section)
        cellIdentifier = @"EmployeeExpandedTableViewCell";
    
    EmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    NSObject *selectedObject = [filteredEmployeesArray objectAtIndex:indexPath.row];
    
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
        case VisitVisaEmployee:
            [cell refreshCellForVisa:(Visa *)selectedObject employeeType:self.currentDWCEmployee.Type indexPath:indexPath];
            break;
        case ContractorEmployee:
            [cell refreshCellForCard:(CardManagement *)selectedObject employeeType:self.currentDWCEmployee.Type indexPath:indexPath];
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* rows = [NSMutableArray arrayWithCapacity:2];

    if (selectedRowIndexPath)
        [rows addObject:selectedRowIndexPath];
    
    if (selectedRowIndexPath &&
        selectedRowIndexPath.row == indexPath.row &&
        selectedRowIndexPath.section == indexPath.section)
        selectedRowIndexPath = nil;
    else {
        selectedRowIndexPath = indexPath;
        [rows addObject:indexPath];
    }

    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedRowIndexPath &&
        selectedRowIndexPath.row == indexPath.row &&
        selectedRowIndexPath.section == indexPath.section)
        return 132;
    else
        return 70;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - EmployeeTableViewCell delegate
- (void)employeeTableViewCell:(EmployeeTableViewCell *)employeeTableViewCell detailsButtonClickAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RecordMainViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    NSObject *selectedItem = [filteredEmployeesArray objectAtIndex:indexPath.row];
    
    recordMainVC.NavBarTitle = self.currentDWCEmployee.NavBarTitle;
    
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
            [self configureRecordMainViewController:recordMainVC ForPermanentEmployee:(Visa *)selectedItem];
            break;
        case VisitVisaEmployee:
            [self configureRecordMainViewController:recordMainVC ForVisitVisa:(Visa *)selectedItem];
            break;
        case ContractorEmployee:
            [self configureRecordMainViewController:recordMainVC ForContractor:(CardManagement *)selectedItem];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:recordMainVC animated:YES];
}

#pragma mark - UISearchResultsUpdating delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    searchBarText = searchController.searchBar.text;
    [self refreshEmployeesTable];
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


@end
