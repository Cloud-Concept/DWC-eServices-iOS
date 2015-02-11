//
//  ServicesDynamicFormViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ServicesDynamicFormViewController.h"
#import "WebForm.h"
#import "FormField.h"
#import "HelperClass.h"
#import "SFRestAPI+Blocks.h"
#import "UIView+DynamicForm.h"
#import "Visa.h"
#import "EServiceAdministration.h"
#import "FVCustomAlertView.h"

@interface ServicesDynamicFormViewController ()

@end

@implementation ServicesDynamicFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showSlidingMenu = false;
    
    //[self initServiceFieldsContentView];
    
    [self getWebForm];
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

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:@"Loading..." withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

- (void)getWebForm {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        for (NSDictionary *dict in records) {
            currentWebForm = [[WebForm alloc] initWebForm:[dict objectForKey:@"Id"]
                                                     Name:[dict objectForKey:@"Name"]
                                              Description:[dict objectForKey:@"Description__c"]
                                                    Title:[dict objectForKey:@"Title__c"]
                                       IsNotesAttachments:[[dict objectForKey:@"isNotesAttachments__c"] boolValue]
                                              ObjectLabel:[dict objectForKey:@"Object_Label__c"]
                                               ObjectName:[dict objectForKey:@"Object_Name__c"]];
            NSMutableArray *fieldsArray = [[NSMutableArray alloc] init];
            
            NSDictionary *fieldsJSONArray = [[dict objectForKey:@"R00N70000002DiOrEAK__r"] objectForKey:@"records"];
            for (NSDictionary *fieldsDict in fieldsJSONArray) {
                if([[fieldsDict objectForKey:@"Type__c"] isEqualToString:@"CUSTOMTEXT"])
                    continue;
                
                [fieldsArray addObject:[[FormField alloc] initFormField:[fieldsDict objectForKey:@"Id"]
                                                                   Name:[fieldsDict objectForKey:@"Name"]
                                                            APIRequired:[[fieldsDict objectForKey:@"APIRequired__c"] boolValue]
                                                           BooleanValue:[[fieldsDict objectForKey:@"Boolean_Value__c"] boolValue]
                                                          CurrencyValue:[fieldsDict objectForKey:@"Currency_Value__c"]
                                                          DateTimeValue:[fieldsDict objectForKey:@"DateTime_Value__c"]
                                                              DateValue:[fieldsDict objectForKey:@"Date_Value__c"]
                                                             EmailValue:[fieldsDict objectForKey:@"Email_Value__c"]
                                                                 Hidden:[[fieldsDict objectForKey:@"Hidden__c"] boolValue]
                                                           IsCalculated:[[fieldsDict objectForKey:@"isCalculated__c"] boolValue]
                                                            IsParameter:[[fieldsDict objectForKey:@"isParameter__c"] boolValue]
                                                                IsQuery:[[fieldsDict objectForKey:@"isQuery__c"] boolValue]
                                                                  Label:[fieldsDict objectForKey:@"Label__c"]
                                                            NumberValue:[fieldsDict objectForKey:@"Number_Value__c"]
                                                                  Order:[fieldsDict objectForKey:@"Order__c"]
                                                           PercentValue:[fieldsDict objectForKey:@"Percent_Value__c"]
                                                             PhoneValue:[fieldsDict objectForKey:@"Phone_Value__c"]
                                                          PicklistValue:[fieldsDict objectForKey:@"Picklist_Value__c"]
                                                        PicklistEntries:[fieldsDict objectForKey:@"PicklistEntries__c"]
                                                               Required:[[fieldsDict objectForKey:@"Required__c"] boolValue]
                                                      TextAreaLongValue:[fieldsDict objectForKey:@"Text_Area_Long_Value__c"]
                                                          TextAreaValue:[fieldsDict objectForKey:@"Text_Area_Value__c"]
                                                              TextValue:[fieldsDict objectForKey:@"Text_Value__c"]
                                                                   Type:[fieldsDict objectForKey:@"Type__c"]
                                                               UrlValue:[fieldsDict objectForKey:@"URL_Value__c"]
                                                                WebForm:[fieldsDict objectForKey:@"Web_Form__c"]
                                                                  Width:[fieldsDict objectForKey:@"Width__c"]
                                                      IsMobileAvailable:[[fieldsDict objectForKey:@"isMobileAvailable__c"] boolValue]
                                                            MobileLabel:[fieldsDict objectForKey:@"Mobile_Label__c"]
                                                            MobileOrder:[fieldsDict objectForKey:@"Mobile_Order__c"]]];
            }
            
            currentWebForm.formFields = [NSArray arrayWithArray:fieldsArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoadingDialog];
                [self getFormFieldsValues];
            });
        }
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
#warning handle error here
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT Id, Name, Description__c, Title__c, isNotesAttachments__c, Object_Label__c, Object_Name__c, (SELECT Id, Name, APIRequired__c, Boolean_Value__c, Currency_Value__c, DateTime_Value__c, Date_Value__c, Email_Value__c , Hidden__c, isCalculated__c, isParameter__c, isQuery__c, Label__c, Number_Value__c, Order__c, Percent_Value__c, Phone_Value__c, Picklist_Value__c, PicklistEntries__c, Required__c, Text_Area_Long_Value__c, Text_Area_Value__c, Text_Value__c, Type__c, URL_Value__c, Web_Form__c, Width__c, isMobileAvailable__c, Mobile_Label__c, Mobile_Order__c  FROM R00N70000002DiOrEAK WHERE isMobileAvailable__c = true ORDER BY Mobile_Order__c) FROM Web_Form__c WHERE ID = '%@'", self.currentWebformId];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    [self showLoadingDialog];
    
}

- (void)getFormFieldsValues {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        if(records.count <= 0)
            return;
        
        NSDictionary *visaObject = [records objectAtIndex:0];
        
        for (FormField *formField in currentWebForm.formFields) {
            if(!formField.isQuery)
                continue;
            
            [formField setFormFieldValue:[HelperClass getRelationshipValue:visaObject Key:formField.textValue]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayWebForm];
            [self hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
#warning handle error here
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    NSMutableString *selectQuery = [NSMutableString stringWithString:@"SELECT Id"];
    
    BOOL queryFields = NO;
    for (FormField *formField in currentWebForm.formFields) {
        if(!formField.isQuery)
            continue;
        
        queryFields = YES;
        [selectQuery appendFormat:@", %@", formField.textValue];
    }
    
    if (queryFields) {
        [selectQuery appendFormat:@" FROM Visa__c WHERE ID = '%@' LIMIT 1", self.visaObject.Id];
        
        [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                           failBlock:errorBlock
                                       completeBlock:successBlock];
        
        [self showLoadingDialog];
    }
    else {
        [self displayWebForm];
    }
}

- (void)displayWebForm {
    [self initServiceFieldsContentView];
    [servicesContentView drawFormFields:currentWebForm];
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

@end
