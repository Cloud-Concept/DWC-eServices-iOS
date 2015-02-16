//
//  NewNOCViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseServicesViewController.h"
#import "PickerTableViewController.h"
#import "SFRestAPI.h"

@class Visa;

@interface NewNOCViewController : BaseServicesViewController <PickerTableViewControllerDelegate, SFRestDelegate>
{
    NSMutableArray *nocTypesArray;
    
    BOOL loadingNOCTypes;
    BOOL loadingRecordTypes;
    BOOL loadingCourierCharges;
    BOOL courierChargesLoaded;
    
    NSIndexPath *selectedNOCTypeIndexPath;
    
    NSString *caseRecordTypeId;
    NSString *nocRecordTypeId;
    NSString *retailCourierRate;
    NSString *corporateCourierRate;
}

@property (strong, nonatomic) Visa *currentVisaObject;

@property (weak, nonatomic) IBOutlet UIButton *chooseNOCTypeButton;
@property (weak, nonatomic) IBOutlet UISwitch *courierRequiredSwitch;
@property (weak, nonatomic) IBOutlet UILabel *courierRateLabel;
@property (weak, nonatomic) IBOutlet UITextField *courierRateTextField;
@property (weak, nonatomic) IBOutlet UILabel *courierCorporateRateLabel;
@property (weak, nonatomic) IBOutlet UITextField *courierCorporateRateTextField;

- (IBAction)chooseNOCTypeButtonClicked:(id)sender;
- (IBAction)courierRequiredSwitchValueChanged:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
