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
        
        NSString *requestNumber;
        NSString *requestStatus;
        NSString *requestType;
        NSString *requestCreatedDate;
        NSNumber *totalAmount = 0;
        BOOL isCourierRequired;
        NSArray *formFieldsArray;
        
        for (NSDictionary *dict in records) {
            requestNumber = [HelperClass stringCheckNull:[dict objectForKey:@"CaseNumber"]];
            requestStatus =[HelperClass stringCheckNull:[dict objectForKey:@"Status"]];
            requestType = [HelperClass stringCheckNull:[dict objectForKey:@"Type"]];
            requestCreatedDate = [HelperClass stringCheckNull:[dict objectForKey:@"CreatedDate"]];
            
            
            
            NSArray *invoicesArray = [dict objectForKey:@"Invoices__r"];
            if(![invoicesArray isKindOfClass:[NSNull class]]) {
                for (NSDictionary *invoiceDict in invoicesArray) {
                    NSNumber *currentAmount = [invoiceDict objectForKey:@"Amount__c"];
                    totalAmount = [NSNumber numberWithFloat:([totalAmount floatValue] + [currentAmount floatValue])];
                }
            }
            
            NSString *parentLookup;
            switch (self.baseServicesViewController.relatedServiceType) {
                case RelatedServiceTypeNewNOC:
                    parentLookup = @"NOC__r";
                    break;
                case RelatedServiceTypeNewCard:
                    parentLookup = @"Card_Management__r";
                    break;
                default:
                    parentLookup = @"";
                    break;
            }
            
            NSDictionary *serviceDict = [dict objectForKey:parentLookup];

            isCourierRequired = [[serviceDict objectForKey:@"isCourierRequired__c"] boolValue];
            
            formFieldsArray = [[NSMutableArray alloc] initWithArray:self.baseServicesViewController.currentWebForm.formFields
                                                          copyItems:YES];
            
            for (FormField *field in formFieldsArray) {
                [field setFormFieldValue:[serviceDict objectForKey:field.name]];
                field.isCalculated = true;
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

- (void)displayReviewForm:(NSString *)requestNumber requestStatus:(NSString *)requestStatus requestType:(NSString *)requestType requestCreatedDate:(NSString *)requestCreatedDate totalAmount:(NSNumber *)totalAmount isCourierRequired:(BOOL) isCourierRequired formFieldsArray:(NSArray *)formFieldsArray {
    [self initServiceFieldsContentView];
    NSDate *createdDate = [SFDateUtil SOQLDateTimeStringToDate:requestCreatedDate];
    
    [servicesContentView drawReviewForm:requestNumber
                          requestStatus:requestStatus
                            requestType:requestType
                     requestCreatedDate:[HelperClass formatDateToString:createdDate]
                            totalAmount:totalAmount
                      isCourierRequired:isCourierRequired
                        formFieldsArray:formFieldsArray
                           cancelButton:self.baseServicesViewController.cancelButton
                             nextButton:self.baseServicesViewController.nextButton];
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
