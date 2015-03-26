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
#import "ServicesUploadViewController.h"
#import "BaseServicesViewController.h"

@interface ServicesDynamicFormViewController ()

@end

@implementation ServicesDynamicFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.baseServicesViewController initializeButtonsWithNextAction:@selector(nextButtonClicked:) target:self];
    
    void (^returnBlock)(BOOL didSucceed) = ^(BOOL didSucceed) {
        if (didSucceed) {
            [self getFormFieldsValues];
        }
    };
    
    if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeContractRenewal)
        [self displayWebForm];
    else
        [self.baseServicesViewController getWebFormWithReturnBlock:returnBlock];
}

- (void)viewWillAppear:(BOOL)animated {
    // Register for the events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)nextButtonClicked:(id)sender {
    if (![self validateInput]) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];
        return;
    }
    
    NSMutableDictionary *newFields = [NSMutableDictionary dictionaryWithDictionary:self.baseServicesViewController.serviceFields];
    
    if ([self.baseServicesViewController.currentWebForm.objectName isEqualToString:@"Case"])
        newFields = [NSMutableDictionary dictionaryWithDictionary:self.baseServicesViewController.caseFields];
    else
        newFields = [NSMutableDictionary dictionaryWithDictionary:self.baseServicesViewController.serviceFields];
    
    for (FormField *formField in self.baseServicesViewController.currentWebForm.formFields) {
        if(!formField.isCalculated && ![formField.type isEqualToString:@"CUSTOMTEXT"])
            [newFields setValue:[formField getFormFieldValue] forKey:formField.name];
    }
    
    if ([self.baseServicesViewController.currentWebForm.objectName isEqualToString:@"Case"]) {
        self.baseServicesViewController.serviceFields = self.baseServicesViewController.serviceFields;
        self.baseServicesViewController.caseFields = [NSDictionary dictionaryWithDictionary:newFields];
    } else {
        self.baseServicesViewController.serviceFields = [NSDictionary dictionaryWithDictionary:newFields];
        self.baseServicesViewController.caseFields = self.baseServicesViewController.caseFields;
    }
    ServiceFlowPageType serviceFlowPage;
    if ([self.baseServicesViewController.currentServiceAdministration hasDocuments]) {
        serviceFlowPage = ServiceFlowAttachmentsPage;
    }
    else {
        serviceFlowPage = ServiceFlowReviewPage;
    }
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowFieldsPage];
}

- (void)getFormFieldsValues {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        if(records.count <= 0)
            return;
        
        NSDictionary *visaObject = [records objectAtIndex:0];
        
        for (FormField *formField in self.baseServicesViewController.currentWebForm.formFields) {
            if(!formField.isQuery)
                continue;
            
            [formField setFormFieldValue:[HelperClass getRelationshipValue:visaObject Key:formField.textValue]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayWebForm];
            [self.baseServicesViewController hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
#warning handle error here
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseServicesViewController hideLoadingDialog];
        });
    };
    
    NSMutableString *selectQuery = [NSMutableString stringWithString:@"SELECT Id"];
    
    BOOL queryFields = NO;
    for (FormField *formField in self.baseServicesViewController.currentWebForm.formFields) {
        if (formField.isParameter) {
            [formField setFormFieldValue:[self.baseServicesViewController.parameters objectForKey:formField.textValue]];
        }
        
        if(!formField.isQuery)
            continue;
        
        queryFields = YES;
        [selectQuery appendFormat:@", %@", formField.textValue];
    }
    
    if (queryFields) {
        [selectQuery appendFormat:@" FROM Visa__c WHERE ID = '%@' LIMIT 1", self.baseServicesViewController.currentVisaObject.Id];
        
        [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                           failBlock:errorBlock
                                       completeBlock:successBlock];
        
        [self.baseServicesViewController showLoadingDialog];
    }
    else {
        [self displayWebForm];
    }
}

- (void)displayWebForm {
    [self initServiceFieldsContentView];
    [servicesContentView drawWebform:self.baseServicesViewController.currentWebForm
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

- (BOOL)validateInput {
    BOOL returnValue = YES;
    for (FormField *formField in self.baseServicesViewController.currentWebForm.formFields) {
        if(formField.required && [[formField getFormFieldValue] isEqualToString:@""])
            returnValue = NO;
    }
    
    return returnValue;
}

#pragma KeyBoard Notifications
-(void) keyboardDidShow: (NSNotification *)notif {
    NSDictionary *userInfo = [notif userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the top
    // of the keyboard's final position.
    //
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newBiddingViewFrame = self.view.bounds;
    newBiddingViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    scrollViewOffset = self.servicesScrollView.contentOffset;
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.servicesScrollView.frame = newBiddingViewFrame;
    
    //CGRect textFieldRect = [self.answerTextView frame];
    //textFieldRect.origin.y += 10;
    //[self.servicesScrollView scrollRectToVisible:textFieldRect animated:YES];
    
    [UIView commitAnimations];
}

-(void) keyboardDidHide: (NSNotification *)notif {
    NSDictionary *userInfo = [notif userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.servicesScrollView.frame = self.view.bounds;
    
    // Reset the scrollview to previous location
    self.servicesScrollView.contentOffset = scrollViewOffset;
    
    [UIView commitAnimations];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

@end
