//
//  Globals.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface Globals : NSObject

+ (NSString *) contactId;
+ (void) setContactId:(NSString *)value;
+ (NSString *) contactPersonalPhoto;
+ (void) setContactPersonalPhoto:(NSString *)value;
+ (Account *) currentAccount;
+ (void) setCurrentAccount:(Account *)value;
+ (void)setNotificationsCount:(NSNumber *)value;
+ (NSNumber *)notificationsCount;
@end
