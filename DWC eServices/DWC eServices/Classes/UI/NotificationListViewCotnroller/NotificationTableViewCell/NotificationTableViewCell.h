//
//  NotificationTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationManagement;

@interface NotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) NotificationManagement *currentNotification;

@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIcon;

- (void)refreshCellForNotification:(NotificationManagement *)notification;

@end
