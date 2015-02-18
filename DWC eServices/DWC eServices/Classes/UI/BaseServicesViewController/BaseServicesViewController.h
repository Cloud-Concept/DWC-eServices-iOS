//
//  BaseServicesViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@class EServiceAdministration;

@interface BaseServicesViewController : BaseFrontRevealViewController <UIAlertViewDelegate>
{
    UIButton *cancelButton;
    UIButton *nextButton;
}

@property (strong, nonatomic) UIViewController *cancelViewController;
@property (strong, nonatomic) EServiceAdministration *currentServiceAdministration;
@property (strong, nonatomic) NSDictionary *caseFields;
@property (strong, nonatomic) NSDictionary *serviceFields;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSString *serviceObject;

- (void)initializeButtonsWithNextAction:(SEL)nextAction;
- (void)showLoadingDialog;
- (void)hideLoadingDialog;
- (void)cancelServiceButtonClicked:(id)sender;

@end
