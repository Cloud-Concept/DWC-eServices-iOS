//
//  LicenseCancelationViewController.h
//  iDWC
//
//  Created by George on 8/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "License.h"
#import "RelatedService.h"
#import "SFRestRequest.h"
#import "LicenseCancellationThanksView.h"

@interface LicenseCancelationViewController : UIViewController<SFRestDelegate>

@property (nonatomic) RelatedServiceType relatedServiceType;

@property (strong, nonatomic) License *currentLicense;

@property (strong,nonatomic) IBOutlet UIView* detailsView;
@property (strong,nonatomic) IBOutlet LicenseCancellationThanksView* thanksView;

@property(weak,nonatomic) IBOutlet UILabel* licenseName;
@property(weak,nonatomic) IBOutlet UILabel* licenseNo;
@property(weak,nonatomic) IBOutlet UILabel* issueDate;
@property(weak,nonatomic) IBOutlet UILabel* knowldgeFee;
@property(weak,nonatomic) IBOutlet UILabel* totalAmount;

- (void)cancelServiceButtonClicked;
- (IBAction)payClicked:(UIButton *)sender;
- (IBAction)backClicked:(UIButton *)sender;
@end
