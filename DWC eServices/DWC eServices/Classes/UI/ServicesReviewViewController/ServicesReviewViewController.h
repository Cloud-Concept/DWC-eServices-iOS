//
//  ServicesReviewViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseServicesViewController.h"

@interface ServicesReviewViewController : UIViewController
{
    UIView *servicesContentView;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *requestIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *requestTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestPersonNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestRefNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestStatusValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestTotalAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestTotalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestRejectionReasonValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestRejectionReasonLabel;
@end
