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

@class EServiceAdministration;
@class Visa;
@class Stack;

typedef enum {
    ServiceFlowInitialPage,
    ServiceFlowFieldsPage,
    ServiceFlowAttachmentsPage,
    ServiceFlowReviewPage,
} ServiceFlowPageType;

@interface BaseServicesViewController : BaseFrontRevealViewController <UIAlertViewDelegate>
{
    Stack *viewControllersStack;
    
    NSString *insertedCaseId;
    NSString *insertedServiceId;
    
    NSInteger totalAttachmentsToUpload;
    NSInteger attachmentsReturned;
    NSMutableArray *failedImagedArray;
}

@property (nonatomic) RelatedServiceType relatedServiceType;
@property (strong, nonatomic) Visa *currentVisaObject;

@property (strong, nonatomic) EServiceAdministration *currentServiceAdministration;
@property (strong, nonatomic) NSDictionary *caseFields;
@property (strong, nonatomic) NSDictionary *serviceFields;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSString *serviceObject;
@property (strong, nonatomic) NSString *currentWebformId;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *nextButton;

@property (nonatomic, copy) void (^backAction)(void);

@property (weak, nonatomic) IBOutlet UIView *serviceFlowView;

- (void)initializeButtonsWithNextAction:(SEL)nextAction target:(id)target;
- (void)showLoadingDialog;
- (void)hideLoadingDialog;
- (void)cancelServiceButtonClicked;
- (void)nextButtonClicked:(ServiceFlowPageType)serviceFlowPageType;

@end
