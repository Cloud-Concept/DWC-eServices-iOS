//
//  ContractRenewalEditViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "SFRestAPI.h"

@class EServiceAdministration;
@class BaseServicesViewController;
@class RecordType;

@interface ContractRenewalEditViewController : UIViewController <SFRestDelegate>
{
    NSString *selectedProduct;
    EServiceAdministration *selectedEServiceAdministrator;
    RecordType *caseRecordType;
    
    BOOL courierChargesLoaded;
    
    NSString *retailCourierRate;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *knowledgeFeesTextField;
@property (weak, nonatomic) IBOutlet UITextField *courierFeesTextField;
@property (weak, nonatomic) IBOutlet UILabel *courierFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *courierRequiredSwitch;

- (IBAction)courierRequiredSwitchValueChanged:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;
@end
