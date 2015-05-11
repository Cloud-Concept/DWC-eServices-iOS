//
//  CompanyAddressChangeViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"

@class BaseServicesViewController;
@class RecordType;
@class DWCContactInfo;
@class TenancyContract;
@class EServiceAdministration;

@interface CompanyAmendmentViewController : UIViewController <SFRestDelegate>
{
    RecordType *caseRecordType;
    RecordType *serviceRecordType;
    
    DWCContactInfo *dwcContactInfo;
    
    TenancyContract *activeBCTenancyContract;
    
    EServiceAdministration *selectedEServiceAdministrator;
    
    BOOL isLoadingRecordTypes;
    BOOL isLoadingTenancyContracts;
    BOOL isLoadingDWCContactInfo;
    BOOL isLoadingServiceIdentifier;
    
    NSString *caseSubType;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@end
