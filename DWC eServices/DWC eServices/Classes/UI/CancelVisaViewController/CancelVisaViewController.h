//
//  CancelVisaViewController.h
//  iDWC
//
//  Created by Mina Zaklama on 7/6/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseServicesViewController;
@class RecordType;
@class EServiceAdministration;

@interface CancelVisaViewController : UIViewController
{
    BOOL loadingRecordTypes;
    BOOL loadingServiceIdentifier;
    
    RecordType *caseRecordType;
    
    EServiceAdministration *selectedEServiceAdministrator;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@end
