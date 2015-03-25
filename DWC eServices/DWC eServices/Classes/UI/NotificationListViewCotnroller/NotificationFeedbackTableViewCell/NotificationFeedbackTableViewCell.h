//
//  NotificationFeedbackTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/25/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationTableViewCell.h"

@class NotificationManagement;
@class EDStarRating;

@interface NotificationFeedbackTableViewCell : NotificationTableViewCell

@property (weak, nonatomic) IBOutlet EDStarRating *notificationRating;

- (void)setRatingScore:(NSNumber *)ratingScore;

@end
