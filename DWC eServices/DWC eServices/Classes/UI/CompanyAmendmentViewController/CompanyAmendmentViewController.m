//
//  CompanyAddressChangeViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyAmendmentViewController.h"
#import "BaseServicesViewController.h"
#import "SFRestAPI+Blocks.h"
#import "RecordType.h"
#import "DWCContactInfo.h"
#import "Globals.h"
#import "Account.h"
#import "TenancyContract.h"
#import "FormField.h"
#import "WebForm.h"
#import "EServiceAdministration.h"
#import "SOQLQueries.h"
#import "FormFieldValidation.h"
#import "HelperClass.h"

@interface CompanyAmendmentViewController ()

@end

@implementation CompanyAmendmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadRecordTypes];
    [self loadTenancyContract];
    [self loadDwcContactInfo];
    [self loadEServiceAdministration];
    [self loadCompanyNames];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRecordTypes {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            isLoadingRecordTypes = NO;
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            RecordType *recordType = [[RecordType alloc] initRecordType:obj];
            
            if ([recordType.objectType isEqualToString:@"Case"]) {
                caseRecordType = recordType;
            }
            else if ([recordType.objectType isEqualToString:@"Registration_Amendments__c"]) {
                if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeCompanyAddressChange &&
                    [recordType.developerName isEqualToString:@"Address_Change"]) {
                    serviceRecordType = recordType;
                }
                else if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeCompanyNameChange &&
                         [recordType.developerName isEqualToString:@"Company_Name_Change"]) {
                    serviceRecordType = recordType;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            isLoadingRecordTypes = NO;
            [self hideLoadingDialog];
        });
    };
    
    [self.baseServicesViewController showLoadingDialog];
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SObjectType IN ('Case', 'Registration_Amendments__c') AND DeveloperName IN ('Registration_Request', 'Address_Change' , 'Company_Name_Change' , 'Director_Removal' , 'Capital_Change')";
    
    isLoadingRecordTypes = YES;
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadCompanyNames {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            isLoadingCompanyNames = NO;
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSMutableArray *namesMutableArray = [NSMutableArray new];
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            Account *account = [[Account alloc] initAccount:obj];
            [namesMutableArray addObject:account.name];
        }
        
        companyNamesArray = [NSArray arrayWithArray:namesMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            isLoadingCompanyNames = NO;
            [self hideLoadingDialog];
        });
    };
    
    [self.baseServicesViewController showLoadingDialog];
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT Id, Name FROM Account WHERE Id != '%@' AND RecordType.DeveloperName = 'DWC_Account_Registered'", [Globals currentAccount].Id];
    
    isLoadingCompanyNames = YES;
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadDwcContactInfo {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            isLoadingDWCContactInfo = NO;
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            dwcContactInfo = [[DWCContactInfo alloc] initDWCContactInfo:obj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            isLoadingDWCContactInfo = NO;
            [self hideLoadingDialog];
        });
    };
    
    isLoadingDWCContactInfo = YES;
    [self.baseServicesViewController showLoadingDialog];
    
    NSString *selectQuery = @"SELECT Bank_Name__c, P_O_Box__c, City_Country__c FROM DWC_Info__c Where Name = 'DWC'";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadTenancyContract {
    isLoadingTenancyContracts = YES;
    [self.baseServicesViewController showLoadingDialog];
    
    SFRestRequest *tenantContractsRequest = [[SFRestRequest alloc] init];
    tenantContractsRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileTenantContractsWebService"];
    tenantContractsRequest.method = SFRestMethodGET;
    tenantContractsRequest.path = @"/services/apexrest/MobileTenantContractsWebService";
    tenantContractsRequest.queryParams = [NSDictionary dictionaryWithObject:[Globals currentAccount].Id forKey:@"AccountId"];
    
    [[SFRestAPI sharedInstance] send:tenantContractsRequest delegate:self];
}

- (void)loadEServiceAdministration {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            isLoadingServiceIdentifier = NO;
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
            isLoadingServiceIdentifier = NO;
            [self hideLoadingDialog];
        });
    };
    
    isLoadingServiceIdentifier = YES;
    [self.baseServicesViewController showLoadingDialog];
    
    NSString *serviceIdentifier = @"";
    switch (self.baseServicesViewController.relatedServiceType) {
        case RelatedServiceTypeCompanyAddressChange:
            serviceIdentifier = @"Address Change";
            caseSubType = @"Request for Address Change";
            break;
        case RelatedServiceTypeCompanyNameChange:
            serviceIdentifier = @"Change of Business Name";
            caseSubType = @"Request for Company Name Change";
            break;
        default:
            break;
    }
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries amendementServiceAdminQuery:serviceIdentifier]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)finishedLoadingData {
    [self prepareForNextFlowPage];
}

- (void)prepareForNextFlowPage {
    //Prepare FormFields
    NSArray *formFieldsMutableArray = [NSArray new];
    switch (self.baseServicesViewController.relatedServiceType) {
        case RelatedServiceTypeCompanyAddressChange:
            formFieldsMutableArray = [self getAddressChangeFields];
            break;
        case RelatedServiceTypeCompanyNameChange:
            formFieldsMutableArray = [self getNameChangeFields];
            break;
        default:
            break;
    }
    
    
    self.baseServicesViewController.currentWebForm = [WebForm new];
    self.baseServicesViewController.currentWebForm.formFields = [NSArray arrayWithArray:formFieldsMutableArray];
    self.baseServicesViewController.currentWebForm.objectName = @"Registration_Amendments__c";
    self.baseServicesViewController.currentServiceAdministration = selectedEServiceAdministrator;
    self.baseServicesViewController.serviceFieldCaseObjectName = @"Registration_Amendment__c";
    
    self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [Globals currentAccount].Id, @"AccountId",
                                                  caseRecordType.Id, @"RecordTypeId",
                                                  @"Draft", @"Status",
                                                  @"Registration Services", @"Type",
                                                  @"Mobile", @"Origin",
                                                  caseSubType, @"Sub_Type__c",
                                                  nil];
    
    self.baseServicesViewController.serviceFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [Globals currentAccount].Id, @"Company__c",
                                                     serviceRecordType.Id, @"RecordTypeId",
                                                     nil];
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
}

- (NSArray *)getAddressChangeFields {
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    
    Account *currentAccount = [Globals currentAccount];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"CurrentAddressInformation" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"CurrentAddressInformation", @"") FieldValue:@"" IsParameter:NO]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Mobile_Before_Change__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"AddressChangeMobileBefore", @"") FieldValue:currentAccount.mobile IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Fax_Before_Change__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"AddressChangeFaxBefore", @"") FieldValue:currentAccount.fax IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Email_Before_Change__c" Type:@"EMAIL" MobileLabel:NSLocalizedString(@"AddressChangeEmailBefore", @"") FieldValue:currentAccount.email IsParameter:YES]];
    if (!activeBCTenancyContract) {
        [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"PO_Box_Before_Change__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"AddressChangePOBoxBefore", @"") FieldValue:currentAccount.billingPostalCode IsParameter:YES]];
    }
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"NewAddressInformation" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"NewAddressInformation", @"") FieldValue:@"" IsParameter:NO IsRequired:NO]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Mobile__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"AddressChangeMobile", @"") FieldValue:currentAccount.mobile IsParameter:NO IsRequired:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Fax__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"AddressChangeFax", @"") FieldValue:currentAccount.fax IsParameter:NO IsRequired:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"E_Mail__c" Type:@"EMAIL" MobileLabel:NSLocalizedString(@"AddressChangeEmail", @"") FieldValue:currentAccount.email IsParameter:NO IsRequired:YES]];
    if (!activeBCTenancyContract || YES) {
        FormFieldValidation *POBoxValidation = [[FormFieldValidation alloc] initFormFieldValidationWithValue:dwcContactInfo.poBox compareType:FormFieldValidationComparisonNotEqual errorMessage:NSLocalizedString(@"POBoxDWCReservedAlertMessage", @"")];
        
        [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"PO_Box__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"AddressChangePOBox", @"") FieldValue:currentAccount.billingPostalCode IsParameter:NO IsRequired:YES formFieldValidationsArray:@[POBoxValidation]]];
    }
    
    return [NSArray arrayWithArray:formFieldsMutableArray];
}

- (NSArray *)getNameChangeFields {
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    
    Account *currentAccount = [Globals currentAccount];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"CurrentNameInformation" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"CurrentNameInformation", @"") FieldValue:@"" IsParameter:NO]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Company_Name_Before_Registration__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"NameChangeNameBefore", @"") FieldValue:currentAccount.name IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Company_Arabic_Name_Before_Registration__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"NameChangeNameArabicBefore", @"") FieldValue:currentAccount.arabicAccountName IsParameter:YES]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"NewNameInformation" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"NewNameInformation", @"") FieldValue:@"" IsParameter:NO]];
    
    FormFieldValidation *namesValidation = [[FormFieldValidation alloc] initFormFieldValidationWithArray:companyNamesArray compareType:FormFieldValidationComparisonNotEqual errorMessage:NSLocalizedString(@"CompanyNameReservedAlertMessage", @"")];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"New_Company_Name__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"NameChangeName", @"") FieldValue:@"" IsParameter:NO IsRequired:YES formFieldValidationsArray:@[namesValidation]]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"New_Company_Name_Arabic__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"NameChangeNameArabic", @"") FieldValue:@"" IsParameter:NO IsRequired:NO]];
    
    return [NSArray arrayWithArray:formFieldsMutableArray];
}

- (void)hideLoadingDialog {
    if (isLoadingTenancyContracts || isLoadingRecordTypes || isLoadingDWCContactInfo ||
        isLoadingServiceIdentifier || isLoadingCompanyNames) {
        return;
    }
    
    [self.baseServicesViewController hideLoadingDialog];
    [self finishedLoadingData];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", resultsArray);
    
    activeBCTenancyContract = nil;
    for (NSDictionary *recordDict in resultsArray) {
        TenancyContract *tempTenancyContract = [[TenancyContract alloc] initTenancyContract:recordDict];
        
        if (tempTenancyContract.isBCContract)
            activeBCTenancyContract = tempTenancyContract;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        isLoadingTenancyContracts = NO;
        [self hideLoadingDialog];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        isLoadingTenancyContracts = NO;
        [self hideLoadingDialog];
        [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        isLoadingTenancyContracts = NO;
        [self hideLoadingDialog];
        [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        isLoadingTenancyContracts = NO;
        [self hideLoadingDialog];
        [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
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
