//
//  NeedHelpViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/5/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NeedHelpViewController.h"
#import "PickerTableViewController.h"
#import "SFRestAPI+Blocks.h"
#import "RecordType.h"
#import "FVCustomAlertView.h"
#import "HelperClass.h"
#import "NSString+SFAdditions.h"
#import "Globals.h"
#import "Account.h"
#import "ServicesThankYouViewController.h"
#import "UIViewController+ChildViewController.h"
#import "Request.h"

@interface NeedHelpViewController ()

@end

@implementation NeedHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:NSLocalizedString(@"navBarNeedHelpTitle", @"")];
    
    caseTypesArray = @[@"Inquiry", @"Suggestion", @"Complaint"];
    
    selectedCaseTypeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self refreshCaseTypeButton];
    
    [self loadCaseRecordType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshCaseTypeButton {
    [self.caseTypeButton setTitle:[caseTypesArray objectAtIndex:selectedCaseTypeIndexPath.row] forState:UIControlStateNormal];
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
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Customer_Inquiry'";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (BOOL)validateInput {
    BOOL returnValue = YES;
    
    if ([self.subjectTextField.text isEmptyOrWhitespaceAndNewlines])
        return NO;
    
    if ([self.descriptionTextArea.text isEmptyOrWhitespaceAndNewlines])
        return NO;
    
    if (!selectedCaseTypeIndexPath)
        return NO;
    
    return returnValue;
}

- (void)insertCase {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSString *caseId = [dict objectForKey:@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            
            [self getCaseDetails:caseId];
            
        });
    };
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            caseRecordType.Id, @"Type",
                            [Globals contactId], @"ContactId",
                            [Globals currentAccount].Id, @"AccountId",
                            self.subjectTextField.text, @"Subject",
                            self.descriptionTextArea.text, @"Description",
                            nil];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Case"
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

- (void)getCaseDetails:(NSString *)caseId {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        Request *currentCase;
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            currentCase = [[Request alloc] initRequest:obj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            
            ServicesThankYouViewController *servicesThankYouVC = [ServicesThankYouViewController new];
            servicesThankYouVC.isNeedHelp = YES;
            servicesThankYouVC.needHelpCaseNumber = currentCase.caseNumber;
            
            [self addChildViewController:servicesThankYouVC toView:self.containerView];
        });
    };
    
    NSString *soqlQuery = [NSString stringWithFormat:@"SELECT Id, CaseNumber FROM Case WHERE ID = '%@'", caseId];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:soqlQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (IBAction)submitButtonClicked:(id)sender {
    if (![self validateInput]) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];
        return;
    }
    
    [self insertCase];
}

- (IBAction)caseTypeButtonClicked:(id)sender {
    
    UIButton *senderButton = sender;
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = caseTypesArray;
    pickerTableVC.selectedIndexPath = selectedCaseTypeIndexPath;
    pickerTableVC.valuePicked = ^(NSString *value, NSIndexPath *indexPath, PickerTableViewController *picklist) {
        selectedCaseTypeIndexPath = indexPath;
        [self refreshCaseTypeButton];
        [picklist dismissPopover:YES];
    };
    
    [pickerTableVC showPopoverFromView:senderButton];
}

@end
