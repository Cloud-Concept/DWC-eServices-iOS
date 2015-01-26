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
static Account *currentAccount = nil;

+ (NSString*) contactId {
    return contactId;
}

+ (void) setContactId:(NSString*)value {
    contactId = value;
}

+ (Account*) currentAccount {
    return currentAccount;
}

+ (void) setCurrentAccount:(Account*)value {
    currentAccount = value;
}

@end