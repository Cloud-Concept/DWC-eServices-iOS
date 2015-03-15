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
    [self.notificationLabel setAttributedText:[notification getAttributedNotificationMessage]];
    
    self.backgroundColor = notification.isMessageRead ? [UIColor clearColor] : [UIColor colorWithRed:0.968 green:0.933 blue:0.545 alpha:1];
}

@end
