//
//  ServicesDynamicFormViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseServicesViewController.h"

@class WebForm;
@class Visa;

@interface ServicesDynamicFormViewController : BaseServicesViewController
{
    UIView *servicesContentView;
    WebForm *currentWebForm;
}

@property (strong, nonatomic) Visa *visaObject;
@property (strong, nonatomic) NSString *currentWebformId;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@end
