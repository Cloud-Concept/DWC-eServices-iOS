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
#import "FVCustomAlertView.h"
#import "Account.h"
#import "Globals.h"
#import "HelperClass.h"

@interface NewNOCViewController ()

@end

@implementation NewNOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.showSlidingMenu = NO;
    
    loadingNOCTypes = NO;
    loadingRecordTypes = NO;
    loadingCourierCharges = NO;
    courierChargesLoaded = NO;
    
    [self courierFieldsSetHidden:YES];
    
    [self getNOCTypes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)chooseNOCTypeButtonClicked:(id)sender {
    NSMutableArray *stringArray = [NSMutableArray new];
    UIButton *senderButton = sender;
    
    for(EServiceAdministration *eService in nocTypesArray) {
        [stringArray addObject:eService.serviceIdentifier];
    }
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = stringArray;
    pickerTableVC.selectedIndexPath = selectedNOCTypeIndexPath;
    pickerTableVC.delegate = self;
    
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
    [self.navigationController popToViewController:self.cancelViewController animated:YES];
}

- (void)courierFieldsSetHidden:(BOOL)hidden {
    [self.courierCorporateRateLabel setHidden:hidden];
    [self.courierCorporateRateTextField setHidden:hidden];
    [self.courierRateLabel setHidden:hidden];
    [self.courierRateTextField setHidden:hidden];
}

- (void)setCourierValuesToFields {
    [self.courierCorporateRateTextField setText:[NSString stringWithFormat:@"AED %@", corporateCourierRate]];
    
    [self.courierRateTextField setText:[NSString stringWithFormat:@"AED %@", retailCourierRate]];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:@"Loading..." withBlur:YES];
}

- (void)hideLoadingDialog {
    if (!(loadingNOCTypes || loadingRecordTypes))
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

- (void)getNOCTypes {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        NSLog(@"request:didLoadResponse: #records: %d", records.count);
        
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
                                                                           VisualForceGenerator:[dict objectForKey:@"New_Edit_VF_Generator__c"]
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
    
    NSString *selectQuery = @"SELECT ID, Name, Service_Identifier__c, Amount__c, Related_to_Object__c, New_Edit_VF_Generator__c, (SELECT ID, Name, Type__c, Language__c, Document_Type__c FROM eServices_Document_Checklists__r WHERE Document_Type__c = 'Upload') FROM Receipt_Template__c WHERE Related_to_Object__c INCLUDES ('NOC') AND Redirect_Page__c != null AND RecordType.DeveloperName = 'Auto_Generated_Invoice' AND Is_Active__c = true ORDER BY Service_Identifier__c";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
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

#pragma mark - PickerTableViewControllerDelegate
- (void)valuePickCanceled:(PickerTableViewController *)picklist {
    
}

- (void)valuePicked:(NSString *)value AtIndex:(NSIndexPath *)indexPath pickList:(PickerTableViewController *)picklist {
    selectedNOCTypeIndexPath = indexPath;
    [self.chooseNOCTypeButton setTitle:value forState:UIControlStateNormal];
    [picklist dismissPopover:YES];
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
