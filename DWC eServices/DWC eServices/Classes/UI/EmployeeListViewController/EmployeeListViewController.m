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

@interface EmployeeListViewController ()

@end

@implementation EmployeeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
            NSDictionary *visaHolderDictionary = [dict objectForKey:@"Visa_Holder__r"];
            Account *visaHolder = [Account new];
            if(![visaHolderDictionary isKindOfClass:[NSNull class]])
                visaHolder = [[Account alloc] initAccount:[dict objectForKey:@"Visa_Holder__c"]
                                                     Name:[visaHolderDictionary objectForKey:@"Name"]
                                              BillingCity:[visaHolderDictionary objectForKey:@"BillingCity"]
                                       BillingCountryCode:[visaHolderDictionary objectForKey:@"BillingCountryCode"]];
            
            NSDictionary *sponsoringCompanyDict = [dict objectForKey:@"Sponsoring_Company__r"];
            Account *sponsoringCompany = [Account new];
            if([sponsoringCompanyDict isKindOfClass:[NSNull class]])
                sponsoringCompany = [[Account alloc] initAccount:[dict objectForKey:@"Sponsoring_Company__c"]
                                                            Name:[sponsoringCompanyDict objectForKey:@"Name"]
                                                     BillingCity:@""
                                              BillingCountryCode:@""];
            
            NSDictionary *countryOfBirthDict = [dict objectForKey:@"Country_of_Birth__r"];
            Country *countryOfBirth = [Country new];
            if(![countryOfBirthDict isKindOfClass:[NSNull class]])
                countryOfBirth = [[Country alloc] initCountry:[countryOfBirthDict objectForKey:@"Id"]
                                                         Name:[countryOfBirthDict objectForKey:@"Name"]
                                            AramexCountryCode:@""
                                            CountryNameArabic:@""
                                                     DNRDName:@""
                                                     FromCode:@""
                                                     IsActive:YES
                                              NationalityName:@""
                                        NationalityNameArabic:@""];
            
            NSDictionary *currentNationalityDict = [dict objectForKey:@"Current_Nationality__r"];
            Country *currentNationality = [Country new];
            if(![currentNationalityDict isKindOfClass:[NSNull class]])
            currentNationality = [[Country alloc] initCountry:[currentNationalityDict objectForKey:@"Id"]
                                                                  Name:[currentNationalityDict objectForKey:@"Name"]
                                                     AramexCountryCode:@""
                                                     CountryNameArabic:@""
                                                              DNRDName:@""
                                                              FromCode:@""
                                                              IsActive:YES
                                                       NationalityName:@""
                                                 NationalityNameArabic:@""];
            
            NSDictionary *jobTitleAtImmigrationDict = [dict objectForKey:@"Job_Title_at_Immigration__r"];
            Occupation *jobTitleAtImmigration = [Occupation new];
            if(![jobTitleAtImmigrationDict isKindOfClass:[NSNull class]])
            jobTitleAtImmigration = [[Occupation alloc] initOccupation:[jobTitleAtImmigrationDict objectForKey:@"Id"]
                                                                    OccupationName:[jobTitleAtImmigrationDict objectForKey:@"Name"]
                                                                        ArabicName:@""
                                                                          DNRDName:@""
                                                                          FormCode:@""
                                                                          IsActive:YES];
            
            [dataRows addObject:[[Visa alloc] initVisa:[dict objectForKey:@"Id"]
                                                  Name:[dict objectForKey:@"Name"]
                                            EmployeeId:[dict objectForKey:@"Employee_ID__c"]
                                         PersonalPhoto:[dict objectForKey:@"Personal_Photo__c"]
                                            Salutation:[dict objectForKey:@"Salutation__c"]
                                      SalutationArabic:[dict objectForKey:@"Salutation_Arabic__c"]
                                     ApplicantFullName:[dict objectForKey:@"Applicant_Full_Name__c"]
                              ApplicantFirstNameArabic:[dict objectForKey:@"Applicant_First_Name_Arabic__c"]
                             ApplicantMiddleNameArabic:[dict objectForKey:@"Applicant_Middle_Name_Arabic__c"]
                               ApplicantLastNameArabic:[dict objectForKey:@"Applicant_Last_Name_Arabic__c"]
                                        ApplicantEmail:[dict objectForKey:@"Applicant_Email__c"]
                                 ApplicantMobileNumber:[dict objectForKey:@"Applicant_Mobile_Number__c"]
                                       ApplicantGender:[dict objectForKey:@"Applicant_Gender__c"]
                                       PassportCountry:[dict objectForKey:@"Passport_Country__c"]
                                        PassportNumber:[dict objectForKey:@"Passport_Number__c"]
                                        PassportExpiry:[dict objectForKey:@"Passport_Expiry__c"]
                                              Religion:[dict objectForKey:@"Religion__c"]
                                              VisaType:[dict objectForKey:@"Visa_Type__c"]
                                        ValidityStatus:[dict objectForKey:@"Visa_Validity_Status__c"]
                                            ExpiryDate:[dict objectForKey:@"Visa_Expiry_Date__c"]
                                           DateOfBirth:[dict objectForKey:@"Date_of_Birth__c"]
                                     SponsoringCompany:sponsoringCompany
                                            VisaHolder:visaHolder
                                        CountryOfBirth:countryOfBirth
                                    CurrentNationality:currentNationality
                                 JobTitleAtImmigration:jobTitleAtImmigration]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.employeesTableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:@"Loading..." withBlur:YES];
    
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
            NSDictionary *nationalityDict = [recordDict objectForKey:@"Nationality__r"];
            Country *nationality = [Country new];
            if (![nationalityDict isKindOfClass:[NSNull class]]) {
                nationality = [[Country alloc] initCountry:[nationalityDict objectForKey:@"Id"]
                                                      Name:[nationalityDict objectForKey:@"Name"]
                                         AramexCountryCode:@""
                                         CountryNameArabic:@""
                                                  DNRDName:@""
                                                  FromCode:@""
                                                  IsActive:YES
                                           NationalityName:@""
                                     NationalityNameArabic:@""];
            }
            
            NSDictionary *recordTypeDict = [recordDict objectForKey:@"RecordType"];
            RecordType *recordType = [RecordType new];
            if (![recordTypeDict isKindOfClass:[NSNull class]]) {
                recordType = [[RecordType alloc] initRecordType:[recordTypeDict objectForKey:@"Id"]
                                                           Name:[recordTypeDict objectForKey:@"Name"]
                                                  DeveloperName:[recordTypeDict objectForKey:@"DeveloperName"]
                                                       IsActive:YES
                                                     ObjectType:@""];
            }
            
            [dataRows addObject:[[CardManagement alloc] initCardManagement:[recordDict objectForKey:@"Id"]
                                                                      Name:[recordDict objectForKey:@"Name"]
                                                             PersonalPhoto:[recordDict objectForKey:@"Personal_Photo__c"]
                                                                CardNumber:[recordDict objectForKey:@"Card_Number__c"]
                                                                    Status:[recordDict objectForKey:@"Status__c"]
                                                                   Sponsor:[recordDict objectForKey:@"Sponsor__c"]
                                                                  CardType:[recordDict objectForKey:@"Card_Type__c"]
                                                                Salutation:[recordDict objectForKey:@"Salutation__c"]
                                                                  FullName:[recordDict objectForKey:@"Full_Name__c"]
                                                               Designation:[recordDict objectForKey:@"Designation__c"]
                                                                  Duration:[recordDict objectForKey:@"Duration__c"]
                                                            CardExpiryDate:[recordDict objectForKey:@"Card_Expiry_Date__c"]
                                                             CardIssueDate:[recordDict objectForKey:@"Card_Issue_Date__c"]
                                                                RecordType:recordType
                                                               Nationality:nationality]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
                [self.employeesTableView reloadData];
            });
        }
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:@"Loading..." withBlur:YES];
    
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
    RecordMainViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"EmployeeMainViewController"];
    
    switch (self.currentDWCEmployee.Type) {
        case PermanentEmployee:
            [self configureRecordMainViewController:recordMainVC ForPermanentEmployee:[dataRows objectAtIndex:indexPath.row]];
            break;
        case VisitVisaEmployee:
            
            break;
        case ContractorEmployee:
            
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
