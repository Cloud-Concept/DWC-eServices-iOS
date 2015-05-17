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
#import "ServicesThankYouViewController.h"
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
#import "ContractRenewalEditViewController.h"
#import "TenancyContract.h"
#import "Quote.h"
#import "LicenseRenewViewController.h"
#import "License.h"
#import "SFDateUtil.h"
#import "CardManagement.h"
#import "CompanyAmendmentViewController.h"
#import "NSString+SFAdditions.h"

@interface BaseServicesViewController ()

@end

@implementation BaseServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.hideSlidingMenu = YES;
    self.hideNotificationIcon = YES;
    
    __typeof(self) __weak weakSelf = self;
    self.navigationItemBackAction = ^(void) {
        [weakSelf backButtonPressed];
    };
    

    viewControllersStack = [[Stack alloc] init];
    [self showServiceFlow];
    
    [self initTimeline];
}

- (void)backButtonPressed {
    
    if (self.backAction && self.relatedServiceType != RelatedServiceTypeViewMyRequest) {
        //self.backAction();
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

- (void) hideAndDisableRightNavigationItem
{
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

- (void)initTimeline {
    
    if (self.relatedServiceType == RelatedServiceTypeViewMyRequest) {
        [self.timelineView removeFromSuperview];
    }
    
    timelineButtonsArray = [NSArray arrayWithObjects:self.timelineBulletOneButton, self.timelineBulletTwoButton, self.timelineBulletThreeButton, self.timelineBulletFourButton, self.timelineBulletFiveButton, nil];
    
    [self refreshTimeline];
}

- (void)refreshTimeline {
    
    for (NSInteger index = 0; index < timelineButtonsArray.count; index++) {
        
        NSString *buttonTitle = @"";
        NSString *buttonImageName = @"";
        
        if (index < currentServiceFlowType) {
            buttonTitle = @"";
            buttonImageName = @"Services Timeline Bullet Finished";
        }
        else if (index == currentServiceFlowType) {
            buttonTitle = [NSString stringWithFormat:@"%ld", (long)index + 1];
            buttonImageName = @"Services Timeline Bullet Current";
        }
        else if (index > currentServiceFlowType) {
            buttonTitle = [NSString stringWithFormat:@"%ld", (long)index + 1];
            buttonImageName = @"Services Timeline Bullet Next";
        }
        
        UIButton *currentButton = [timelineButtonsArray objectAtIndex:index];
        [currentButton setTitle:buttonTitle forState:UIControlStateNormal];
        [currentButton setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
    }
    
    [self refreshNavBarTitle];
    
}

- (void)refreshNavBarTitle {
    NSString *navBarTitle = @"";
    
    switch (self.relatedServiceType) {
        case RelatedServiceTypeNewEmployeeNOC:
        case RelatedServiceTypeNewCompanyNOC:
            navBarTitle = NSLocalizedString(@"navBarNewNOCTitle", @"");
            break;
        case RelatedServiceTypeNewCard:
            navBarTitle = NSLocalizedString(@"navBarNewCardTitle", @"");
            break;
        case RelatedServiceTypeReplaceCard:
            navBarTitle = NSLocalizedString(@"navBarReplaceCardTitle", @"");
            break;
        case RelatedServiceTypeCancelCard:
            navBarTitle = NSLocalizedString(@"navBarCancelCardTitle", @"");
            break;
        case RelatedServiceTypeRenewCard:
            navBarTitle = NSLocalizedString(@"navBarRenewCardTitle", @"");
            break;
        case RelatedServiceTypeNewVisa:
            
            break;
        case RelatedServiceTypeRenewVisa:
            
            break;
        case RelatedServiceTypeCancelVisa:
            
            break;
        case RelatedServiceTypeViewMyRequest:
            navBarTitle = NSLocalizedString(@"navBarViewMyRequestTitle", @"");
            break;
        case RelatedServiceTypeRegistrationDocuments:
            navBarTitle = NSLocalizedString(@"navBarRegistrationDocumentsTitle", @"");
            break;
        case RelatedServiceTypeContractRenewal:
            navBarTitle = NSLocalizedString(@"navBarRenewContractTitle", @"");
            break;
        case RelatedServiceTypeLicenseRenewal:
            navBarTitle = NSLocalizedString(@"navBarRenewLicenseTitle", @"");
            break;
        case RelatedServiceTypeCompanyAddressChange:
            navBarTitle = NSLocalizedString(@"navBarCompanyAddressChange", @"");
            break;
        case RelatedServiceTypeCompanyNameChange:
            navBarTitle = NSLocalizedString(@"navBarCompanyNameChange", @"");
            break;
        default:
            break;
    }
    
    switch (currentServiceFlowType) {
        case ServiceFlowInitialPage:
            break;
        case ServiceFlowFieldsPage:
            navBarTitle = NSLocalizedString(@"navBarDetails", @"");
            break;
        case ServiceFlowAttachmentsPage:
            navBarTitle = NSLocalizedString(@"navBarRequiredDocuments", @"");
            break;
        case ServiceFlowReviewPage:
            navBarTitle = NSLocalizedString(@"navBarPreview", @"");
            break;
        case ServiceFlowThankYouPage:
            navBarTitle = NSLocalizedString(@"navBarThankYou", @"");
            break;
        default:
            break;
    }
    
    [super setNavigationBarTitle:navBarTitle];
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
    
    NSString *relatedObjectName = (!self.serviceFieldCaseObjectName || [self.serviceFieldCaseObjectName isEmptyOrWhitespaceAndNewlines]) ? self.currentWebForm.objectName : self.serviceFieldCaseObjectName;
    
    switch (self.relatedServiceType) {
        case RelatedServiceTypeNewEmployeeNOC:
        case RelatedServiceTypeNewCompanyNOC:
        case RelatedServiceTypeNewCard:
        case RelatedServiceTypeRenewCard:
        case RelatedServiceTypeReplaceCard:
        case RelatedServiceTypeCancelCard:
        case RelatedServiceTypeViewMyRequest:
        case RelatedServiceTypeRegistrationDocuments:
        case RelatedServiceTypeCompanyAddressChange:
        case RelatedServiceTypeCompanyNameChange:
            returnQuery = [SOQLQueries caseReviewQuery:insertedCaseId Fields:self.currentWebForm.formFields RelatedObject:relatedObjectName];
            break;
        case RelatedServiceTypeContractRenewal:
            returnQuery = [SOQLQueries caseReviewQuery:insertedCaseId Fields:self.currentWebForm.formFields RelatedObject:@"Tenancy_Contract__c" AddRelatedFields:NO];
            break;
        case RelatedServiceTypeLicenseRenewal:
            returnQuery = [SOQLQueries caseReviewQuery:insertedCaseId Fields:self.currentWebForm.formFields RelatedObject:@"License__c" AddRelatedFields:NO];
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
    
    if (currentServiceFlowType == ServiceFlowAttachmentsPage && self.backAction)
        self.backAction();
    
    currentServiceFlowType--;
    
    if (currentServiceFlowType == ServiceFlowAttachmentsPage && ![self hasAttachments])
        currentServiceFlowType--;
    
    [self refreshTimeline];
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
    if (formFieldPicklistCalls == 0)
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

- (void)showServiceFlow {
    NSString *navBarTitle = @"";
    
    switch (self.relatedServiceType) {
        case RelatedServiceTypeNewEmployeeNOC:
        case RelatedServiceTypeNewCompanyNOC:
            navBarTitle = NSLocalizedString(@"navBarNewNOCTitle", @"");
            [self showNOCServiceFlow];
            break;
        case RelatedServiceTypeNewCard:
            navBarTitle = NSLocalizedString(@"navBarNewCardTitle", @"");
            [self showCardServiceFlow];
            break;
        case RelatedServiceTypeReplaceCard:
            navBarTitle = NSLocalizedString(@"navBarReplaceCardTitle", @"");
            [self showCardServiceFlow];
            break;
        case RelatedServiceTypeCancelCard:
            navBarTitle = NSLocalizedString(@"navBarCancelCardTitle", @"");
            [self showCardServiceFlow];
            break;
        case RelatedServiceTypeRenewCard:
            navBarTitle = NSLocalizedString(@"navBarRenewCardTitle", @"");
            [self showCardServiceFlow];
            break;
        case RelatedServiceTypeNewVisa:
            
            break;
        case RelatedServiceTypeRenewVisa:
            
            break;
        case RelatedServiceTypeCancelVisa:
            
            break;
        case RelatedServiceTypeViewMyRequest:
            navBarTitle = NSLocalizedString(@"navBarViewMyRequestTitle", @"");
            [self showViewMyRequestFlow];
            break;
        case RelatedServiceTypeRegistrationDocuments:
            navBarTitle = NSLocalizedString(@"navBarRegistrationDocumentsTitle", @"");
            [self showRegistrationDocumentsFlow];
            break;
        case RelatedServiceTypeContractRenewal:
            navBarTitle = NSLocalizedString(@"navBarRenewContractTitle", @"");
            [self showContractRenewalFlow];
            break;
        case RelatedServiceTypeLicenseRenewal:
            navBarTitle = NSLocalizedString(@"navBarRenewLicenseTitle", @"");
            [self showLicenseRenewalFlow];
            break;
        case RelatedServiceTypeCompanyAddressChange:
            navBarTitle = NSLocalizedString(@"navBarCompanyAddressChange", @"");
            [self showCompanyAmendmentServiceFlow];
            break;
        case RelatedServiceTypeCompanyNameChange:
            navBarTitle = NSLocalizedString(@"navBarCompanyNameChange", @"");
            [self showCompanyAmendmentServiceFlow];
            break;
        default:
            break;
    }
    
    currentServiceFlowType = ServiceFlowInitialPage;
    
    [super setNavigationBarTitle:navBarTitle];
}

- (void)showCompanyAmendmentServiceFlow {
    CompanyAmendmentViewController *companyAmendmentVC = [CompanyAmendmentViewController new];
    companyAmendmentVC.baseServicesViewController = self;
    [self addChildViewController:companyAmendmentVC toView:self.serviceFlowView];
    //[viewControllersStack pushObject:companyAmendmentVC];
}

- (void)showViewMyRequestFlow {
    void (^returnBlock)(BOOL didSucceed) = ^(BOOL didSucceed) {
        if (didSucceed) {
            [self showReviewFlowPage];
        }
    };
    [self getWebFormWithReturnBlock:returnBlock];
}

- (void)showRegistrationDocumentsFlow {
    [self showFieldsFlowPage];
}

- (void)showContractRenewalFlow {
    ContractRenewalEditViewController *contractRenewalEditVC = [ContractRenewalEditViewController new];
    contractRenewalEditVC.baseServicesViewController = self;
    [self addChildViewController:contractRenewalEditVC toView:self.serviceFlowView];
    [viewControllersStack pushObject:contractRenewalEditVC];
}

- (void)showLicenseRenewalFlow {
    LicenseRenewViewController *licenseRenewalVC = [LicenseRenewViewController new];
    licenseRenewalVC.baseServicesViewController = self;
    [self addChildViewController:licenseRenewalVC toView:self.serviceFlowView];
    [viewControllersStack pushObject:licenseRenewalVC];
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
    currentServiceFlowType = ServiceFlowFieldsPage;
    
    ServicesDynamicFormViewController *servicesDynamicFormVC = [ServicesDynamicFormViewController new];
    servicesDynamicFormVC.baseServicesViewController = self;
    
    [self addChildViewController:servicesDynamicFormVC toView:self.serviceFlowView];

    [viewControllersStack pushObject:servicesDynamicFormVC];
    
    [self refreshTimeline];
}

- (void)showAttachmentsFlowPage {
    currentServiceFlowType = ServiceFlowAttachmentsPage;
    
    ServicesUploadViewController *servicesUploadVC = [ServicesUploadViewController new];
    servicesUploadVC.baseServicesViewController = self;
    [self addChildViewController:servicesUploadVC toView:self.serviceFlowView];
    [viewControllersStack pushObject:servicesUploadVC];
    
    [self refreshTimeline];
}

- (void)showReviewFlowPage {
    currentServiceFlowType = ServiceFlowReviewPage;
    
    ServicesReviewViewController *servicesReviewVC = [ServicesReviewViewController new];
    servicesReviewVC.baseServicesViewController = self;
    [self addChildViewController:servicesReviewVC toView:self.serviceFlowView];
    [viewControllersStack pushObject:servicesReviewVC];
    
    [self refreshTimeline];
}

- (void)showThankYouFlowPage {
    [self hideAndDisableRightNavigationItem];
    currentServiceFlowType = ServiceFlowThankYouPage;
    
    ServicesThankYouViewController *servicesThankYouVC = [ServicesThankYouViewController new];
    servicesThankYouVC.baseServicesViewController = self;
    [self addChildViewController:servicesThankYouVC toView:self.serviceFlowView];
    [viewControllersStack pushObject:servicesThankYouVC];
    
    [self refreshTimeline];
}

- (void)closeThankYouFlowPage {
    if (self.relatedServiceType == RelatedServiceTypeViewMyRequest && self.backAction)
        self.backAction();
    [self popServicesViewController];
}

- (void)createCaseRecord {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        if (dict != nil)
            insertedCaseId = [dict objectForKey:@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            if (self.createServiceRecord)
                [self createServiceRecord:insertedCaseId];
            else {
                if (self.relatedServiceType == RelatedServiceTypeContractRenewal)
                    [self callRenewContractWebService];
                else if (self.relatedServiceType == RelatedServiceTypeLicenseRenewal)
                    [self callRenewLicensetWebService];
                else if (self.relatedServiceType == RelatedServiceTypeCancelCard)
                    [self cancelCardManagement];
                else
                    [self callGenerateInvoiceWebService];
            }
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
    
    NSMutableDictionary *mutableCaseFields = [NSMutableDictionary dictionaryWithDictionary:self.caseFields];
    if (self.currentServiceAdministration && self.currentServiceAdministration.Id)
        [mutableCaseFields setObject:self.currentServiceAdministration.Id forKey:@"Service_Requested__c"];
    
    if (self.currentWebForm && self.currentWebForm.Id)
        [mutableCaseFields setObject:self.currentWebForm.Id forKey:@"Visual_Force_Generator__c"];
    
    if(insertedCaseId != nil && ![insertedCaseId  isEqual: @""])
        [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Case"
                                                       objectId:insertedCaseId
                                                         fields:mutableCaseFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    else
        [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Case"
                                                         fields:mutableCaseFields
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
    
    if (self.relatedServiceType != RelatedServiceTypeCompanyAddressChange &&
        self.relatedServiceType != RelatedServiceTypeCompanyNameChange) {
        [mutableServiceFields setObject:self.currentWebForm.Id forKey:@"Web_Form__c"];
    }
    
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
    
    if (!self.serviceFieldCaseObjectName || [self.serviceFieldCaseObjectName isEmptyOrWhitespaceAndNewlines])
        self.serviceFieldCaseObjectName = self.currentWebForm.objectName;
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            ServiceId, self.serviceFieldCaseObjectName,
                            nil];
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            
            if ([self hasAttachments] && self.relatedServiceType != RelatedServiceTypeReplaceCard)
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
    
    NSString *relatedObjectName = (!self.serviceFieldCaseObjectName || [self.serviceFieldCaseObjectName isEmptyOrWhitespaceAndNewlines]) ? self.currentWebForm.objectName : self.serviceFieldCaseObjectName;
    
    for (EServiceDocument *doc in documentsArray) {
        NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       doc.name, @"Name",
                                       doc.Id, @"eServices_Document__c",
                                       [Globals currentAccount].Id, @"Company__c",
                                       insertedCaseId, @"Request__c",
                                       insertedServiceId, relatedObjectName,
                                       nil];
        
        if (doc.existingDocument && doc.existingDocumentAttachmentId) {
            [fields setObject:doc.existingDocumentAttachmentId forKey:@"Attachment_Id__c"];
        }
        
        void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
            NSString *companyDocumentId = [dict objectForKey:@"id"];
            doc.companyDocumentId = companyDocumentId;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (doc.existingDocument) {
                    [self uploadDidReturn:doc attachmentId:doc.existingDocumentAttachmentId];
                }
                else
                    [self addAttachment:doc];
            });
        };
        
        void (^errorBlock) (NSError*) = ^(NSError *e) {
#warning Handle error
        };
        
        [self showLoadingDialog];
        
        if (doc.companyDocumentId != nil && ![doc.companyDocumentId isEqualToString:@""] && !doc.attachmentUploaded && !doc.existingDocument) {
            [self addAttachment:doc];
        }
        else if (doc.companyDocumentId != nil && ![doc.companyDocumentId isEqualToString:@""] && doc.existingDocument) {
            fields = [NSMutableDictionary dictionaryWithObjectsAndKeys:doc.existingDocumentAttachmentId, @"Attachment_Id__c", nil];
            
            [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Company_Documents__c"
                                                           objectId:doc.companyDocumentId
                                                             fields:fields
                                                          failBlock:errorBlock
                                                      completeBlock:successBlock];
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
            [self uploadDidReturn:document attachmentId:nil];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        document.attachmentUploaded = YES;
        NSString *attachmentDocumentId = [dict objectForKey:@"id"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadDidReturn:document attachmentId:attachmentDocumentId];
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

- (void)uploadDidReturn:(EServiceDocument *)document attachmentId:(NSString *)attachmentId {
    attachmentsReturned++;
    
    if (attachmentId && [document.name containsString:@"Person Photo"]) {
        personalPhotoAttachmentId = attachmentId;
    }
    
    if (attachmentsReturned == totalAttachmentsToUpload) {
        [self hideLoadingDialog];
        
        if (failedImagedArray.count > 0) {
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"DocumentsUploadAlertMessage", @"")];
        }
        else {
            [self updatePersonPhotoId];
        }
    }
}

- (void)updatePersonPhotoId {
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            personalPhotoAttachmentId, @"Personal_photo__c",
                            nil];
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
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
    
    [[SFRestAPI sharedInstance] performUpdateWithObjectType:self.currentWebForm.objectName
                                                   objectId:insertedServiceId
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

- (void)cancelCardManagement {
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Cancelled", @"Status__c",
                            [SFDateUtil toSOQLDateTimeString:[NSDate new] isDateTime:YES], @"Cancellation_Date__c",
                            nil];
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
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
    
    [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Card_Management__c"
                                                   objectId:self.currentCardManagement.Id
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

- (void)callPayAndSubmitWebservice {
    
    // Manually set up request object
    NSString *functionName = @"MobilePayAndSubmitWebService";
    
    if (self.relatedServiceType == RelatedServiceTypeContractRenewal ||
        self.relatedServiceType == RelatedServiceTypeLicenseRenewal ||
        self.relatedServiceType == RelatedServiceTypeCompanyAddressChange ||
        self.relatedServiceType == RelatedServiceTypeCompanyNameChange) {
        functionName = @"MobileSubmitAndPayRequestWebService";
    }
    
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/%@", functionName];
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = [NSString stringWithFormat:@"/services/apexrest/%@", functionName];
    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:insertedCaseId forKey:@"caseId"];
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}

- (void)callGenerateInvoiceWebService {
    
    // Manually set up request object
    /* This webservice is not used anymore
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileGenerateInvoiceWebService"];
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = @"/services/apexrest/MobileGenerateInvoiceWebService";
    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:insertedCaseId forKey:@"caseId"];
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
    */
    [self handleGenerateInvoiceWebServiceReturn:nil];
}

- (void)callRenewContractWebService {
    // Manually set up request object
    SFRestRequest *renewContractRequest = [[SFRestRequest alloc] init];
    renewContractRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileRenewContractWebService"];
    renewContractRequest.method = SFRestMethodPOST;
    renewContractRequest.path = @"/services/apexrest/MobileRenewContractWebService";
    
    NSDictionary *wrapperDict = [NSDictionary dictionaryWithObjects:@[insertedCaseId, self.currentContract.quote.Id, self.currentContract.Id, self.currentContract.Id] forKeys:@[@"caseId", @"quoteId", @"oldContractId", @"newContractId"]];
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObject:wrapperDict forKey:@"wrapper"];
    
    renewContractRequest.queryParams = bodyDict;
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:renewContractRequest delegate:self];
}

- (void)callRenewLicensetWebService {
    // Manually set up request object
    SFRestRequest *renewLicenseRequest = [[SFRestRequest alloc] init];
    renewLicenseRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileRenewLicensetWebService"];
    renewLicenseRequest.method = SFRestMethodPOST;
    renewLicenseRequest.path = @"/services/apexrest/MobileRenewLicensetWebService";
    
    NSDictionary *wrapperDict = [NSDictionary dictionaryWithObjects:@[insertedCaseId, self.currentLicense.Id] forKeys:@[@"caseId", @"licenseId"]];
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObject:wrapperDict forKey:@"wrapper"];
    
    renewLicenseRequest.queryParams = bodyDict;
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:renewLicenseRequest delegate:self];
}

- (void)callPickListValuesWebService:(FormField *)formField {
    
    SFRestRequest *pickListValuesRequest = [[SFRestRequest alloc] init];
    pickListValuesRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobilePickListValuesWebService"];
    pickListValuesRequest.method = SFRestMethodGET;
    pickListValuesRequest.path = @"/services/apexrest/MobilePickListValuesWebService";
    pickListValuesRequest.queryParams = [NSDictionary dictionaryWithObject:formField.Id forKey:@"fieldId"];
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:pickListValuesRequest delegate:self];
}

- (void)getWebFormWithReturnBlock:(void (^)(BOOL))returnBlock {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        for (NSDictionary *dict in records) {
            self.currentWebForm = [[WebForm alloc] initWebForm:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            
            if (returnBlock) {
                returnBlock(YES);
            }
            //[self getFormFieldsValues];
            formFieldPicklistCalls = 0;
            for (FormField *formField in self.currentWebForm.formFields) {
                if ([formField.type isEqualToString:@"PICKLIST"]) {
                    formFieldPicklistCalls++;
                    [self callPickListValuesWebService:formField];
                }
                else if ([formField.type isEqualToString:@"REFERENCE"] && !formField.isParameter) {
                    formFieldPicklistCalls++;
                    [self getReferencePicklistValues:formField];
                }
            }
        });
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
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT Id, Name, Description__c, Title__c, isNotesAttachments__c, Object_Label__c, Object_Name__c, (SELECT Id, Name, APIRequired__c, Boolean_Value__c, Currency_Value__c, DateTime_Value__c, Date_Value__c, Email_Value__c , Hidden__c, isCalculated__c, isParameter__c, isQuery__c, Label__c, Number_Value__c, Order__c, Percent_Value__c, Phone_Value__c, Picklist_Value__c, PicklistEntries__c, Required__c, Text_Area_Long_Value__c, Text_Area_Value__c, Text_Value__c, Type__c, URL_Value__c, Web_Form__c, Width__c, isMobileAvailable__c, Mobile_Label__c, Mobile_Order__c, isDependentPicklist__c, Controlling_Field__c, should_Be_Cloned__c FROM R00N70000002DiOrEAK WHERE isMobileAvailable__c = true ORDER BY Mobile_Order__c) FROM Web_Form__c WHERE ID = '%@'", self.currentWebformId];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    [self showLoadingDialog];
    
}

- (void)getReferencePicklistValues:(FormField *)formField {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        formFieldPicklistCalls--;
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [self hideLoadingDialog];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        NSMutableArray *idsMutableArray = [NSMutableArray new];
        NSMutableArray *namesMutableArray = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            [idsMutableArray addObject:[recordDict objectForKey:@"Id"]];
            [namesMutableArray addObject:[recordDict objectForKey:@"Name"]];
        }
        
        NSDictionary *picklistNamesDictionary = [NSDictionary dictionaryWithObject:namesMutableArray forKey:formField.name];
        NSDictionary *picklistValuesDictionary = [NSDictionary dictionaryWithObject:idsMutableArray forKey:formField.name];
        
        formFieldPicklistCalls--;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [formField setPicklistNamesDictionary:picklistNamesDictionary PicklistValuesDictionary:picklistValuesDictionary];
        });
    };
    
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[NSString stringWithFormat:@"SELECT Id, Name FROM %@ ORDER BY Name", formField.textValue]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)handlePayAndSubmitWebserviceReturn:(id)jsonResponse {
    [self hideLoadingDialog];
    
    [self showThankYouFlowPage];
}

- (void)handleGenerateInvoiceWebServiceReturn:(id)jsonResponse {
    if ([self hasAttachments])
        [self showAttachmentsFlowPage];
    else
        [self showReviewFlowPage];
}

- (void)handleRenewContractWebServiceReturn:(id)jsonResponse {
    NSString *returnValue = [[NSString alloc] initWithData:jsonResponse encoding:NSUTF8StringEncoding];
    NSLog(@"request:didLoadResponse: %@", returnValue);
    [self hideLoadingDialog];
    
    if ([returnValue containsString:@"Error"]) {
#warning Handle Error
    }
    else {
        [self showReviewFlowPage];
    }
}

- (void)handleRenewLicenseWebServiceReturn:(id)jsonResponse {
    NSString *returnValue = [[NSString alloc] initWithData:jsonResponse encoding:NSUTF8StringEncoding];
    NSLog(@"request:didLoadResponse: %@", returnValue);
    [self hideLoadingDialog];
    
    if ([returnValue containsString:@"Error"]) {
#warning Handle Error
    }
    else {
        insertedServiceId = [returnValue substringFromIndex:[returnValue rangeOfString:@":"].location + 1];
        insertedServiceId = [insertedServiceId stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([self hasAttachments])
            [self showAttachmentsFlowPage];
        else
            [self showReviewFlowPage];
    }
}

- (void)handlePickListValuesWebServiceReturn:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    [self hideLoadingDialog];
    
    NSString *fieldId = [request.queryParams objectForKey:@"fieldId"];
    
    for (FormField *currentFormField in self.currentWebForm.formFields) {
        if (![currentFormField.Id isEqualToString:fieldId])
            continue;
        
        [currentFormField setPicklistNamesDictionary:dict PicklistValuesDictionary:nil];
    }
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([request.path containsString:@"MobilePayAndSubmitWebService"] ||
            [request.path containsString:@"MobileSubmitAndPayRequestWebService"])
            [self handlePayAndSubmitWebserviceReturn:jsonResponse];
        else if ([request.path containsString:@"MobileGenerateInvoiceWebService"])
            [self handleGenerateInvoiceWebServiceReturn:jsonResponse];
        else if ([request.path containsString:@"MobileRenewContractWebService"])
            [self handleRenewContractWebServiceReturn:jsonResponse];
        else if ([request.path containsString:@"MobileRenewLicensetWebService"])
            [self handleRenewLicenseWebServiceReturn:jsonResponse];
        else if ([request.path containsString:@"MobilePickListValuesWebService"]) {
            formFieldPicklistCalls--;
            [self handlePickListValuesWebServiceReturn:request didLoadResponse:jsonResponse];
        }
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    
    if ([request.path containsString:@"MobilePickListValuesWebService"]) {
        formFieldPicklistCalls--;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
    });
#warning Handle error
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    
    if ([request.path containsString:@"MobilePickListValuesWebService"]) {
        formFieldPicklistCalls--;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
    });
#warning Handle error
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    
    if ([request.path containsString:@"MobilePickListValuesWebService"]) {
        formFieldPicklistCalls--;
    }
    
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
