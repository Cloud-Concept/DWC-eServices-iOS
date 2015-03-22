//
//  License.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordType;

@interface License : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *commercialName;
@property (nonatomic, strong) NSString *commercialNameArabic;
@property (nonatomic, strong) NSString *licenseNumberValue;
@property (nonatomic, strong) NSString *validityStatus;
@property (nonatomic, strong) NSDate *licenseIssueDate;
@property (nonatomic, strong) NSDate *licenseExpiryDate;
@property (nonatomic, strong) RecordType *recordType;
@property (nonatomic, strong) NSArray *licenseActivityArray;

- (id)initLicense:(NSDictionary *)licenseDict;
/*
- (id)initLicense:(NSString *)LicenseId CommercialName:(NSString *)CommercialName CommercialNameArabic:(NSString *)CommercialNameArabic LicenseNumberValue:(NSString *)LicenseNumberValue ValidityStatus:(NSString *)ValidityStatus LicenseIssueDate:(NSString *)LicenseIssueDate LicenseExpiryDate:(NSString *)LicenseExpiryDate LicenseRecordType:(RecordType *)LicenseRecordType;
*/
@end
