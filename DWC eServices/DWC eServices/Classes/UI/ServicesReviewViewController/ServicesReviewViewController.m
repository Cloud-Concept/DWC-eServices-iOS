//
//  ServicesReviewViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ServicesReviewViewController.h"
#import "SFRestAPI+Blocks.h"
#import "SOQLQueries.h"
#import "HelperClass.h"
#import "WebForm.h"
#import "FormField.h"
#import "UIView+DynamicForm.h"
#import "BaseServicesViewController.h"
#import "SFDateUtil.h"
#import "Invoice.h"

@interface ServicesReviewViewController ()

@end

@implementation ServicesReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.baseServicesViewController initializeButtonsWithNextAction:@selector(payAndSubmitButtonClicked:) target:self];
    
    [self.baseServicesViewController.nextButton setTitle:NSLocalizedString(@"PayAndSubmitButton", @"")
                                                forState:UIControlStateNormal];;
    
    [self getCaseDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)payAndSubmitButtonClicked:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ConfirmAlertTitle", @"")
                                                                             message:NSLocalizedString(@"PayAndSubmitAlertMessage", @"")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self.baseServicesViewController callPayAndSubmitWebservice];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getCaseDetails {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        NSLog(@"request:didLoadResponse: #records: %d", records.count);
        
        NSString *requestPersonName;
        NSString *requestNumber;
        NSString *requestStatus;
        NSString *requestType;
        NSString *requestCreatedDate;
        NSString *requestRejectionReason;
        NSNumber *totalAmount = 0;
        BOOL isCourierRequired;
        NSArray *formFieldsArray;
        
        for (NSDictionary *dict in records) {
            requestNumber = [HelperClass stringCheckNull:[dict objectForKey:@"CaseNumber"]];
            self.baseServicesViewController.createdCaseNumber = requestNumber;
            requestStatus =[HelperClass stringCheckNull:[dict objectForKey:@"Status"]];
            requestType = [HelperClass stringCheckNull:[dict objectForKey:@"Type"]];
            requestCreatedDate = [HelperClass stringCheckNull:[dict objectForKey:@"CreatedDate"]];
            isCourierRequired = [[dict objectForKey:@"isCourierRequired__c"] boolValue];
            requestRejectionReason = [HelperClass stringCheckNull:[dict objectForKey:@"Application_Rejection_Reason__c"]];
            
            NSDictionary *employeeRefDict = [dict objectForKey:@"Employee_Ref__r"];
            if (![employeeRefDict isKindOfClass:[NSNull class]])
                requestPersonName = [employeeRefDict objectForKey:@"Name"];
            
            NSDictionary *serviceRequestedDict = [dict objectForKey:@"Service_Requested__r"];
            if(![serviceRequestedDict isKindOfClass:[NSNull class]]) {
                totalAmount = [serviceRequestedDict objectForKey:@"Total_Amount__c"];
            }
            
            NSDictionary *invoicesArray = [dict objectForKey:@"Invoices__r"];
            if(![invoicesArray isKindOfClass:[NSNull class]]) {
                for (NSDictionary *invoiceDict in [invoicesArray objectForKey:@"records"]) {
                    Invoice *invoice = [[Invoice alloc] initInvoice:invoiceDict];
                    totalAmount = [NSNumber numberWithFloat:([totalAmount floatValue] + [invoice.amount floatValue])];
                }
            }
            invoicesArray = [dict objectForKey:@"Invoices1__r"];
            if(![invoicesArray isKindOfClass:[NSNull class]]) {
                for (NSDictionary *invoiceDict in [invoicesArray objectForKey:@"records"]) {
                    Invoice *invoice = [[Invoice alloc] initInvoice:invoiceDict];
                    totalAmount = [NSNumber numberWithFloat:([totalAmount floatValue] + [invoice.amount floatValue])];
                }
            }
            
            self.baseServicesViewController.createdCaseTotalPrice = totalAmount;
            
            NSString *parentLookup = [self.baseServicesViewController.currentWebForm.objectName stringByReplacingOccurrencesOfString:@"__c" withString:@"__r"];
            
            NSDictionary *serviceDict;
            
            if ([self.baseServicesViewController.currentWebForm.objectName isEqualToString:@"Case"])
                serviceDict = dict;
            else
                serviceDict = [dict objectForKey:parentLookup];

            
            
            formFieldsArray = [[NSMutableArray alloc] initWithArray:self.baseServicesViewController.currentWebForm.formFields
                                                          copyItems:YES];
            
            for (FormField *field in formFieldsArray) {
                if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeContractRenewal ||
                    self.baseServicesViewController.relatedServiceType == RelatedServiceTypeLicenseRenewal) {
                    
                    continue;
                }
                
                NSString *relationName = field.name;
                if ([field.type isEqualToString:@"REFERENCE"])
                    relationName = [field.name stringByReplacingOccurrencesOfString:@"__c" withString:@"__r.Name"];
                
                [field setFormFieldValue:[HelperClass getRelationshipValue:serviceDict Key:relationName]];
                field.isCalculated = true;
                
                if ([field.name isEqualToString:@"NOC_Receiver_Email__c"])
                    self.baseServicesViewController.createdCaseNOCEmailReceiver = [field getFormFieldValue];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseServicesViewController hideLoadingDialog];
            [self displayReviewForm:requestNumber
                      requestStatus:requestStatus
                        requestType:requestType
                 requestCreatedDate:requestCreatedDate
                        totalAmount:totalAmount
                  isCourierRequired:isCourierRequired
                  requestPersonName:requestPersonName
                    requestRejectionReason:requestRejectionReason
                    formFieldsArray:formFieldsArray];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseServicesViewController hideLoadingDialog];
#warning handle error here
        });
        
    };
    
    [self.baseServicesViewController showLoadingDialog];
    
    NSString *queryString = [self.baseServicesViewController getCaseReviewQuery];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:queryString
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)displayReviewForm:(NSString *)requestNumber requestStatus:(NSString *)requestStatus requestType:(NSString *)requestType requestCreatedDate:(NSString *)requestCreatedDate totalAmount:(NSNumber *)totalAmount isCourierRequired:(BOOL) isCourierRequired requestPersonName:(NSString *)requestPersonName requestRejectionReason:(NSString *)requestRejectionReason formFieldsArray:(NSArray *)formFieldsArray {
    [self initServiceFieldsContentView];
    NSDate *createdDate = [SFDateUtil SOQLDateTimeStringToDate:requestCreatedDate];
    
    UIButton *nextButton = self.baseServicesViewController.nextButton;
    UIButton *cancelButton = self.baseServicesViewController.cancelButton;
    
    if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeViewMyRequest) {
        cancelButton = nil;
        
        if (![requestStatus isEqualToString:@"Draft"]) {
            nextButton = nil;
        }
    }
    
    [HelperClass setRequestIconForImageView:self.requestIconImageView requestType:requestType];
    
    self.requestRefNumberValueLabel.text = requestNumber;
    self.requestDateValueLabel.text = [HelperClass formatDateToString:createdDate];
    self.requestStatusValueLabel.text = requestStatus;
    self.requestTypeValueLabel.text = requestType;
    
    //Show/Hide Total Amount
    if (self.baseServicesViewController.relatedServiceType != RelatedServiceTypeCancelCard) {
        self.requestTotalAmountValueLabel.text = [HelperClass formatNumberToString:totalAmount
                                                                       FormatStyle:NSNumberFormatterDecimalStyle
                                                             MaximumFractionDigits:2];
    }
    else {
        [self.requestTotalAmountValueLabel removeFromSuperview];
        [self.requestTotalAmountLabel removeFromSuperview];
    }
    
    if (requestPersonName) {
        self.requestPersonNameValueLabel.text = requestPersonName;
    }
    else {
        [self.requestPersonNameValueLabel removeFromSuperview];
        [self.requestPersonNameLabel removeFromSuperview];
    }
    
    if ([requestType isEqualToString:@"Access Card Services"] && [requestStatus isEqualToString:@"Application Rejected"]) {
        self.requestRejectionReasonValueLabel.text = requestRejectionReason;
    }
    else {
        [self.requestRejectionReasonValueLabel removeFromSuperview];
        [self.requestRejectionReasonLabel removeFromSuperview];
    }
    
    [servicesContentView drawReviewFormWithFormFieldsArray:formFieldsArray
                                              cancelButton:cancelButton
                                                nextButton:nextButton];
}

- (void)initServiceFieldsContentView {
    self.servicesScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    servicesContentView = [UIView new];
    servicesContentView.backgroundColor = [UIColor clearColor];
    servicesContentView.frame = self.servicesScrollView.frame;
    
    servicesContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.servicesScrollView addSubview:servicesContentView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(servicesContentView);
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [self.servicesScrollView addConstraint:[NSLayoutConstraint
                                            constraintWithItem:servicesContentView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.servicesScrollView
                                            attribute:NSLayoutAttributeWidth
                                            multiplier:1
                                            constant:0.0]];
    
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    [self.servicesScrollView addConstraints:constraint_POS_H];
    [self.servicesScrollView addConstraints:constraint_POS_V];
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
