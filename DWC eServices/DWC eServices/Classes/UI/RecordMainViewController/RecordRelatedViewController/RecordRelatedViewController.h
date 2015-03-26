//
//  RecordRelatedViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordRelatedViewControllerDelegate <NSObject>

- (void)relatedServiceNewNOCButtonClicked;
- (void)relatedServiceNewCardButtonClicked;
- (void)relatedServiceRenewCardButtonClicked;
- (void)relatedServiceCancelCardButtonClicked;
- (void)relatedServiceReplaceCardButtonClicked;
- (void)relatedServiceNewVisaButtonClicked;
- (void)relatedServiceRenewVisaButtonClicked;
- (void)relatedServiceCancelVisaButtonClicked;
- (void)relatedServiceContractRenewalButtonClicked;

@end

@interface RecordRelatedViewController : UIViewController
{
    NSArray *relatedServicesArray;
    
    UIView *servicesContentView;
}

@property (nonatomic) NSUInteger RelatedServicesMask;
@property (nonatomic) id<RecordRelatedViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@end
