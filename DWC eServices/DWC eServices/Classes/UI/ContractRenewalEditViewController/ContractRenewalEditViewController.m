//
//  ContractRenewalEditViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ContractRenewalEditViewController.h"
#import "TenancyContract.h"
#import "HelperClass.h"
#import "SFRestAPI+Blocks.h"
#import "FVCustomAlertView.h"
#import "SOQLQueries.h"
#import "EServiceAdministration.h"
#import "ContractLineItem.h"
#import "InventoryUnit.h"
#import "Product.h"
#import "BaseServicesViewController.h"
#import "Globals.h"
#import "Account.h"
#import "NSString+SFPathAdditions.h"
#import "FormField.h"
#import "WebForm.h"
#import "RecordType.h"

@interface ContractRenewalEditViewController ()

@end

@implementation ContractRenewalEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadProductType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadProductType{
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    SFRestRequest *contractLineItemsRequest = [[SFRestRequest alloc] init];
    contractLineItemsRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileContractLineItemsWebService"];
    contractLineItemsRequest.method = SFRestMethodGET;
    contractLineItemsRequest.path = @"/services/apexrest/MobileContractLineItemsWebService";
    contractLineItemsRequest.queryParams = [NSDictionary dictionaryWithObject:self.baseServicesViewController.currentContract.Id forKey:@"ContractId"];
    
    [[SFRestAPI sharedInstance] send:contractLineItemsRequest delegate:self];
    
}

- (void)loadEServiceAdministration:(NSString *)serviceIdentifier {
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
            [self refreshValues];
            
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            
            [self loadCaseRecordType];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries renewContractServiceAdminQuery:serviceIdentifier]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)refreshValues {    
    self.serviceNameLabel.text = selectedEServiceAdministrator.displayName;
    self.serviceNameTextField.text = [NSString stringWithFormat:@"AED %@", selectedEServiceAdministrator.amount];
    self.knowledgeFeesTextField.text = [NSString stringWithFormat:@"AED %@", selectedEServiceAdministrator.knowledgeFeeService.amount];
    self.courierFeesTextField.text = @"AED 0";

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

- (void)prepareForNextFlowPage {
    //Prepare FormFields
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"ContractInformation" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"TenancyContractInformation", @"") FieldValue:@"" IsParameter:NO]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Contract_Number__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"TenancyContractName", @"") FieldValue:self.baseServicesViewController.currentContract.contractNumber IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Contract_Type__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"TenancyContractType", @"") FieldValue:self.baseServicesViewController.currentContract.contractType IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Contract_Start_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"TenancyContractStartDate", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.currentContract.contractStartDate] IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Contract_Expiry_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"TenancyContractExpireDate", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.currentContract.contractExpiryDate] IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Rent_Start_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"TenancyContractRentStartDate", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.currentContract.rentStartDate] IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Activated_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"TenancyContractActivatedDate", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.currentContract.activatedDate] IsParameter:YES]];
    
    NSString *contractDurationString = [HelperClass formatNumberToString:self.baseServicesViewController.currentContract.contractDurationYear FormatStyle:NSNumberFormatterNoStyle MaximumFractionDigits:0];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Contract_Duration__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"TenancyContractDuration", @"") FieldValue:[NSString stringWithFormat:@"%@ (Year/s)", contractDurationString] IsParameter:YES]];
    
    NSString *totalPriceString = [HelperClass formatNumberToString:self.baseServicesViewController.currentContract.totalRentPrice FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Total_Price__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"TenancyContractRentPrice", @"") FieldValue:[NSString stringWithFormat:@"AED %@", totalPriceString] IsParameter:YES]];
    
    self.baseServicesViewController.currentWebForm = [WebForm new];
    self.baseServicesViewController.currentWebForm.formFields = [NSArray arrayWithArray:formFieldsMutableArray];
    self.baseServicesViewController.currentServiceAdministration = selectedEServiceAdministrator;
    
    self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [Globals currentAccount].Id, @"AccountId",
                                                  /*[NSNumber numberWithBool:[self.courierRequiredSwitch isOn]], @"Deliver_Contract__c",*/
                                                  caseRecordType.Id, @"RecordTypeId",
                                                  @"Draft", @"Status",
                                                  @"Leasing Services", @"Type",
                                                  @"Mobile", @"Origin",
                                                  nil];
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
}

- (void)courierFieldsSetHidden:(BOOL)hidden {
    [self.courierFeesLabel setHidden:hidden];
    [self.courierFeesTextField setHidden:hidden];
}

- (void)setCourierValuesToFields {
    [self.courierFeesTextField setText:[NSString stringWithFormat:@"AED %@", retailCourierRate]];
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

- (void)handleContractLineItemsWebserviceReturn:(id)jsonResponse {
    NSError *error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", resultsArray);
    
    selectedProduct = @"";
    NSString *selectedServiceIdentifier = @"";
    
    for (NSDictionary *recordDict in resultsArray) {
        ContractLineItem *contractLineItem = [[ContractLineItem alloc] initContractLineItem:recordDict];
        
        selectedProduct = contractLineItem.inventoryUnit.productType.name;
        if ([selectedProduct isEqualToString:@"Smart Desk"])
            selectedServiceIdentifier = @"BC-SMART DESK";
        else if ([selectedProduct isEqualToString:@"Smart Office"])
            selectedServiceIdentifier = @"BC-SMART OFFICE";
        else if ([selectedProduct isEqualToString:@"Permanent Office"])
            selectedServiceIdentifier = @"BC-PERMANENT SO";
        else if ([selectedProduct isEqualToString:@"Permanent Desk"])
            selectedServiceIdentifier = @"BC-PERMANENT SD";
        else if ([selectedProduct isEqualToString:@"Permanent Exclusive Office"])
            selectedServiceIdentifier = @"BC-PERMANENT EO";
        else if ([selectedProduct isEqualToString:@"Virtual Office"])
            selectedServiceIdentifier = @"BC-VIRTUAL OFFICE";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        [self loadEServiceAdministration:selectedServiceIdentifier];
    });
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

- (void)loadCaseRecordType {
    //caseRecordTypeId
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
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Leasing_Request'";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    if ([request.path containsString:@"MobileContractLineItemsWebService"])
        [self handleContractLineItemsWebserviceReturn:jsonResponse];
    else if ([request.path containsString:@"MobileAramexRateWebService"])
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
