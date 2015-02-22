//
//  NewNOCViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NewNOCViewController.h"
#import "EServiceAdministration.h"
#import "SFRestAPI+Blocks.h"
#import "Account.h"
#import "Globals.h"
#import "HelperClass.h"
#import "ServicesDynamicFormViewController.h"
#import "Visa.h"
#import "SOQLQueries.h"
#import "BaseServicesViewController.h"

@interface NewNOCViewController ()

@end

@implementation NewNOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    loadingNOCTypes = NO;
    loadingRecordTypes = NO;
    loadingCourierCharges = NO;
    courierChargesLoaded = NO;
    
    corporateCourierRate = @"";
    retailCourierRate = @"";
    
    [self resetAuthorityLanguageButtons];
    [self courierFieldsSetHidden:YES];
    
    [self getNOCRecordType];
    [self getNOCTypes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseNOCTypeButtonClicked:(id)sender {
    NSMutableArray *stringArray = [NSMutableArray new];
    UIButton *senderButton = sender;
    
    for(EServiceAdministration *eService in nocTypesArray) {
        [stringArray addObject:eService.serviceIdentifier];
    }
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = stringArray;
    pickerTableVC.selectedIndexPath = selectedNOCTypeIndexPath;
    pickerTableVC.valuePicked = ^(NSString *value, NSIndexPath *indexPath, PickerTableViewController *picklist) {
        selectedNOCTypeIndexPath = indexPath;
        [self.chooseNOCTypeButton setTitle:value forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
        [self resetAuthorityLanguageButtons];
        [self.chooseAuthorityButton setEnabled:YES];
    };
    
    [pickerTableVC showPopoverFromView:senderButton];
}

- (IBAction)chooseAuthorityButtonClicked:(id)sender {
    EServiceAdministration *selectedService = [nocTypesArray objectAtIndex:selectedNOCTypeIndexPath.row];
    NSMutableArray *stringArray = [NSMutableArray new];
    UIButton *senderButton = sender;
    
    for (NSString *authority in selectedService.authoritiesOrderedSet) {
        [stringArray addObject:authority];
    }
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = stringArray;
    pickerTableVC.selectedIndexPath = selectedAuthorityIndexPath;
    pickerTableVC.valuePicked = ^(NSString *value, NSIndexPath *indexPath, PickerTableViewController *picklist) {
        selectedAuthorityIndexPath = indexPath;
        selectedAuthority = value;
        [self.chooseAuthorityButton setTitle:value forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
        [self resetLanguageButton:YES];
    };
    
    [pickerTableVC showPopoverFromView:senderButton];
}

- (IBAction)chooseLanguageButtonClicked:(id)sender {
    EServiceAdministration *selectedService = [nocTypesArray objectAtIndex:selectedNOCTypeIndexPath.row];
    NSOrderedSet *langaugesOrderedSet = [selectedService.authorityLanguagesDictionary objectForKey:selectedAuthority];
    NSMutableArray *stringArray = [NSMutableArray new];
    UIButton *senderButton = sender;
    
    for (NSString *language in langaugesOrderedSet) {
        [stringArray addObject:language];
    }
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = stringArray;
    pickerTableVC.selectedIndexPath = selectedLanguageIndexPath;
    pickerTableVC.valuePicked = ^(NSString *value, NSIndexPath *indexPath, PickerTableViewController *picklist) {
        selectedLanguageIndexPath = indexPath;
        [self.chooseLanguageButton setTitle:value forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
        selectedLanguage = value;
    };
    
    [pickerTableVC showPopoverFromView:senderButton];
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
    if ([self validateInput]) {
        [self prepareForNextFlowPage];
    }
}

- (void)resetAuthorityLanguageButtons {
    [self.chooseAuthorityButton setTitle:NSLocalizedString(@"chooseAuthorityButton", @"")
                                forState:UIControlStateNormal];
    selectedAuthorityIndexPath = nil;
    [self resetLanguageButton:NO];
}

- (void)resetLanguageButton:(BOOL)enabled {
    [self.chooseLanguageButton setTitle:NSLocalizedString(@"chooseLanguageButton", @"")
                               forState:UIControlStateNormal];
    selectedLanguageIndexPath = nil;
    [self.chooseLanguageButton setEnabled:enabled];
}

- (void)courierFieldsSetHidden:(BOOL)hidden {
    [self.courierRateLabel setHidden:hidden];
    [self.courierRateTextField setHidden:hidden];
}

- (void)setCourierValuesToFields {
    [self.courierRateTextField setText:[NSString stringWithFormat:@"AED %@", retailCourierRate]];
}

- (void)showLoadingDialog {
    [self.baseServicesViewController showLoadingDialog];
}

- (void)hideLoadingDialog {
    if (!(loadingNOCTypes || loadingRecordTypes))
        [self.baseServicesViewController hideLoadingDialog];
}

- (void)getNOCTypes {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        NSLog(@"request:didLoadResponse: #records: %lud", (unsigned long)records.count);
        
        nocTypesArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in records) {
            NSArray *documentRecordsArray = [NSArray new];
            if(![[dict objectForKey:@"eServices_Document_Checklists__r"] isKindOfClass:[NSNull class]])
                documentRecordsArray = [[dict objectForKey:@"eServices_Document_Checklists__r"] objectForKey:@"records"];
            
            [nocTypesArray addObject:[[EServiceAdministration alloc] initEServiceAdministration:[dict objectForKey:@"Id"]
                                                                                           Name:[dict objectForKey:@"Name"]
                                                                              ServiceIdentifier:[dict objectForKey:@"Service_Identifier__c"]
                                                                                         Amount:[dict objectForKey:@"Amount__c"]
                                                                                RelatedToObject:[dict objectForKey:@"Related_to_Object__c"]
                                                                             NewEditVFGenerator:[dict objectForKey:@"New_Edit_VF_Generator__c"]
                                                                          ServiceDocumentsArray:documentRecordsArray]];
        }
        
        loadingNOCTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        loadingNOCTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
            [self hideLoadingDialog];
        });
    };
    
    loadingNOCTypes = YES;
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries employeeNOCTypesQuery]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)getNOCRecordType {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSArray *recordTypesArray = [dict objectForKey:@"records"];
        for (NSDictionary *obj in recordTypesArray) {
            NSString *objectType = [obj objectForKey:@"SobjectType"];
            NSString *developerName = [obj objectForKey:@"DeveloperName"];
            
            if([objectType isEqualToString:@"Case"] && [developerName isEqualToString:@"NOC_Request"])
                caseRecordTypeId = [obj objectForKey:@"Id"];
            
            if([objectType isEqualToString:@"NOC__c"] && [developerName isEqualToString:@"Under_Process"])
                nocRecordTypeId = [obj objectForKey:@"Id"];
        }
        
        loadingRecordTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        loadingRecordTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
            [self hideLoadingDialog];
        });
    };
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE (SobjectType = 'Case' AND DeveloperName = 'NOC_Request') OR (SObjectType = 'NOC__c' AND DeveloperName = 'Under_Process')";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    loadingRecordTypes = YES;
    [self showLoadingDialog];
}

- (void)getAramexRates {
    
    // Manually set up request object
    SFRestRequest *aramexRequest = [[SFRestRequest alloc] init];
    aramexRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileAramexRateWebService"];
    aramexRequest.method = SFRestMethodGET;
    
    Account *currentAccount = [Globals currentAccount];
    
    aramexRequest.path = [NSString stringWithFormat:@"/services/apexrest/MobileAramexRateWebService?city=%@&country=%@", currentAccount.billingCity, currentAccount.billingCountryCode];
    
    loadingCourierCharges = YES;
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] send:aramexRequest delegate:self];
}

- (void)prepareForNextFlowPage {
    EServiceAdministration *eService = [nocTypesArray objectAtIndex:selectedNOCTypeIndexPath.row];
    self.baseServicesViewController.currentWebformId = eService.editNewVFGenerator;
    self.baseServicesViewController.currentServiceAdministration = eService;
    self.baseServicesViewController.serviceObject = @"NOC__c";
    
    self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithBool:[self.courierRequiredSwitch isOn]] ,@"isCourierRequired__c",
                                                  /*
                                                  corporateCourierRate, @"Courier_Corporate_Fee__c",
                                                  retailCourierRate, @"Courier_Retail_Fee__c",
                                                  */
                                                  eService.Id, @"Service_Requested__c",
                                                  self.baseServicesViewController.currentVisaObject.visaHolder.Id, @"Employee_Ref__c",
                                                  [Globals currentAccount].Id, @"AccountId",
                                                  caseRecordTypeId, @"RecordTypeId",
                                                  @"Draft", @"Status",
                                                  @"NOC Services", @"Type",
                                                  @"Mobile", @"Origin",
                                                  nil];
    
    self.baseServicesViewController.serviceFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self.baseServicesViewController.currentVisaObject.visaHolder.Id, @"Person__c",
                                                     [Globals currentAccount].Id, @"Current_Sponsor__c",
                                                     self.baseServicesViewController.currentVisaObject.Id, @"Current_Visa__c",
                                                     @"Application Received", @"Application_Status__c",
                                                     eService.serviceIdentifier, @"Document_Name__c",
                                                     nocRecordTypeId, @"RecordTypeId",
                                                     [NSNumber numberWithBool:[self.courierRequiredSwitch isOn]], @"isCourierRequired__c",
                                                     /*caseId, @"Request__c",*/
                                                     nil];
    
    self.baseServicesViewController.parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  selectedAuthority, @"auth",
                                                  selectedLanguage, @"lang",
                                                  nil];
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
}

- (BOOL)validateInput {
    BOOL shouldPerform = YES;
    
    if (!(selectedNOCTypeIndexPath && selectedAuthorityIndexPath && selectedLanguageIndexPath)) {
        shouldPerform = NO;
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];
    }
    
    return shouldPerform;
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    loadingCourierCharges = NO;
    courierChargesLoaded = YES;
    
    retailCourierRate =  [dict objectForKey:@"retailAmount"];
    corporateCourierRate = [dict objectForKey:@"amount"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        
        [self setCourierValuesToFields];
        [self courierFieldsSetHidden:NO];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    
    //add your failed error handling here
    
    loadingCourierCharges = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
        [self hideLoadingDialog];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    
    //add your failed error handling here
    
    loadingCourierCharges = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
        [self hideLoadingDialog];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    
    //add your failed error handling here
    
    loadingCourierCharges = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
        [self hideLoadingDialog];
    });
}

@end
