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
    
    if (iconName)
        self.requestIconImageView.image = [UIImage imageNamed:iconName];
    
    
    self.requestNumberLabel.text = currentRequest.caseNumber;
    self.requestStatusLabel.text = currentRequest.status;
    self.requestDateLabel.text = [HelperClass formatDateToString:currentRequest.createdDate];
    self.requestTypeLabel.text = currentRequest.type;
    self.requestPersonNameLabel.text = currentRequest.employeeRef.name;
}

@end
