//
//  Account.h
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class License;

@interface Account : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *billingCity;
@property (nonatomic, strong) NSString *billingCountryCode;
@property (nonatomic, strong) NSNumber *accountBalance;
@property (nonatomic, strong) NSString *licenseNumberFormula;
@property (nonatomic, strong) NSDate *licenseExpiryDateFormula;

@property (nonatomic, strong) NSDate *companyRegistrationDate; //Company_Registration_Date__c
@property (nonatomic, strong) NSString *legalForm; //Legal_Form__c
@property (nonatomic, strong) NSString *registrationNumberValue; //Registration_Number_Value__c
@property (nonatomic, strong) NSString *phone; //Phone
@property (nonatomic, strong) NSString *fax; //Fax
@property (nonatomic, strong) NSString *email; //Email__c
@property (nonatomic, strong) NSString *mobile; //Mobile__c
@property (nonatomic, strong) NSString *proEmail; //PRO_Email__c
@property (nonatomic, strong) NSString *proMobileNumber; //PRO_Mobile_Number__c
@property (nonatomic, strong) NSString *billingStreet; //BillingStreet
@property (nonatomic, strong) NSString *billingPostalCode; //BillingPostalCode
@property (nonatomic, strong) NSString *billingCountry; //BillingCountry
@property (nonatomic, strong) NSString *billingState; //BillingState
@property (nonatomic, strong) License *currentLicenseNumber;

//Billing Address Format
//{!acc.BillingStreet} {!acc.BillingPostalCode} {!acc.BillingCountry} {!acc.BillingState} {!acc.BillingCity}

//Current_License_Number_r.Id, Current_License_Number__r.License_Issue_Date__c, Current_License_Number__r.License_Expiry_Date__c, Current_License_Number__r.Commercial_Name__c, Current_License_Number__r.Commercial_Name_Arabic__c, Current_License_Number__r.License_Number_Value__c, Current_License_Number__r.RecordType.Id, Current_License_Number__r.RecordType.Name

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula;

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula CompanyRegistrationDate:(NSString *)CompanyRegistrationDate LegalForm:(NSString *)LegalForm RegistrationNumberValue:(NSString *)RegistrationNumberValue Phone:(NSString *)Phone Fax:(NSString *)Fax Email:(NSString *)Email Mobile:(NSString *)Mobile ProEmail:(NSString *)ProEmail ProMobileNumber:(NSString *)ProMobileNumber BillingStreet:(NSString *)BillingStreet BillingPostalCode:(NSString *)BillingPostalCode BillingCountry:(NSString *)BillingCountry BillingState:(NSString *)BillingState BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode CurrentLicenseNumber:(License *)CurrentLicenseNumber;

@end
