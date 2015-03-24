//
//  ServicesDynamicFormViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebForm;
@class Visa;
@class BaseServicesViewController;

@interface ServicesDynamicFormViewController : UIViewController
{
    UIView *servicesContentView;
    CGPoint scrollViewOffset;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@end
