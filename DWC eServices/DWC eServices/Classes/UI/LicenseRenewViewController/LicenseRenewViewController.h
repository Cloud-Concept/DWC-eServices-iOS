//
//  LicenseRenewViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"

@class BaseServicesViewController;
@class EServiceAdministration;
@class RecordType;

@interface LicenseRenewViewController : UIViewController <SFRestDelegate>
{
    BOOL courierChargesLoaded;
    
    EServiceAdministration *selectedEServiceAdministrator;
    RecordType *caseRecordType;
    
    NSString *retailCourierRate;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UITextField *totalAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *courierFeesTextField;
@property (weak, nonatomic) IBOutlet UILabel *courierFeesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *courierRequiredSwitch;

- (IBAction)courierRequiredSwitchValueChanged:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
