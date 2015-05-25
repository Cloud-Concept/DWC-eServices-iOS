//
//  ViewStatementTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FreeZonePayment;

@interface ViewStatementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *paymentIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *paymentEmployeeNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentEmployeeNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentCreditDebitValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentBalanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusValueLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceStatusBalance;

- (void)displayValueForPayment:(FreeZonePayment *)currentPayment;

@end
