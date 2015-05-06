//
//  Globals.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Globals.h"
#import "Account.h"

@implementation Globals

static NSString *contactId = @"";
static NSString *contactPersonalPhoto = @"";
static Account *currentAccount = nil;
static NSNumber *notificationsCount;

+ (NSString *) contactId {
    return contactId;
}

+ (void) setContactId:(NSString*)value {
    contactId = value;
}

+ (NSString *) contactPersonalPhoto {
    return contactPersonalPhoto;
}

+ (void) setContactPersonalPhoto:(NSString *)value {
    contactPersonalPhoto = value;
}

+ (Account *) currentAccount {
    return currentAccount;
}

+ (void) setCurrentAccount:(Account*)value {
    currentAccount = value;
}

+ (void)setNotificationsCount:(NSNumber *)value {
    notificationsCount = value;
    [UIApplication sharedApplication].applicationIconBadgeNumber = [notificationsCount integerValue];
}

+ (NSNumber *)notificationsCount {
    return notificationsCount;
}

@end
