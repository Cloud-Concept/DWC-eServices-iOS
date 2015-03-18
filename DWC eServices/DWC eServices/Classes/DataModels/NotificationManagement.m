//
//  NotificationManagement.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NotificationManagement.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "Request.h"

@implementation NotificationManagement

- (id)initNotificationManager:(NSString *)NotificationId Name:(NSString *)Name CaseStatus:(NSString *)CaseStatus CompiledMessage:(NSString *)CompiledMessage NotificationMessage:(NSString *)NotificationMessage PriorValue:(NSString *)PriorValue ReadDateTime:(NSString *)ReadDateTime IsFeedbackAllowed:(BOOL)IsFeedbackAllowed IsMessageRead:(BOOL)IsMessageRead IsPushNotificationAllowed:(BOOL)IsPushNotificationAllowed NotificationRequest:(Request *)NotificationRequest {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:NotificationId];
    self.name = [HelperClass stringCheckNull:Name];
    self.caseStatus = [HelperClass stringCheckNull:CaseStatus];
    self.compiledMessage = [HelperClass stringCheckNull:CompiledMessage];
    self.notificationMessage = [HelperClass stringCheckNull:NotificationMessage];
    self.priorValue = [HelperClass stringCheckNull:PriorValue];
    
    self.isFeedbackAllowed = IsFeedbackAllowed;
    self.isMessageRead = IsMessageRead;
    self.isPushNotificationAllowed = IsPushNotificationAllowed;
    
    if (![ReadDateTime isKindOfClass:[NSNull class]])
        self.readDateTime = [SFDateUtil SOQLDateTimeStringToDate:ReadDateTime];
    
    self.request = NotificationRequest;
    
    return self;
    
}

- (NSAttributedString *)getAttributedNotificationMessage {
    UIColor *statusColor;
    
    if ([self.caseStatus isEqualToString:@"Completed"])
        statusColor = [UIColor colorWithRed:0.215 green:0.749 blue:0.427 alpha:1];
    else if ([self.caseStatus isEqualToString:@"Draft"])
        statusColor = [UIColor colorWithRed:0.4 green:0.631 blue:0.792 alpha:1];
    else if ([self.caseStatus isEqualToString:@"Application Rejected"])
        statusColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    else
        statusColor = [UIColor colorWithRed:0.749 green:0.741 blue:0.215 alpha:1];
    
    UIFont *statusFont = [UIFont fontWithName:@"CorisandeRegular" size:12.0f];
    NSDictionary *statusAttributes = [NSDictionary dictionaryWithObjects:@[statusColor, statusFont]
                                                                 forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
    
    NSAttributedString *statusAttributedString = [[NSAttributedString alloc] initWithString:self.caseStatus
                                                                                 attributes:statusAttributes];
    
    UIColor *notificationNumberColor = [UIColor colorWithRed:0.443 green:0.443 blue:0.443 alpha:1];
    UIFont *notificationNumberFont = [UIFont fontWithName:@"CorisandeRegular" size:12.0f];
    NSDictionary *notificationNumberAttributes = [NSDictionary dictionaryWithObjects:@[notificationNumberColor, notificationNumberFont]
                                                                       forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
    
    NSAttributedString *notificationNumberAttributedString = [[NSAttributedString alloc] initWithString:self.request.caseNumber
                                                                                 attributes:notificationNumberAttributes];
    
    UIColor *notificationColor = [UIColor colorWithRed:0.462 green:0.501 blue:0.525 alpha:1];
    UIFont *notificationFont = [UIFont fontWithName:@"CorisandeLight" size:12.0f];
    NSDictionary *notificationAttributes = [NSDictionary dictionaryWithObjects:@[notificationColor, notificationFont]
                                                                 forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
    NSAttributedString *notificationAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" Status changed from %@ to ", self.priorValue] attributes:notificationAttributes];
    
    
    
    NSMutableAttributedString *returnString = [[NSMutableAttributedString alloc] initWithAttributedString:notificationNumberAttributedString];
    
    [returnString appendAttributedString:notificationAttributedString];
    [returnString appendAttributedString:statusAttributedString];
    
    return [[NSAttributedString alloc] initWithAttributedString:returnString];
}

@end