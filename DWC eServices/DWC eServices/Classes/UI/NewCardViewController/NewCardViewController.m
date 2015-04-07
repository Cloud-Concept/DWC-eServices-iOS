//
//  NewCardViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NewCardViewController.h"
#import "SFRestAPI+Blocks.h"
#import "BaseServicesViewController.h"
#import "PickerTableViewController.h"
#import "SOQLQueries.h"
#import "EServiceAdministration.h"
#import "HelperClass.h"
#import "Globals.h"
#import "Account.h"
#import "NSString+SFPathAdditions.h"
#import "CardManagement.h"

@interface NewCardViewController ()

@end

@implementation NewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeCardTypesDictionary];
    [self getCardRecordType];
    [self resetRecordToProcessFields];
    [self refreshDisplayedFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseCardTypeButtonClicked:(id)sender {
    UIButton *senderButton = sender;
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = cardTypesDescriptionsArray;
    pickerTableVC.selectedIndexPath = selectedCardTypeIndexPath;
    pickerTableVC.valuePicked = ^(NSString *value, NSIndexPath *indexPath, PickerTableViewController *picklist) {
        selectedCardTypeIndexPath = indexPath;
        [self.chooseCardTypeButton setTitle:value forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
        [self resetDurationButtons];
        [self resetAmountTextField];
        [self.chooseDurationButton setEnabled:YES];
    };
    
    [pickerTableVC showPopoverFromView:senderButton];
}

- (IBAction)chooseDurationButtonClicked:(id)sender {
    [self initializeDurationArray];
    
    UIButton *senderButton = sender;
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = durationArray;
    pickerTableVC.selectedIndexPath = selectedDurationIndexPath;
    pickerTableVC.valuePicked = ^(NSString *value, NSIndexPath *indexPath, PickerTableViewController *picklist) {
        selectedDurationIndexPath = indexPath;
        [self.chooseDurationButton setTitle:value forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
        [self getServiceAdministrator];
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

- (IBAction)nextButtonClicked:(id)sender {
    if ([self validateInput])
        [self prepareForNextFlowPage];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.baseServicesViewController cancelServiceButtonClicked];
}

- (void)refreshDisplayedFields {
    switch (self.baseServicesViewController.relatedServiceType) {
        case RelatedServiceTypeReplaceCard:
            self.chooseCardTypeButton.enabled = NO;
            self.chooseDurationButton.hidden = YES;
            break;
        case RelatedServiceTypeRenewCard:
            self.chooseCardTypeButton.enabled = NO;
            break;
        case RelatedServiceTypeCancelCard:
            self.chooseCardTypeButton.enabled = NO;
            self.chooseDurationButton.hidden = YES;
            self.courierRequiredLabel.hidden = YES;
            self.courierRequiredSwitch.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)resetRecordToProcessFields {
    if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeNewCard) {
        [self.recordToProcessLabel removeFromSuperview];
        [self.recordToProcessTextField removeFromSuperview];
    }
    else {
        //self.recordToProcessLabel
        [self.recordToProcessTextField setText:self.baseServicesViewController.currentCardManagement.cardNumber];
    }
}

- (void)resetDurationButtons {
    [self.chooseDurationButton setTitle:NSLocalizedString(@"chooseDurationButton", @"")
                               forState:UIControlStateNormal];
    selectedDurationIndexPath = nil;
}

- (void)resetAmountTextField {
    //[self.servicePriceTextField setText:@"AED 0"];
}

- (void)initializeCardTypesDictionary {
    cardTypesDescriptionsArray = @[@"FM Contractor Pass", @"Contractor Pass", @"Access Card"];
    cardTypesValuesArray = @[@"FM_Contractor_Pass", @"Contractor_Pass", @"Access_Card"];
    
    if (self.baseServicesViewController.currentCardManagement) {
        NSInteger index = 0;
        for (NSString *cardTypeString in cardTypesDescriptionsArray) {
            if ([self.baseServicesViewController.currentCardManagement.cardType isEqualToString:cardTypeString])
                break;
            
            index++;
        }
        
        selectedCardTypeIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.chooseCardTypeButton setTitle:[cardTypesDescriptionsArray objectAtIndex:index] forState:UIControlStateNormal];
        
        [self initializeDurationArray];
        
        index = 0;
        for (NSString *durationString in durationArray) {
            if ([self.baseServicesViewController.currentCardManagement.duration isEqualToString:durationString])
                break;
            
            index++;
        }
        [self.chooseDurationButton setTitle:[durationArray objectAtIndex:index] forState:UIControlStateNormal];
        selectedDurationIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self getServiceAdministrator];
    }
}

- (void)initializeDurationArray {
    durationArray = [NSMutableArray new];
    
    NSString *selectedCardType = [cardTypesValuesArray objectAtIndex:selectedCardTypeIndexPath.row];
    
    if (![selectedCardType isEqualToString:@""]) {
        if ([selectedCardType isEqualToString:@"Access_Card"])
            [durationArray addObject:@"1 Day"];
        
        if ([selectedCardType isEqualToString:@"Contractor_Pass"])
            [durationArray addObject:@"1 Week"];
        
        [durationArray addObject:@"1 Month"];
        
        if ([selectedCardType isEqualToString:@"Contractor_Pass"])
            [durationArray addObject:@"2 Months"];
        
        [durationArray addObject:@"3 Months"];
        
        if ([selectedCardType isEqualToString:@"Contractor_Pass"]) {
            [durationArray addObject:@"4 Months"];
            [durationArray addObject:@"5 Months"];
        }
        
        [durationArray addObject:@"6 Months"];
        [durationArray addObject:@"1 Year"];
    }
}

- (void)getCardRecordType {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSArray *recordTypesArray = [dict objectForKey:@"records"];
        cardManagementRecordTypesDictionary = [NSMutableDictionary new];
        
        for (NSDictionary *obj in recordTypesArray) {
            NSString *objectType = [obj objectForKey:@"SobjectType"];
            NSString *developerName = [obj objectForKey:@"DeveloperName"];
            
            if([objectType isEqualToString:@"Case"] && [developerName isEqualToString:@"Access_Card_Request"])
                caseRecordTypeId = [obj objectForKey:@"Id"];
            
            if([objectType isEqualToString:@"Card_Management__c"])
                [cardManagementRecordTypesDictionary setObject:[obj objectForKey:@"Id"] forKey:[obj objectForKey:@"DeveloperName"]];
        }
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
#warning Handle Error
    };
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE (SobjectType = 'Case' AND DeveloperName = 'Access_Card_Request') OR (SObjectType = 'Card_Management__c')";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)getServiceAdministrator {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        for (NSDictionary *recordDict in records) {
            NSArray *documentRecordsArray = [NSArray new];
            if(![[recordDict objectForKey:@"eServices_Document_Checklists__r"] isKindOfClass:[NSNull class]])
                documentRecordsArray = [[recordDict objectForKey:@"eServices_Document_Checklists__r"] objectForKey:@"records"];
            
            selectedService = [[EServiceAdministration alloc] initEServiceAdministration:recordDict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseServicesViewController hideLoadingDialog];
            /*
             NSString *balanceStr = [HelperClass formatNumberToString:selectedService.amount
             FormatStyle:NSNumberFormatterDecimalStyle
             MaximumFractionDigits:2];
             
             [self.servicePriceTextField setText:[NSString stringWithFormat:@"AED %@", balanceStr]];
             */
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseServicesViewController hideLoadingDialog];
#warning Handle Error
        });
    };
    
    [self.baseServicesViewController showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries cardTypeQueryForDuration:[durationArray objectAtIndex:selectedDurationIndexPath.row]
                                                                              CardType:[cardTypesValuesArray objectAtIndex:selectedCardTypeIndexPath.row]]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (BOOL)validateInput {
    BOOL shouldPerform = YES;
    
    if (!(selectedCardTypeIndexPath && selectedDurationIndexPath)) {
        shouldPerform = NO;
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];
    }
    
    return shouldPerform;
}

- (void)prepareForNextFlowPage {
    
    NSString *webFormID = @"";
    
    switch (self.baseServicesViewController.relatedServiceType) {
        case RelatedServiceTypeReplaceCard:
            webFormID = selectedService.replaceVFGenerator;
            break;
        case RelatedServiceTypeCancelCard:
            webFormID = selectedService.cancelVFGenerator;
            break;
        case RelatedServiceTypeRenewCard:
            webFormID = selectedService.renewVFGenerator;
            break;
        default:
            webFormID = selectedService.editNewVFGenerator;
            break;
    }
    
    self.baseServicesViewController.currentWebformId = webFormID;
    self.baseServicesViewController.currentServiceAdministration = selectedService;
    
    NSMutableDictionary *caseFieldsMutableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  selectedService.Id, @"Service_Requested__c",
                                                  [Globals currentAccount].Id, @"AccountId",
                                                  caseRecordTypeId, @"RecordTypeId",
                                                  @"Draft", @"Status",
                                                  @"Access Card Services", @"Type",
                                                  @"Mobile", @"Origin",
                                                  nil];
    
    if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeCancelCard)
        [caseFieldsMutableDict setObject:self.baseServicesViewController.currentCardManagement.Id forKey:@"Card_Management__c"];
    
    self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithDictionary:caseFieldsMutableDict];
    
    NSString *recordTypeId = [cardManagementRecordTypesDictionary objectForKey:selectedService.recordTypePicklist];
    NSString *selectedDuration = [durationArray objectAtIndex:selectedDurationIndexPath.row];
    
    NSMutableDictionary *serviceFieldsMutableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     recordTypeId, @"RecordTypeId",
                                                     nil];
    
    switch (self.baseServicesViewController.relatedServiceType) {
        case RelatedServiceTypeRenewCard:
            [serviceFieldsMutableDict setObject:self.baseServicesViewController.currentCardManagement.Id forKey:@"Renewal_For__c"];
            break;
        case RelatedServiceTypeReplaceCard:
            [serviceFieldsMutableDict setObject:self.baseServicesViewController.currentCardManagement.Id forKey:@"Lost_Card__c"];
        default:
            break;
    }
    
    
    
    self.baseServicesViewController.serviceFields = [NSDictionary dictionaryWithDictionary:serviceFieldsMutableDict];
    
    self.baseServicesViewController.parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [Globals currentAccount].name, @"actName",
                                                  [Globals currentAccount].Id, @"accountID",
                                                  selectedDuration, @"Dur",
                                                  nil];
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
}

- (void)showLoadingDialog {
    [self.baseServicesViewController showLoadingDialog];
}

- (void)hideLoadingDialog {
    [self.baseServicesViewController hideLoadingDialog];
}

- (void)courierFieldsSetHidden:(BOOL)hidden {
    [self.courierRateLabel setHidden:hidden];
    [self.courierRateTextField setHidden:hidden];
}

- (void)setCourierValuesToFields {
    [self.courierRateTextField setText:[NSString stringWithFormat:@"AED %@", retailCourierRate]];
}

- (void)getAramexRates {
    
    // Manually set up request object
    SFRestRequest *aramexRequest = [[SFRestRequest alloc] init];
    aramexRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileAramexRateWebService"];
    aramexRequest.method = SFRestMethodGET;
    
    Account *currentAccount = [Globals currentAccount];
    
    aramexRequest.path = [NSString stringWithFormat:@"/services/apexrest/MobileAramexRateWebService?city=%@&country=%@", currentAccount.billingCity, [currentAccount.billingCountry encodeToPercentEscapeString]];
    
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] send:aramexRequest delegate:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    courierChargesLoaded = YES;
    
    retailCourierRate =  [HelperClass stringCheckNull:[dict objectForKey:@"retailAmount"]];
    corporateCourierRate = [HelperClass stringCheckNull:[dict objectForKey:@"amount"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        
        [self setCourierValuesToFields];
        [self courierFieldsSetHidden:NO];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
        [self hideLoadingDialog];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
        [self hideLoadingDialog];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
        [self hideLoadingDialog];
    });
}

@end
