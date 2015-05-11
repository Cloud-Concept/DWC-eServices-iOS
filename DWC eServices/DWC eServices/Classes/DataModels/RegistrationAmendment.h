//
//  RegistrationAmendment.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordType;
@class Account;
@class Country;

@interface RegistrationAmendment : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addressBeforeAmendment;
@property (nonatomic, strong) NSString *applicationStatus;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cityBeforeChange;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyNameBeforeRegistration;
@property (nonatomic, strong) NSString *companyArabicNameBeforeRegistration;
@property (nonatomic, strong) NSString *countryBeforeChange;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *emailBeforeChange;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *faxBeforeChange;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *mobileBeforeChange;

@property (nonatomic, strong) NSDate *amendmentEffectiveDate;

@property (nonatomic, strong) Account *company;
@property (nonatomic, strong) Country *country;
@property (nonatomic, strong) RecordType *recordType;

- (id)initRegistrationAmendment:(NSDictionary *)amendmentDict;

@end
