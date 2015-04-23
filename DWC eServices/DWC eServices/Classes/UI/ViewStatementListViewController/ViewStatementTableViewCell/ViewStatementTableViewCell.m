//
//  ViewStatementTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ViewStatementTableViewCell.h"
#import "FreeZonePayment.h"
#import "HelperClass.h"

@implementation ViewStatementTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayValueForPayment:(FreeZonePayment *)currentPayment {
    self.paymentTransactionNumberValueLabel.text = currentPayment.name;
    self.paymentDateValueLabel.text = [HelperClass formatDateToString:currentPayment.transactionDate];
    self.paymentStatusValueLabel.text = currentPayment.status;
    
    if (currentPayment.freeZonePaymentType == FreeZonePaymentTypeCredit && [currentPayment.status isEqualToString:@"Verified"]) {
        NSString *balanceStr = [HelperClass formatNumberToString:currentPayment.closingBalance
                                                     FormatStyle:NSNumberFormatterDecimalStyle
                                           MaximumFractionDigits:2];
        
        self.paymentBalanceValueLabel.text = [NSString stringWithFormat:@"AED %@", balanceStr];
    }
    else {
        [self.paymentBalanceValueLabel removeFromSuperview];
        [self.paymentBalanceLabel removeFromSuperview];
    }
    
    NSNumber *creditDebitAmount = [NSNumber numberWithInt:0];
    NSString *iconName;
    
    switch (currentPayment.freeZonePaymentType) {
        case FreeZonePaymentTypeCredit:
            creditDebitAmount = currentPayment.creditAmount;
            iconName = @"Payment Credit Icon";
            break;
        case FreeZonePaymentTypeDebit:
            creditDebitAmount = currentPayment.debitAmount;
            iconName = @"Payment Debit Icon";
            break;
        default:
            break;
    }
    
    self.paymentIconImageView.image = [UIImage imageNamed:iconName];
    
    NSString *creditStr = [HelperClass formatNumberToString:creditDebitAmount
                                                FormatStyle:NSNumberFormatterDecimalStyle
                                      MaximumFractionDigits:2];
    
    self.paymentCreditDebitValueLabel.text = [NSString stringWithFormat:@"AED %@", creditStr];
}

@end
