//
//  CancelVisaViewController.m
//  iDWC
//
//  Created by Mina Zaklama on 7/6/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CancelVisaViewController.h"
#import "BaseServicesViewController.h"
#import "SFRestAPI+Blocks.h"
#import "RecordType.h"
#import "SOQLQueries.h"
#import "Visa.h"
#import "EServiceAdministration.h"
#import "FormField.h"
#import "HelperClass.h"
#import "Country.h"
#import "SFDateUtil.h"
#import "Occupation.h"
#import "Qualification.h"
#import "WebForm.h"
#import "Globals.h"
#import "Account.h"

@interface CancelVisaViewController ()

@end

@implementation CancelVisaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadRecordTypes];
    [self loadEServiceAdministration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingDialog {
    [self.baseServicesViewController showLoadingDialog];
}

- (void)hideLoadingDialog {
    if (!(loadingRecordTypes || loadingServiceIdentifier)) {
        [self.baseServicesViewController hideLoadingDialog];
        [self prepareForNextFlowPage];
    }
}

- (void)loadRecordTypes {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSArray *recordTypesArray = [dict objectForKey:@"records"];
        for (NSDictionary *obj in recordTypesArray) {
            caseRecordType = [[RecordType alloc] initRecordType:obj];
        }
        
        loadingRecordTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        loadingRecordTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Visa_Request'";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    loadingRecordTypes = YES;
    [self showLoadingDialog];
}

- (void)loadEServiceAdministration {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingServiceIdentifier = NO;
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *recordDict in [dict objectForKey:@"records"]) {
            selectedEServiceAdministrator = [[EServiceAdministration alloc] initEServiceAdministration:recordDict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingServiceIdentifier = NO;
            [self hideLoadingDialog];
        });
    };
    
    loadingServiceIdentifier = YES;
    [self showLoadingDialog];
    
    NSString *serviceIdentifier = @"";
    if([self.baseServicesViewController.renewedVisaObject.recordType.developerName isEqualToString:@"Employment_Visa_Issued"]){
        serviceIdentifier  = @"Residency Permit Cancellation";
    }else  if([self.baseServicesViewController.renewedVisaObject.recordType.developerName isEqualToString:@"Employment_Visa_Under_Process"] && self.baseServicesViewController.renewedVisaObject.residencyFileNumber != nil){
        serviceIdentifier = @"Residency Permit Cancellation";
    }else  if([self.baseServicesViewController.renewedVisaObject.recordType.developerName isEqualToString:@"Employment_Visa_Under_Process"]){
        serviceIdentifier = @"Entry Permit Cancellation";
    }else  if([self.baseServicesViewController.renewedVisaObject.recordType.developerName isEqualToString:@"Visit_Visa_Issued"]){
        serviceIdentifier = @"Visit Visa Cancellation";
    }
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries visaRenewServiceAdminQuery:serviceIdentifier]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)prepareForNextFlowPage {
    //Prepare FormFields
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"EmployeeDetailsTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"EmployeeDetailsTitle", @"") FieldValue:@"" IsParameter:YES]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Full_Name__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeName", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantFullName IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Gender__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeGender", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantGender IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Date_of_Birth__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeDateOfBirth", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.renewedVisaObject.dateOfBirth] IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Country_of_Birth__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeCountryOfBirth", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.countryOfBirth.name IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Email__c" Type:@"EMAIL" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeEmail", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantEmail IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Mobile_Number__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeMobile", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantMobileNumber IsParameter:YES]];
    
    FormField *maritalStatus = [[FormField alloc] initFormField:@"" Name:@"Marital_Status__c" Type:@"PICKLIST" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeMaritalStatus", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.maritalStatus IsParameter:YES];
    NSArray *maritalStatusValues = @[@"Single", @"Married", @"Divorced", @"Widowed"];
    [maritalStatus setPicklistNamesDictionary:@{maritalStatus.name:maritalStatusValues} PicklistValuesDictionary:@{maritalStatus.name:maritalStatusValues}];
    [maritalStatus setPicklistLabel:self.baseServicesViewController.renewedVisaObject.maritalStatus];
    [formFieldsMutableArray addObject:maritalStatus];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Mother_Name__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeMotherName", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.motherName IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Current_Nationality__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeCurrentNationality", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.currentNationality.name IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Previous_Nationality__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeePreviousNationality", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.previousNationality.name IsParameter:YES]];
    
    FormField *religion = [[FormField alloc] initFormField:@"" Name:@"Religion__c" Type:@"PICKLIST" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeReligion", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.religion IsParameter:YES];
    NSArray *religionStatusValues = @[@"Bahaei", @"Budhist", @"Christian", @"Hindu", @"Kadiani", @"Muslim", @"Sikh"];
    [religion setPicklistNamesDictionary:@{religion.name:religionStatusValues} PicklistValuesDictionary:@{religion.name:religionStatusValues}];
    [religion setPicklistLabel:self.baseServicesViewController.renewedVisaObject.religion];
    [formFieldsMutableArray addObject:religion];
    
    FormField *languages = [[FormField alloc] initFormField:@"" Name:@"Languages__c" Type:@"MULTIPICKLIST" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeLanguagesSpoken", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.languages IsParameter:YES];
    NSArray *languagesValues = @[@"Arabic", @"English", @"French"];
    [languages setPicklistNamesDictionary:@{languages.name:languagesValues} PicklistValuesDictionary:@{languages.name:languagesValues}];
    [languages setPicklistLabel:self.baseServicesViewController.renewedVisaObject.languages];
    [formFieldsMutableArray addObject:languages];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"PassportDetailsTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"PassportDetailsTitle", @"") FieldValue:@"" IsParameter:YES]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Passport_Number__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportNumber", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.passportNumber IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Passport_Expiry_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportPassportExpiryDate", @"") FieldValue:[SFDateUtil toSOQLDateTimeString:self.baseServicesViewController.renewedVisaObject.passportExpiry isDateTime:NO] IsParameter:YES]];
    
    FormField *passportCountry = [[FormField alloc] initFormField:@"" Name:@"Passport_Issue_Country__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportIssueCountry", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.passportIssueCountry.Id IsParameter:YES];
    passportCountry.textValue = @"Country__c";
    [formFieldsMutableArray addObject:passportCountry];
    [self.baseServicesViewController getReferencePicklistValues:passportCountry];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Passport_Place_of_Issue__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportPassportIssuePlace", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.passportPlaceOfIssue IsParameter:YES]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"VisaDetailsTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"VisaDetailsTitle", @"") FieldValue:@"" IsParameter:YES]];
    
    NSString *monthlyBasicSalaryString = [HelperClass formatNumberToString:self.baseServicesViewController.renewedVisaObject.monthlyBasicSalaryInAED FormatStyle:NSNumberFormatterNoStyle MaximumFractionDigits:2];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Monthly_Basic_Salary_in_AED__c" Type:@"DOUBLE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeMonthlySalary", @"") FieldValue:monthlyBasicSalaryString IsParameter:YES]];
    
    NSString *monthlyAllowanceString = [HelperClass formatNumberToString:self.baseServicesViewController.renewedVisaObject.monthlyAllowancesInAED FormatStyle:NSNumberFormatterNoStyle MaximumFractionDigits:2];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Monthly_Allowances_in_AED__c" Type:@"DOUBLE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeMonthlyAllowance", @"") FieldValue:monthlyAllowanceString IsParameter:YES]];
    
    FormField *occupation = [[FormField alloc] initFormField:@"" Name:@"Job_Title_at_Immigration__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeOccupation", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.jobTitleAtImmigration.Id IsParameter:YES];
    occupation.textValue = @"Occupation__c";
    [formFieldsMutableArray addObject:occupation];
    [self.baseServicesViewController getReferencePicklistValues:occupation];
    
    FormField *qualification = [[FormField alloc] initFormField:@"" Name:@"Qualification__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeQualification", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.qualification.Id IsParameter:YES];
    qualification.textValue = @"Qualification__c";
    [formFieldsMutableArray addObject:qualification];
    [self.baseServicesViewController getReferencePicklistValues:qualification];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"ServicesTitle " Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"ServicesTitle", @"") FieldValue:@"" IsParameter:YES]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Urgent_Cancellation__c" Type:@"BOOLEAN" MobileLabel:NSLocalizedString(@"VisaUrgentCancellation", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.passportPlaceOfIssue IsParameter:NO]];
    
    
    self.baseServicesViewController.currentWebForm = [WebForm new];
    self.baseServicesViewController.currentWebForm.formFields = [NSArray arrayWithArray:formFieldsMutableArray];
    self.baseServicesViewController.currentWebForm.objectName = @"Visa__c";
    self.baseServicesViewController.createServiceRecord = NO;
    self.baseServicesViewController.currentServiceAdministration = selectedEServiceAdministrator;
    self.baseServicesViewController.serviceFieldCaseObjectName = @"Visa_Ref__c";
    self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  selectedEServiceAdministrator.Id, @"Service_Requested__c",
                                                  [Globals currentAccount].Id, @"AccountId",
                                                  caseRecordType.Id, @"RecordTypeId",
                                                  @"Draft", @"Status",
                                                  @"Visa Services", @"Type",
                                                  @"Mobile", @"Origin",
                                                  self.baseServicesViewController.renewedVisaObject.Id, @"Visa_Ref__c",
                                                  self.baseServicesViewController.renewedVisaObject.visaHolder.Id, @"Employee_Ref__c",
                                                  self.baseServicesViewController.renewedVisaObject.applicantEmail, @"Applicant_Email__c",
                                                  selectedEServiceAdministrator.serviceIdentifier, @"Sub_Type__c",
                                                  nil];
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
}

@end
