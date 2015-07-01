//
//  Passport.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Passport.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "Account.h"

@implementation Passport

- (id)initPassport:(NSDictionary *)passportDict {
    if (!(self = [super init]))
        return nil;
    
    if ([passportDict isKindOfClass:[NSNull class]] || passportDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[passportDict objectForKey:@"Id"]];
    self.passportNumber = [HelperClass stringCheckNull:[passportDict objectForKey:@"Name"]];
    self.passportType = [HelperClass stringCheckNull:[passportDict objectForKey:@"Passport_Type__c"]];
    self.passportPlaceOfIssue = [HelperClass stringCheckNull:[passportDict objectForKey:@"Passport_Place_of_Issue__c"]];
    
    if (![[passportDict objectForKey:@"Passport_Issue_Date__c"] isKindOfClass:[NSNull class]])
        self.passportIssueDate = [SFDateUtil SOQLDateTimeStringToDate:[passportDict objectForKey:@"Passport_Issue_Date__c"]];
    
    if (![[passportDict objectForKey:@"Passport_Expiry_Date__c"] isKindOfClass:[NSNull class]])
        self.passportExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:[passportDict objectForKey:@"Passport_Expiry_Date__c"]];
    
    self.passportHolder = [[Account alloc] initAccount:[passportDict objectForKey:@"Passport_Holder__r"]];
    
    return self;
}

- (id)initPassport:(NSString *)PassportId PassportNumber:(NSString *)PassportNumber PassportType:(NSString *)PassportType PassportPlaceOfIssue:(NSString *)PassportPlaceOfIssue PassportIssueDate:(NSString *)PassportIssueDate PassportExpiryDate:(NSString *)PassportExpiryDate {
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:PassportId];
    self.passportNumber = [HelperClass stringCheckNull:PassportNumber];
    self.passportType = [HelperClass stringCheckNull:PassportType];
    self.passportPlaceOfIssue = [HelperClass stringCheckNull:PassportPlaceOfIssue];
    
    if (![PassportIssueDate isKindOfClass:[NSNull class]])
        self.passportIssueDate = [SFDateUtil SOQLDateTimeStringToDate:PassportIssueDate];
    
    if (![PassportExpiryDate isKindOfClass:[NSNull class]])
        self.passportExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:PassportExpiryDate];
    
    return self;
}

@end
