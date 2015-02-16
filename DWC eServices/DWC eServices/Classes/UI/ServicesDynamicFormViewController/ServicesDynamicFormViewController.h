//
//  ServicesDynamicFormViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseServicesViewController.h"

@class EServiceAdministration;
@class WebForm;
@class Visa;

@interface ServicesDynamicFormViewController : BaseServicesViewController
{
    UIView *servicesContentView;
    WebForm *currentWebForm;
    
    UIButton *cancelButton;
    UIButton *nextButton;
}

@property (strong, nonatomic) Visa *visaObject;

@property (strong, nonatomic) NSString *currentWebformId;
@property (strong, nonatomic) EServiceAdministration *currentServiceAdministration;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@end
