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
    
    if (viewControllersStack.count == 1)
        [self cancelServiceButtonClicked];
    else
        [self popChildViewController];
    
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
            returnQuery = [SOQLQueries nocCaseReviewQuery:insertedCaseId Fields:self.currentWebForm.formFields];
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
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:@"Loading..." withBlur:YES];
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
        default:
            break;
    }
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
    
    NSMutableDictionary *mutableCaseFields = [NSMutableDictionary dictionaryWithDictionary:self.serviceFields];
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
        [[SFRestAPI sharedInstance] performUpdateWithObjectType:self.serviceObject
                                                       objectId:insertedServiceId
                                                         fields:mutableServiceFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    else
        [[SFRestAPI sharedInstance] performCreateWithObjectType:self.serviceObject
                                                         fields:mutableServiceFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
}

- (void)updateCaseObject:(NSString*)caseId ServiceId:(NSString*)ServiceId {
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            ServiceId, self.serviceObject,
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
                                insertedServiceId, self.serviceObject,
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
