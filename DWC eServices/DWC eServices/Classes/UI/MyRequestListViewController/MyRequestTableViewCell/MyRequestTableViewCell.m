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
    [HelperClass setRequestIconForImageView:self.requestIconImageView requestType:currentRequest.type];
    
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
