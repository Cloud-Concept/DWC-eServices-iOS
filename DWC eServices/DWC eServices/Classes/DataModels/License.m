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
#import "RecordType.h"

@implementation License

- (id)initLicense:(NSDictionary *)licenseDict {
    if (!(self = [super init]))
        return nil;
    
    if ([licenseDict isKindOfClass:[NSNull class]] || licenseDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[licenseDict objectForKey:@"Id"]];
    self.commercialName = [HelperClass stringCheckNull:[licenseDict objectForKey:@"Commercial_Name__c"]];
    self.commercialNameArabic = [HelperClass stringCheckNull:[licenseDict objectForKey:@"Commercial_Name_Arabic__c"]];
    self.licenseNumberValue = [HelperClass stringCheckNull:[licenseDict objectForKey:@"License_Number_Value__c"]];
    self.validityStatus = [HelperClass stringCheckNull:[licenseDict objectForKey:@"Validity_Status__c"]];
    
    if (![[licenseDict objectForKey:@"License_Issue_Date__c"] isKindOfClass:[NSNull class]])
        self.licenseIssueDate = [SFDateUtil SOQLDateTimeStringToDate:[licenseDict objectForKey:@"License_Issue_Date__c"]];
    
    if (![[licenseDict objectForKey:@"License_Expiry_Date__c"] isKindOfClass:[NSNull class]])
        self.licenseExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:[licenseDict objectForKey:@"License_Expiry_Date__c"]];
    
    self.recordType = [[RecordType alloc] initRecordType:[licenseDict objectForKey:@"RecordType"]];
    
    return self;
}

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
