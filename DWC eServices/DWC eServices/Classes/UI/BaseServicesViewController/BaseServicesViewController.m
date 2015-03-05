//
//  BaseServicesViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "BaseServicesViewController.h"
#import "FVCustomAlertView.h"
#import "EServiceAdministration.h"
#import "NewNOCViewController.h"
#import "NewCardViewController.h"
#import "ServicesDynamicFormViewController.h"
#import "ServicesUploadViewController.h"
#import "ServicesReviewViewController.h"
#import "Stack.h"
#import "UIViewController+ChildViewController.h"
#import "HelperClass.h"
#import "SFRestAPI+Blocks.h"
#import "Globals.h"
#import "Account.h"
#import "EServiceDocument.h"
#import "SOQLQueries.h"
#import "WebForm.h"
#import "FormField.h"

@interface BaseServicesViewController ()

@end

@implementation BaseServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.showSlidingMenu = NO;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backButtonPressed)];
    viewControllersStack = [[Stack alloc] init];
    [self showServiceFlow];
}

- (void)backButtonPressed {
    
    if (self.backAction) {
        self.backAction();
    }
    
    if (viewControllersStack.count <= 1) {
        if (self.relatedServiceType == RelatedServiceTypeViewMyRequest)
            [self popServicesViewController];
        else
            [self cancelServiceButtonClicked];
    }
    else
        [self popChildViewController];
    
}

- (void)initializeCaseId:(NSString *)caseId {
    insertedCaseId = caseId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)hasAttachments {
    return [self.currentServiceAdministration hasDocuments];
}

- (NSString *)getCaseReviewQuery {
    NSString *returnQuery;
    
    switch (self.relatedServiceType) {
        case RelatedServiceTypeNewNOC:
        case RelatedServiceTypeNewCard:
        case RelatedServiceTypeViewMyRequest:
            returnQuery = [SOQLQueries caseReviewQuery:insertedCaseId Fields:self.currentWebForm.formFields RelatedObject:self.currentWebForm.objectName];
            break;
        default:
            returnQuery = @"";
            break;
    }
    
    return returnQuery;
}

- (void)cancelServiceButtonClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ConfirmAlertTitle", @"")
                                                                   message:NSLocalizedString(@"CancelServiceAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          NSLog(@"Yes action");
                                                          [self popServicesViewController];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action){
                                                         NSLog(@"No action");
                                                     }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)nextButtonClicked:(ServiceFlowPageType)currentServiceFlowPageType {
    
    switch (currentServiceFlowPageType) {
        case ServiceFlowInitialPage:
            [self showFieldsFlowPage];
            break;
        case ServiceFlowFieldsPage:
            [self createCaseRecord];
            break;
        case ServiceFlowAttachmentsPage:
            [self createCompanyDocuments:self.currentServiceAdministration.serviceDocumentsArray];
            break;
        case ServiceFlowReviewPage:
            break;
        default:
            break;
    }
}

- (void)popServicesViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popChildViewController {
    UIViewController *currentVC = [viewControllersStack popObject];
    [self removeChildVC:currentVC];
}

- (void)initializeButtonsWithNextAction:(SEL)nextAction target:(id)target {
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"Black Button Background"] forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
    [self.cancelButton addTarget:self action:@selector(cancelServiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextButton setTitle:NSLocalizedString(@"next", @"") forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"Blue Button Background"] forState:UIControlStateNormal];
    [self.nextButton.titleLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
    [self.nextButton addTarget:target action:nextAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

- (void)showServiceFlow {
    switch (self.relatedServiceType) {
        case RelatedServiceTypeNewNOC:
            [self showNOCServiceFlow];
            break;
        case RelatedServiceTypeNewCard:
            [self showCardServiceFlow];
            break;
        case RelatedServiceTypeRenewCard:
            
            break;
        case RelatedServiceTypeCancelCard:
            
            break;
        case RelatedServiceTypeReplaceCard:
            
            break;
        case RelatedServiceTypeNewVisa:
            
            break;
        case RelatedServiceTypeRenewVisa:
            
            break;
        case RelatedServiceTypeCancelVisa:
            
            break;
        case RelatedServiceTypeViewMyRequest:
            [self showViewMyRequestFlow];
            break;
        default:
            break;
    }
}

- (void)showViewMyRequestFlow {
    void (^returnBlock)(BOOL didSucceed) = ^(BOOL didSucceed) {
        if (didSucceed) {
            [self showReviewFlowPage];
        }
    };
    [self getWebFormWithReturnBlock:returnBlock];
}

- (void)showNOCServiceFlow {
    NewNOCViewController *newNOCViewController = [NewNOCViewController new];
    newNOCViewController.baseServicesViewController = self;
    [self.serviceFlowView addSubview:newNOCViewController.view];
    newNOCViewController.view.frame = self.serviceFlowView.bounds;
    newNOCViewController.view.bounds = self.serviceFlowView.bounds;
    [self addChildViewController:newNOCViewController];
    [newNOCViewController didMoveToParentViewController:self];
    [viewControllersStack pushObject:newNOCViewController];
}

- (void)showCardServiceFlow {
    NewCardViewController *newCardViewController = [NewCardViewController new];
    newCardViewController.baseServicesViewController = self;
    [self addChildViewController:newCardViewController toView:self.serviceFlowView];
    [viewControllersStack pushObject:newCardViewController];
}

- (void)showFieldsFlowPage {
    ServicesDynamicFormViewController *servicesDynamicFormVC = [ServicesDynamicFormViewController new];
    servicesDynamicFormVC.baseServicesViewController = self;
    
    [self addChildViewController:servicesDynamicFormVC toView:self.serviceFlowView];

    [viewControllersStack pushObject:servicesDynamicFormVC];
}

- (void)showAttachmentsFlowPage {
    ServicesUploadViewController *servicesUploadVC = [ServicesUploadViewController new];
    servicesUploadVC.baseServicesViewController = self;
    [self addChildViewController:servicesUploadVC toView:self.serviceFlowView];
    [viewControllersStack pushObject:servicesUploadVC];
}

- (void)showReviewFlowPage {
    ServicesReviewViewController *servicesReviewVC = [ServicesReviewViewController new];
    servicesReviewVC.baseServicesViewController = self;
    [self addChildViewController:servicesReviewVC toView:self.serviceFlowView];
    [viewControllersStack pushObject:servicesReviewVC];
}

- (void)createCaseRecord {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        if (dict != nil)
            insertedCaseId = [dict objectForKey:@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self createServiceRecord:insertedCaseId];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
            [self hideLoadingDialog];
        });
        
    };
    [self showLoadingDialog];
    
    NSMutableDictionary *mutableCaseFields = [NSMutableDictionary dictionaryWithDictionary:self.caseFields];
    [mutableCaseFields setObject:self.currentServiceAdministration.Id forKey:@"Service_Requested__c"];
    [mutableCaseFields setObject:self.currentWebForm.Id forKey:@"Visual_Force_Generator__c"];
    
    if(insertedCaseId != nil && ![insertedCaseId  isEqual: @""])
        [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Case"
                                                       objectId:insertedCaseId
                                                         fields:self.caseFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    else
        [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Case"
                                                         fields:self.caseFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
}

- (void)createServiceRecord:(NSString*)caseId {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        if (dict != nil)
            insertedServiceId = [dict objectForKey:@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self updateCaseObject:caseId ServiceId:insertedServiceId];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
        
    };
    
    [self showLoadingDialog];
    
    NSMutableDictionary *mutableServiceFields = [NSMutableDictionary dictionaryWithDictionary:self.serviceFields];
    [mutableServiceFields setObject:insertedCaseId forKey:@"Request__c"];
    [mutableServiceFields setObject:self.currentWebForm.Id forKey:@"Web_Form__c"];
    
    if (insertedServiceId != nil && ![insertedServiceId isEqualToString:@""])
        [[SFRestAPI sharedInstance] performUpdateWithObjectType:self.currentWebForm.objectName
                                                       objectId:insertedServiceId
                                                         fields:mutableServiceFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    else
        [[SFRestAPI sharedInstance] performCreateWithObjectType:self.currentWebForm.objectName
                                                         fields:mutableServiceFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
}

- (void)updateCaseObject:(NSString*)caseId ServiceId:(NSString*)ServiceId {
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            ServiceId, self.currentWebForm.objectName,
                            nil];
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            
            if ([self hasAttachments])
                [self showAttachmentsFlowPage];
            else
                [self showReviewFlowPage];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Case"
                                                   objectId:caseId
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

- (void)createCompanyDocuments:(NSArray *)documentsArray {
    totalAttachmentsToUpload = documentsArray.count;
    attachmentsReturned = 0;
    failedImagedArray = [NSMutableArray new];
    
    for (EServiceDocument *doc in documentsArray) {
        NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                                doc.name, @"Name",
                                doc.Id, @"eServices_Document__c",
                                [Globals currentAccount].Id, @"Company__c",
                                insertedServiceId, self.currentWebForm.objectName,
                                nil];
        
        void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
            NSString *companyDocumentId = [dict objectForKey:@"id"];
            doc.companyDocumentId = companyDocumentId;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addAttachment:doc];
            });
        };
        
        void (^errorBlock) (NSError*) = ^(NSError *e) {
#warning Handle error
        };
        
        if (doc.companyDocumentId != nil && ![doc.companyDocumentId isEqualToString:@""] && !doc.attachmentUploaded) {
            [self addAttachment:doc];
        }
        else if (!doc.attachmentUploaded) {
            [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Company_Documents__c"
                                                             fields:fields
                                                          failBlock:errorBlock
                                                      completeBlock:successBlock];
        }
    }
}

- (void)addAttachment:(EServiceDocument*)document {
    //UIImage *resizedImage = [HelperClass imageWithImage:image ScaledToSize:CGSizeMake(480, 640)];
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        
        [failedImagedArray addObject:document];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadDidReturn];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadDidReturn];
        });
    };

    NSString *string = [document.attachment base64EncodedStringWithOptions:0];
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            document.name, @"Name",
                            @"image", @"ContentType",
                            document.companyDocumentId, @"ParentId",
                            string, @"Body",
                            nil];
    
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Attachment"
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
    
}

- (void)uploadDidReturn {
    attachmentsReturned++;
    
    if (attachmentsReturned == totalAttachmentsToUpload) {
        [self hideLoadingDialog];
        
        if (failedImagedArray.count > 0) {
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"DocumentsUploadAlertMessage", @"")];
        }
        else {
            [self showReviewFlowPage];
        }
    }
}

- (void)callPayAndSubmitWebservice {
    
    // Manually set up request object
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobilePayAndSubmitWebService"];
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = @"/services/apexrest/MobilePayAndSubmitWebService";
    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:insertedCaseId forKey:@"caseId"];
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}

- (void)getWebFormWithReturnBlock:(void (^)(BOOL))returnBlock {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        for (NSDictionary *dict in records) {
            self.currentWebForm = [[WebForm alloc] initWebForm:[dict objectForKey:@"Id"]
                                                          Name:[dict objectForKey:@"Name"]
                                                   Description:[dict objectForKey:@"Description__c"]
                                                         Title:[dict objectForKey:@"Title__c"]
                                            IsNotesAttachments:[[dict objectForKey:@"isNotesAttachments__c"] boolValue]
                                                   ObjectLabel:[dict objectForKey:@"Object_Label__c"]
                                                    ObjectName:[dict objectForKey:@"Object_Name__c"]];
            NSMutableArray *fieldsArray = [[NSMutableArray alloc] init];
            
            NSDictionary *fieldsJSONArray = [NSDictionary new];
            if (![[dict objectForKey:@"R00N70000002DiOrEAK__r"] isKindOfClass:[NSNull class]])
                fieldsJSONArray = [[dict objectForKey:@"R00N70000002DiOrEAK__r"] objectForKey:@"records"];
            
            for (NSDictionary *fieldsDict in fieldsJSONArray) {
                /*
                 if([[fieldsDict objectForKey:@"Type__c"] isEqualToString:@"CUSTOMTEXT"])
                 continue;
                 */
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
            
            self.currentWebForm.formFields = [NSArray arrayWithArray:fieldsArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoadingDialog];
                
                if (returnBlock) {
                    returnBlock(YES);
                }
                //[self getFormFieldsValues];
            });
        }
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
#warning handle error here
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            
            if (returnBlock) {
                returnBlock(NO);
            }
        });
    };
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT Id, Name, Description__c, Title__c, isNotesAttachments__c, Object_Label__c, Object_Name__c, (SELECT Id, Name, APIRequired__c, Boolean_Value__c, Currency_Value__c, DateTime_Value__c, Date_Value__c, Email_Value__c , Hidden__c, isCalculated__c, isParameter__c, isQuery__c, Label__c, Number_Value__c, Order__c, Percent_Value__c, Phone_Value__c, Picklist_Value__c, PicklistEntries__c, Required__c, Text_Area_Long_Value__c, Text_Area_Value__c, Text_Value__c, Type__c, URL_Value__c, Web_Form__c, Width__c, isMobileAvailable__c, Mobile_Label__c, Mobile_Order__c  FROM R00N70000002DiOrEAK WHERE isMobileAvailable__c = true ORDER BY Mobile_Order__c) FROM Web_Form__c WHERE ID = '%@'", self.currentWebformId];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    [self showLoadingDialog];
    
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ThanksAlertTitle", @"")
                                            message:NSLocalizedString(@"ApplicationSubmittedAlertMessage", @"")
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
    });
#warning Handle error
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
    });
#warning Handle error
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
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
