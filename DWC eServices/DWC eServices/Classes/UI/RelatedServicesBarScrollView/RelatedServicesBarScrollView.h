//
//  RelatedServicesTabBar.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRelatedServicesScrollViewHeight 80

@class Visa;
@class TenancyContract;
@class License;
@class CardManagement;

@interface RelatedServicesBarScrollView : UIScrollView
{
    NSArray *relatedServicesArray;
    UIViewController *parentViewController;
}

@property (strong, nonatomic) Visa *visaObject;
@property (strong, nonatomic) TenancyContract *contractObject;
@property (strong, nonatomic) License *licenseObject;
@property (strong, nonatomic) CardManagement *cardManagementObject;

- (void)displayRelatedServicesForMask:(NSUInteger)relatedServicesMask parentViewController:(UIViewController *)viewController;

@end
