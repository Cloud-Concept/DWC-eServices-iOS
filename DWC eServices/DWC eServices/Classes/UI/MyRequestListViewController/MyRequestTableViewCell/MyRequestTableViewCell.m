//
//  MyRequestTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "MyRequestTableViewCell.h"
#import "Request.h"
#import "Account.h"
#import "HelperClass.h"

@implementation MyRequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayValueForRequest:(Request *)currentRequest {
    NSString *iconName = nil;
    
    if ([currentRequest.type isEqualToString:@"NOC Services"])
        iconName = @"Notification NOC Icon";
    else if ([currentRequest.type isEqualToString:@"Visa Services"])
        iconName = @"Notification Visa Icon";
    else if ([currentRequest.type isEqualToString:@"Access Card Services"])
        iconName = @"Notification Card Icon";
    
    self.requestIconImageView.image = [UIImage imageNamed:iconName];
    
    self.requestNumberValueLabel.text = currentRequest.caseNumber;
    self.requestStatusValueLabel.text = currentRequest.status;
    self.requestDateValueLabel.text = [HelperClass formatDateToString:currentRequest.createdDate];
    self.requestTypeValueLabel.text = currentRequest.type;
    
    if (currentRequest.employeeRef)
        self.requestPersonNameValueLabel.text = currentRequest.employeeRef.name;
    else {
        [self.requestPersonNameLabel removeFromSuperview];
        [self.requestPersonNameValueLabel removeFromSuperview];
    }
}

@end
