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
    UIColor *color;
    
    if ([self.caseStatus isEqualToString:@"Completed"])
        color = [UIColor colorWithRed:0.215 green:0.749 blue:0.427 alpha:1];
    else if ([self.caseStatus isEqualToString:@"Draft"])
        color = [UIColor colorWithRed:0.4 green:0.631 blue:0.792 alpha:1];
    else if ([self.caseStatus isEqualToString:@"Application Rejected"])
        color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    else
        color = [UIColor colorWithRed:0.749 green:0.741 blue:0.215 alpha:1];
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    NSAttributedString *statusAttributedString = [[NSAttributedString alloc] initWithString:self.caseStatus attributes:attributes];
    
    
    NSString *notificationMsg = [NSString stringWithFormat:@"(%@) Status changed from %@ to ", self.request.Id, self.priorValue];
    NSMutableAttributedString *returnString = [[NSMutableAttributedString alloc] initWithString:notificationMsg];
    [returnString appendAttributedString:statusAttributedString];
    
    return returnString;
}

@end
