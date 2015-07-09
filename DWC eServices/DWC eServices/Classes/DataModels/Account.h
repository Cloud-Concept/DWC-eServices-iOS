//
//  Account.h
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class License;
@class Passport;

@interface Account : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *billingCity;
@property (nonatomic, strong) NSString *billingCountryCode;
@property (nonatomic, strong) NSNumber *accountBalance;
@property (nonatomic, strong) NSNumber *portalBalance;
@property (nonatomic, strong) NSString *licenseNumberFormula;
@property (nonatomic, strong) NSDate *licenseExpiryDateFormula;

@property (nonatomic, strong) NSDate *companyRegistrationDate;
@property (nonatomic, strong) NSString *legalForm;
@property (nonatomic, strong) NSString *registrationNumberValue;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *proEmail;
@property (nonatomic, strong) NSString *proMobileNumber;
@property (nonatomic, strong) NSString *billingStreet;
@property (nonatomic, strong) NSString *billingPostalCode;
@property (nonatomic, strong) NSString *billingCountry;
@property (nonatomic, strong) NSString *billingState;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSString *companyLogo;
@property (nonatomic, strong) NSString *arabicAccountName;
@property (nonatomic, strong) NSString *personalPhotoId;

@property (nonatomic, strong) License *currentLicenseNumber;
@property (nonatomic, strong) Passport *currentPassport;
@property (nonatomic, strong) Account *currentManager;

- (id)initAccount:(NSDictionary *)accountDict;

/*
- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name Nationality:(NSString *)Nationality AccountPassport:(Passport *)AccountPassport;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula CompanyRegistrationDate:(NSString *)CompanyRegistrationDate LegalForm:(NSString *)LegalForm RegistrationNumberValue:(NSString *)RegistrationNumberValue Phone:(NSString *)Phone Fax:(NSString *)Fax Email:(NSString *)Email Mobile:(NSString *)Mobile ProEmail:(NSString *)ProEmail ProMobileNumber:(NSString *)ProMobileNumber BillingStreet:(NSString *)BillingStreet BillingPostalCode:(NSString *)BillingPostalCode BillingCountry:(NSString *)BillingCountry BillingState:(NSString *)BillingState BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode CurrentLicenseNumber:(License *)CurrentLicenseNumber;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula CompanyRegistrationDate:(NSString *)CompanyRegistrationDate LegalForm:(NSString *)LegalForm RegistrationNumberValue:(NSString *)RegistrationNumberValue Phone:(NSString *)Phone Fax:(NSString *)Fax Email:(NSString *)Email Mobile:(NSString *)Mobile ProEmail:(NSString *)ProEmail ProMobileNumber:(NSString *)ProMobileNumber BillingStreet:(NSString *)BillingStreet BillingPostalCode:(NSString *)BillingPostalCode BillingCountry:(NSString *)BillingCountry BillingState:(NSString *)BillingState BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode Nationality:(NSString *)Nationality CurrentLicenseNumber:(License *)CurrentLicenseNumber AccountPassport:(Passport *)AccountPassport;
*/

- (NSString *)billingAddress;
@end
