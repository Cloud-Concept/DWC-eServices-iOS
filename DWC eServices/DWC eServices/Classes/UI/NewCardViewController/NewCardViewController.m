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

@interface NewCardViewController ()

@end

@implementation NewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeCardTypesDictionary];
    [self getCardRecordType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseCardTypeButtonClicked:(id)sender {
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

- (void)chooseDurationButtonClicked:(id)sender {
    durationArray = [NSMutableArray new];
    
    NSString *selectedCardType = [cardTypesValuesArray objectAtIndex:selectedCardTypeIndexPath.row];
    
    if (![selectedCardType isEqualToString:@""]) {
        if ([selectedCardType isEqualToString:@"Access_Card"])
            [durationArray addObject:@"1 Day"];
        
        if ([selectedCardType isEqualToString:@"Contractor_Card"])
            [durationArray addObject:@"1 Week"];
        
        [durationArray addObject:@"1 Month"];
        
        if ([selectedCardType isEqualToString:@"Contractor_Card"])
            [durationArray addObject:@"2 Months"];
        
        [durationArray addObject:@"3 Months"];
        
        if ([selectedCardType isEqualToString:@"Contractor_Card"]) {
            [durationArray addObject:@"4 Months"];
            [durationArray addObject:@"5 Months"];
        }
        
        [durationArray addObject:@"6 Months"];
        [durationArray addObject:@"1 Year"];
    }
    
    
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

- (void)nextButtonClicked:(id)sender {
    if ([self validateInput])
        [self prepareForNextFlowPage];
}

- (void)cancelButtonClicked:(id)sender {
    [self.baseServicesViewController cancelServiceButtonClicked];
}

- (void)resetDurationButtons {
    [self.chooseDurationButton setTitle:NSLocalizedString(@"chooseDurationButton", @"")
                               forState:UIControlStateNormal];
    selectedDurationIndexPath = nil;
}

- (void)resetAmountTextField {
    [self.servicePriceTextField setText:@"AED 0"];
}

- (void)initializeCardTypesDictionary {
    cardTypesDescriptionsArray = @[@"FM Contractor Pass", @"Contractor Pass", @"Work Permit Pass", @"Access Card", @"Replacement of Lost Employment Card"];
    cardTypesValuesArray = @[@"FM_Contractor_Card", @"Contractor_Card", @"Work_Permit_Card", @"Access_Card", @"Employment_Card"];
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
            
            selectedService = [[EServiceAdministration alloc] initEServiceAdministration:[recordDict objectForKey:@"Id"]
                                                                                         Name:[recordDict objectForKey:@"Name"]
                                                                            ServiceIdentifier:[recordDict objectForKey:@"Service_Identifier__c"]
                                                                                       Amount:[recordDict objectForKey:@"Amount__c"]
                                                                              RelatedToObject:[recordDict objectForKey:@"Related_to_Object__c"]
                                                                           NewEditVFGenerator:[recordDict objectForKey:@"New_Edit_VF_Generator__c"]
                                                                            CancelVFGenerator:[recordDict objectForKey:@"Cancel_VF_Generator__c"]
                                                                             RenewVFGenerator:[recordDict objectForKey:@"Renewal_VF_Generator__c"]
                                                                           ReplaceVFGenerator:[recordDict objectForKey:@"Replace_VF_Generator__c"]
                                                                           RecordTypePicklist:[recordDict objectForKey:@"Record_Type_Picklist__c"]
                                                                        ServiceDocumentsArray:documentRecordsArray];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseServicesViewController hideLoadingDialog];
            
            NSString *balanceStr = [HelperClass formatNumberToString:selectedService.amount
                                                         FormatStyle:NSNumberFormatterDecimalStyle
                                               MaximumFractionDigits:2];
            
            [self.servicePriceTextField setText:[NSString stringWithFormat:@"AED %@", balanceStr]];
            
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
    
    self.baseServicesViewController.currentWebformId = selectedService.editNewVFGenerator;
    self.baseServicesViewController.currentServiceAdministration = selectedService;
    
    self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  selectedService.Id, @"Service_Requested__c",
                                                  [Globals currentAccount].Id, @"AccountId",
                                                  caseRecordTypeId, @"RecordTypeId",
                                                  @"Draft", @"Status",
                                                  @"Access Card Services", @"Type",
                                                  @"Mobile", @"Origin",
                                                  nil];
    
    NSString *recordTypeId = [cardManagementRecordTypesDictionary objectForKey:selectedService.recordTypePicklist];
    NSString *selectedDuration = [durationArray objectAtIndex:selectedDurationIndexPath.row];
    
    self.baseServicesViewController.serviceFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     recordTypeId, @"RecordTypeId",
                                                     nil];
    
    self.baseServicesViewController.parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [Globals currentAccount].name, @"actName",
                                                  [Globals currentAccount].Id, @"accountID",
                                                  selectedDuration, @"Dur",
                                                  nil];
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
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
