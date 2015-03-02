//
//  NewCardViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  BaseServicesViewController;
@class EServiceAdministration;

@interface NewCardViewController : UIViewController
{
    NSString *caseRecordTypeId;
    
    NSArray *cardTypesDescriptionsArray;
    NSArray *cardTypesValuesArray;
    NSMutableArray *durationArray;
    
    NSMutableDictionary *cardManagementRecordTypesDictionary;
    
    NSIndexPath *selectedCardTypeIndexPath;
    NSIndexPath *selectedDurationIndexPath;
    
    //NSString *selectedCardType;
    //NSString *selectedDuration;
    
    EServiceAdministration *selectedService;
}
@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UIButton *chooseCardTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseDurationButton;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *servicePriceTextField;

- (IBAction)chooseCardTypeButtonClicked:(id)sender;
- (IBAction)chooseDurationButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
