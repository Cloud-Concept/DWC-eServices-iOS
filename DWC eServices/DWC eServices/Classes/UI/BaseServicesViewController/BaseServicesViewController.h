//
//  BaseServicesViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "RelatedService.h"
#import "SFRestAPI.h"

@class EServiceAdministration;
@class Visa;
@class Stack;
@class WebForm;
@class TenancyContract;
@class License;
@class CardManagement;

typedef enum {
    ServiceFlowInitialPage,
    ServiceFlowFieldsPage,
    ServiceFlowAttachmentsPage,
    ServiceFlowReviewPage,
    ServiceFlowThankYouPage,
} ServiceFlowPageType;

@interface BaseServicesViewController : BaseFrontRevealViewController <UIAlertViewDelegate, SFRestDelegate>
{
    Stack *viewControllersStack;
    
    NSString *insertedCaseId;
    NSString *insertedServiceId;
    
    NSInteger totalAttachmentsToUpload;
    NSInteger attachmentsReturned;
    NSMutableArray *failedImagedArray;
    
    NSInteger formFieldPicklistCalls;
    
    NSString *personalPhotoAttachmentId;
    
    NSArray *timelineButtonsArray;
    ServiceFlowPageType currentServiceFlowType;
}

@property (nonatomic) RelatedServiceType relatedServiceType;
@property (strong, nonatomic) Visa *currentVisaObject;
@property (strong, nonatomic) WebForm *currentWebForm;
@property (strong, nonatomic) TenancyContract *currentContract;
@property (strong, nonatomic) License *currentLicense;
@property (strong, nonatomic) CardManagement *currentCardManagement;

@property (strong, nonatomic) EServiceAdministration *currentServiceAdministration;
@property (strong, nonatomic) NSDictionary *caseFields;
@property (strong, nonatomic) NSDictionary *serviceFields;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSString *currentWebformId;

@property (strong, nonatomic) NSString *createdCaseNumber;
@property (strong, nonatomic) NSNumber *createdCaseTotalPrice;
@property (strong, nonatomic) NSString *createdCaseNOCEmailReceiver;

@property (nonatomic) BOOL createServiceRecord;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *nextButton;

@property (nonatomic, copy) void (^backAction)(void);

@property (weak, nonatomic) IBOutlet UIView *serviceFlowView;
@property (weak, nonatomic) IBOutlet UIView *timelineView;
@property (weak, nonatomic) IBOutlet UIButton *timelineBulletOneButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineBulletTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineBulletThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineBulletFourButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineBulletFiveButton;

- (void)initializeButtonsWithNextAction:(SEL)nextAction target:(id)target;
- (void)showLoadingDialog;
- (void)hideLoadingDialog;
- (void)cancelServiceButtonClicked;
- (void)nextButtonClicked:(ServiceFlowPageType)serviceFlowPageType;
- (void)closeThankYouFlowPage;
- (void)callPayAndSubmitWebservice;
- (NSString *)getCaseReviewQuery;
- (void)getWebFormWithReturnBlock:(void (^)(BOOL))returnBlock;
- (void)initializeCaseId:(NSString *)caseId;
@end
