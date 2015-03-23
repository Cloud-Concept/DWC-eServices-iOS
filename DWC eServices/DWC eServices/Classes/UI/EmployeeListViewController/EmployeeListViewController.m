//
//  EmployeeListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "EmployeeListViewController.h"
#import "DWCEmployee.h"
#import "FVCustomAlertView.h"
#import "SFRestAPI+Blocks.h"
#import "Account.h"
#import "Visa.h"
#import "EmployeeTableViewCell.h"
#import "EmployeeTableViewCell.h"
#import "HelperClass.h"
#import "Country.h"
#import "Occupation.h"
#import "RecordType.h"
#import "CardManagement.h"
#import "UIImageView+SFAttachment.h"
#import "UIView+RoundCorner.h"
#import "RecordMainViewController.h"
#import "TableViewSection.h"
#import "TableViewSectionField.h"
#import "RelatedService.h"
#import "BaseServicesViewController.h"

@interface EmployeeListViewController ()

@end

@implementation EmployeeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showSlidingMenu = NO;
    
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
        case VisitVisaEmployee:
            [self loadVisaEmployees];
            break;
        case ContractorEmployee:
            [self loadContactorEmployees];
            break;
        default:
            break;
    }
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

- (void)openNewServiceFlow:(RelatedServiceType)relatedServiceType {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = relatedServiceType;
    //baseServicesVC.currentVisaObject = self.visaObject;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)loadVisaEmployees {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
            
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *dict in records) {
            
            [dataRows addObject:[[Visa alloc] initVisa:dict]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.employeesTableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCEmployee.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadContactorEmployees {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
            
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            [dataRows addObject:[[CardManagement alloc] initCardManagement:recordDict]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
                [self.employeesTableView reloadData];
            });
        }
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCEmployee.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (UITableViewCell *)cellVisaEmployeesForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView {
    EmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeTableViewCell"];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EmployeeTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    Visa *currentVisa = [dataRows objectAtIndex:indexPath.row];
    
    cell.employeeNameLabel.text = currentVisa.applicantFullName;
    
    cell.rowOneLabel.text = @"Status";
    cell.rowOneValueLabel.text = currentVisa.validityStatus;
    
    [cell.profilePictureImageView loadImageFromSFAttachment:currentVisa.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [cell.profilePictureImageView createRoundBorderedWithRadius:3.0 Shadows:NO ClipToBounds:YES];
    
    if ([currentVisa.validityStatus isEqualToString:@"Issued"] || [currentVisa.validityStatus isEqualToString:@"Expired"]) {
        cell.rowTwoValueLabel.text = [HelperClass formatDateToString:currentVisa.expiryDate];
        cell.rowTwoValueLabel.hidden = NO;
        cell.rowTwoLabel.text = @"Expiry";
        cell.rowTwoLabel.hidden = NO;
    }
    else {
        cell.rowTwoLabel.hidden = YES;
        cell.rowTwoValueLabel.hidden = YES;
    }
    
    return cell;
}

- (UITableViewCell *)cellContractorEmployeesForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView {
    EmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeTableViewCell"];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EmployeeTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    CardManagement *currentCard = [dataRows objectAtIndex:indexPath.row];
    
    cell.employeeNameLabel.text = currentCard.fullName;
    cell.rowOneLabel.text = @"Type";
    cell.rowOneValueLabel.text = currentCard.cardType;
    
    [cell.profilePictureImageView loadImageFromSFAttachment:currentCard.personalPhoto
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [cell.profilePictureImageView createRoundBorderedWithRadius:3.0 Shadows:NO ClipToBounds:YES];
    
    if (currentCard.cardExpiryDate) {
        cell.rowTwoLabel.hidden = NO;
        cell.rowTwoLabel.text = @"Expiry";
        cell.rowTwoValueLabel.hidden = NO;
        cell.rowTwoValueLabel.text = [HelperClass formatDateToString:currentCard.cardExpiryDate];
    }
    else {
        cell.rowTwoLabel.hidden = YES;
        cell.rowTwoValueLabel.hidden = YES;
    }
    
    return cell;
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
        servicesMask |= RelatedServiceTypeNewNOC;
    
    if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"]) {
        servicesMask |= RelatedServiceTypeRenewVisa;
        servicesMask |= RelatedServiceTypeCancelVisa;
    }
    
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
    
    if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"])
        servicesMask |= RelatedServiceTypeCancelVisa;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForContractor:(CardManagement*)card {
    recordVC.NameValue = card.fullName;
    recordVC.PhotoId = card.personalPhoto;
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
    if ([card.status isEqualToString:@"Active"])
        servicesMask |= RelatedServiceTypeReplaceCard;
    
    if ([card.status isEqualToString:@"Active"] || [card.status isEqualToString:@"Expired"]) {
        servicesMask |= RelatedServiceTypeRenewCard;
        servicesMask |= RelatedServiceTypeCancelCard;
    }
    
    recordVC.RelatedServicesMask = servicesMask;
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
    UITableViewCell *cell;
    
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
        case VisitVisaEmployee:
            cell = [self cellVisaEmployeesForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case ContractorEmployee:
            cell = [self cellContractorEmployeesForRowAtIndexPath:indexPath tableView:tableView];
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
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RecordMainViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
            [self configureRecordMainViewController:recordMainVC ForPermanentEmployee:[dataRows objectAtIndex:indexPath.row]];
            break;
        case VisitVisaEmployee:
            [self configureRecordMainViewController:recordMainVC ForVisitVisa:[dataRows objectAtIndex:indexPath.row]];
            break;
        case ContractorEmployee:
            [self configureRecordMainViewController:recordMainVC ForContractor:[dataRows objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:recordMainVC animated:YES];
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 return 30.0f;
 }
 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
 //get the section object for the current section
 //SectionObject *section = [_helperDataSource sectionObjectForSection:section];
 
 NSString *title = @"%@ (%d)";
 
 return @"Test";
 }
 
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
