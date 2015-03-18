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

@implementation Passport

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
