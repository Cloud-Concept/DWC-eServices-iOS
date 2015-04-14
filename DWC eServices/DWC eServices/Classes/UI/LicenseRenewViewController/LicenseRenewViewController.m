//
//  LicenseRenewViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "LicenseRenewViewController.h"
#import "BaseServicesViewController.h"
#import "Globals.h"
#import "Account.h"
#import "NSString+SFPathAdditions.h"
#import "FVCustomAlertView.h"
#import "HelperClass.h"
#import "SOQLQueries.h"
#import "SFRestAPI+Blocks.h"
#import "EServiceAdministration.h"
#import "FormField.h"
#import "WebForm.h"
#import "License.h"
#import "RecordType.h"

@interface LicenseRenewViewController ()

@end

@implementation LicenseRenewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadEServiceAdministration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)courierRequiredSwitchValueChanged:(id)sender {
    if ([self.courierRequiredSwitch isOn]) {
        if (courierChargesLoaded) {
            [self setCourierValuesToFields];
            [self courierFieldsSetHidden:NO];
        }
        else {
            [self getAramexRates];
        }
    }
    else {
        [self courierFieldsSetHidden:YES];
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.baseServicesViewController cancelServiceButtonClicked];
}

- (IBAction)nextButtonClicked:(id)sender {
    [self prepareForNextFlowPage];
}

- (void)displayServicePrice {
    //selectedEServiceAdministrator.totalAmount
    NSString *totalAmountString = [HelperClass formatNumberToString:selectedEServiceAdministrator.totalAmount
                                                        FormatStyle:NSNumberFormatterDecimalStyle
                                              MaximumFractionDigits:2];
    self.totalAmountTextField.text = [NSString stringWithFormat:@"AED %@", totalAmountString];
}

- (void)prepareForNextFlowPage {
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"ContractInformation" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"LicenseInformation", @"") FieldValue:@"" IsParameter:NO]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"License_Issue_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"LicenseIssueDate", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.currentLicense.licenseIssueDate] IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"License_Expiry_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"LicenseExpiryDate", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.currentLicense.licenseExpiryDate] IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Commercial_Name__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"LicenseCommercialName", @"") FieldValue:self.baseServicesViewController.currentLicense.commercialName IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Commercial_Name_Arabic__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"LicenseCommercialNameArabic", @"") FieldValue:self.baseServicesViewController.currentLicense.commercialNameArabic IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"License_Number_Value__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"LicenseNumberValue", @"") FieldValue:self.baseServicesViewController.currentLicense.licenseNumberValue IsParameter:YES]];
    
    self.baseServicesViewController.currentWebForm = [WebForm new];
    self.baseServicesViewController.currentWebForm.formFields = [NSArray arrayWithArray:formFieldsMutableArray];
    self.baseServicesViewController.currentWebForm.objectName = @"License__c";
    self.baseServicesViewController.currentServiceAdministration = selectedEServiceAdministrator;
    
    self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [Globals currentAccount].Id, @"AccountId",
                                                  [NSNumber numberWithBool:[self.courierRequiredSwitch isOn]], @"isCourierRequired__c",
                                                  caseRecordType.Id, @"RecordTypeId",
                                                  @"Draft", @"Status",
                                                  @"License Services", @"Type",
                                                  @"Mobile", @"Origin",
                                                  /*@"License Renewal Without Activity Modification", @"Sub_Type__c",*/
                                                  self.baseServicesViewController.currentLicense.Id, @"License_Ref__c",
                                                  nil];
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
}

- (void)loadEServiceAdministration {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *recordDict in [dict objectForKey:@"records"]) {
            selectedEServiceAdministrator = [[EServiceAdministration alloc] initEServiceAdministration:recordDict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self displayServicePrice];
            [self loadCaseRecordType];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries renewLicenseServiceAdminQuery]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)courierFieldsSetHidden:(BOOL)hidden {
    [self.courierFeesLabel setHidden:hidden];
    [self.courierFeesTextField setHidden:hidden];
}

- (void)setCourierValuesToFields {
    [self.courierFeesTextField setText:[NSString stringWithFormat:@"AED %@", retailCourierRate]];
}

- (void)loadCaseRecordType {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            caseRecordType = [[RecordType alloc] initRecordType:obj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'License_Request'";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)getAramexRates {
    
    // Manually set up request object
    SFRestRequest *aramexRequest = [[SFRestRequest alloc] init];
    aramexRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileAramexRateWebService"];
    aramexRequest.method = SFRestMethodGET;
    
    Account *currentAccount = [Globals currentAccount];
    
    aramexRequest.path = [NSString stringWithFormat:@"/services/apexrest/MobileAramexRateWebService?city=%@&country=%@", currentAccount.billingCity, [currentAccount.billingCountry encodeToPercentEscapeString]];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] send:aramexRequest delegate:self];
}

- (void)handleAramexWebserviceReturn:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    courierChargesLoaded = YES;
    retailCourierRate =  [HelperClass stringCheckNull:[dict objectForKey:@"retailAmount"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        
        [self setCourierValuesToFields];
        [self courierFieldsSetHidden:NO];
    });
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    if ([request.path containsString:@"MobileAramexRateWebService"])
        [self handleAramexWebserviceReturn:jsonResponse];
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
