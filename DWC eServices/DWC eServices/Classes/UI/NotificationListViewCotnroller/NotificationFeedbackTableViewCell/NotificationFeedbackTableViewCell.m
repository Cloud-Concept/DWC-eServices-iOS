//
//  NotificationFeedbackTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/25/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NotificationFeedbackTableViewCell.h"
#import "NotificationManagement.h"
#import "EDStarRating.h"
#import "Request.h"
#import "FVCustomAlertView.h"
#import "SFRestAPI+Blocks.h"

@implementation NotificationFeedbackTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.notificationRating.starImage = [UIImage imageNamed:@"Rating Star"];
    self.notificationRating.starHighlightedImage = [UIImage imageNamed:@"Rating Star Highlighted"];
    self.notificationRating.maxRating = 5.0;
    self.notificationRating.horizontalMargin = 25;
    self.notificationRating.editable = YES;
    self.notificationRating.rating = 0;
    
    self.notificationRating.displayMode = EDStarRatingDisplayHalf;
    [self.notificationRating  setNeedsDisplay];
    
    self.notificationRating.tintColor = [UIColor colorWithRed:0.992 green:0.882 blue:0.427 alpha:1];
    
    self.notificationRating.returnBlock = ^(float rating )
    {
        NSLog(@"ReturnBlock: Star rating changed to %.1f", rating);
        
        [self updateRequestRatingScore:[NSNumber numberWithFloat:rating]];
        
        self.currentNotification.request.caseRatingScore = [NSNumber numberWithFloat:rating];
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForNotification:(NotificationManagement *)notification {
    [super refreshCellForNotification:notification];
    
    self.notificationRating.editable = !notification.isRequestAlreadyRated;
    
    [self setRatingScore:notification.request.caseRatingScore];
}

- (void)setRatingScore:(NSNumber *)ratingScore {
    self.notificationRating.rating = [ratingScore floatValue];
}


- (void)updateRequestRatingScore:(NSNumber *)ratingScore {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            //[FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    NSDictionary *fieldsDict = [NSDictionary dictionaryWithObject:ratingScore forKey:@"Case_Rating_Score__c"];
    
    //[FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Case"
                                                   objectId:self.currentNotification.request.Id
                                                     fields:fieldsDict
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

@end
