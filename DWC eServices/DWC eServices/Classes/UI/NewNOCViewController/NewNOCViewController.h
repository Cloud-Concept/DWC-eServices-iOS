//
//  NewNOCViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerTableViewController.h"
#import "SFRestAPI.h"

@class BaseServicesViewController;
@class Visa;

@interface NewNOCViewController : UIViewController <SFRestDelegate>
{
    NSMutableArray *nocTypesArray;
    
    BOOL loadingNOCTypes;
    BOOL loadingRecordTypes;
    BOOL loadingCourierCharges;
    BOOL courierChargesLoaded;
    
    NSIndexPath *selectedNOCTypeIndexPath;
    NSIndexPath *selectedAuthorityIndexPath;
    NSIndexPath *selectedLanguageIndexPath;
    
    NSString *caseRecordTypeId;
    NSString *nocRecordTypeId;
    NSString *retailCourierRate;
    NSString *corporateCourierRate;
    
    NSString *selectedAuthority;
    NSString *selectedLanguage;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UIButton *chooseNOCTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseAuthorityButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseLanguageButton;
@property (weak, nonatomic) IBOutlet UISwitch *courierRequiredSwitch;
@property (weak, nonatomic) IBOutlet UILabel *courierRateLabel;
@property (weak, nonatomic) IBOutlet UITextField *courierRateTextField;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *servicePriceTextField;

- (IBAction)chooseNOCTypeButtonClicked:(id)sender;
- (IBAction)chooseAuthorityButtonClicked:(id)sender;
- (IBAction)chooseLanguageButtonClicked:(id)sender;
- (IBAction)courierRequiredSwitchValueChanged:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
