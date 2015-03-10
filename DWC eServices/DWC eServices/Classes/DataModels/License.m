//
//  License.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "License.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation License

- (id)initLicense:(NSString *)LicenseId CommercialName:(NSString *)CommercialName CommercialNameArabic:(NSString *)CommercialNameArabic LicenseNumberValue:(NSString *)LicenseNumberValue ValidityStatus:(NSString *)ValidityStatus LicenseIssueDate:(NSString *)LicenseIssueDate LicenseExpiryDate:(NSString *)LicenseExpiryDate LicenseRecordType:(RecordType *)LicenseRecordType {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:LicenseId];
    self.commercialName = [HelperClass stringCheckNull:CommercialName];
    self.commercialNameArabic = [HelperClass stringCheckNull:CommercialNameArabic];
    self.licenseNumberValue = [HelperClass stringCheckNull:LicenseNumberValue];
    self.validityStatus = [HelperClass stringCheckNull:ValidityStatus];
    
    if (![LicenseIssueDate isKindOfClass:[NSNull class]])
        self.licenseIssueDate = [SFDateUtil SOQLDateTimeStringToDate:LicenseIssueDate];
    
    if (![LicenseExpiryDate isKindOfClass:[NSNull class]])
        self.licenseExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:LicenseExpiryDate];
    
    self.recordType = LicenseRecordType;
    
    return self;
}

@end
