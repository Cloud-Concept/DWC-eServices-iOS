//
//  NotificationManagement.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Request;

@interface NotificationManagement : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *caseStatus;
@property (nonatomic, strong) NSString *compiledMessage;
@property (nonatomic, strong) NSString *mobileCompiledMessage;
@property (nonatomic, strong) NSString *notificationMessage;
@property (nonatomic, strong) NSString *priorValue;
@property (nonatomic, strong) NSDate *readDateTime;
@property (nonatomic, strong) NSDate *createdDate;

@property (nonatomic) BOOL isFeedbackAllowed;
@property (nonatomic) BOOL isMessageRead;
@property (nonatomic) BOOL isPushNotificationAllowed;

@property (nonatomic, strong) Request *request;

- (id)initNotificationManager:(NSDictionary *)notificationManagerDict;
/*
- (id)initNotificationManager:(NSString *)NotificationId Name:(NSString *)Name CaseStatus:(NSString *)CaseStatus CompiledMessage:(NSString *)CompiledMessage NotificationMessage:(NSString *)NotificationMessage PriorValue:(NSString *)PriorValue ReadDateTime:(NSString *)ReadDateTime IsFeedbackAllowed:(BOOL)IsFeedbackAllowed IsMessageRead:(BOOL)IsMessageRead IsPushNotificationAllowed:(BOOL)IsPushNotificationAllowed NotificationRequest:(Request *)NotificationRequest;
*/

- (NSAttributedString *)getAttributedNotificationMessage;

@end
