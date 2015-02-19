//
//  ServicesReviewViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseServicesViewController.h"

@interface ServicesReviewViewController : BaseServicesViewController
{
    UIView *servicesContentView;
    NSString *insertedCaseId;
    NSString *insertedServiceId;
}

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@end
