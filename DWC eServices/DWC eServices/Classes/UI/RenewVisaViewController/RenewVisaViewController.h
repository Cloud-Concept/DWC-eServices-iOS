//
//  RenewVisaViewController.h
//  iDWC
//
//  Created by Mina Zaklama on 6/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"

@class Visa;
@class BaseServicesViewController;
@class WebForm;
@class EServiceAdministration;

@interface RenewVisaViewController : UIViewController <SFRestDelegate>
{
    UIView *servicesContentView;
    CGPoint scrollViewOffset;
    
    NSDictionary *recordTypesDictionary;
    NSDictionary *tariffDictionary;
    
    NSMutableArray *objectSettingsMutableArray;
    
    WebForm *currentWebForm;
    
    BOOL loadingRecordTypes;
    BOOL loadingTariffs;
    BOOL loadingRenewVisaWebservice;
    BOOL loadingRenewedVisa;
    BOOL loadingObjectSettings;
    BOOL loadingServiceIdentifier;
    
    EServiceAdministration *selectedEServiceAdministrator;
    
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@end
