//
//  NotificationTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "NotificationManagement.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForNotification:(NotificationManagement *)notification {
    self.currentNotification = notification;
    [self.notificationLabel setAttributedText:[notification getAttributedNotificationMessage]];
    
    self.backgroundColor = notification.isMessageRead ? [UIColor clearColor] : [UIColor colorWithRed:0.337 green:0.466 blue:0.592 alpha:0.2];
    
    NSString *iconName = nil;
    
    if ([notification.caseProcessName isEqualToString:@"NOC Services"])
        iconName = @"Notification NOC Icon";
    else if ([notification.caseProcessName isEqualToString:@"Visa Services"])
        iconName = @"Notification Visa Icon";
    else if ([notification.caseProcessName isEqualToString:@"Access Card Services"])
        iconName = @"Notification Card Icon";
    
    self.notificationIcon.image = [UIImage imageNamed:iconName];
}

@end
