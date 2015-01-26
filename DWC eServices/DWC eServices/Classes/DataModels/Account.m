//
//  Account.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Account.h"
#import "SFDateUtil.h"

@implementation Account

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode {
    if (!(self = [super init]))
        return nil;
    
    self.Id = AccountId;
    self.name = Name;
    self.billingCity = BillingCity;
    self.billingCountryCode = BillingCountryCode;
    self.accountBalance = [NSNumber numberWithInt:0];
    self.licenseNumberFormula = @"";
    self.licenseExpiryDateFormula = [NSDate new];
    
    return self;
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance {
    if (!(self = [super init]))
        return nil;
    
    self.Id = AccountId;
    self.name = Name;
    self.accountBalance = AccountBalance;
    self.billingCity = @"";
    self.billingCountryCode = @"";
    self.licenseNumberFormula = @"";
    self.licenseExpiryDateFormula = [NSDate new];
    
    return self;
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = AccountId;
    self.name = Name;
    self.accountBalance = AccountBalance;
    self.billingCity = BillingCity;
    self.billingCountryCode = BillingCountryCode;
    self.licenseNumberFormula = LicenseNumberFormula;
    self.licenseExpiryDateFormula = [SFDateUtil SOQLDateTimeStringToDate:LicenseExpiryDateFormula];
    
    return self;
    
}
@end
