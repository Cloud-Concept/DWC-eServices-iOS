//
//  Visa.h
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@class Country;
@class Occupation;
@class Passport;
@class Qualification;

@interface Visa : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *personalPhotoId;
@property (nonatomic, strong) NSString *salutation;
@property (nonatomic, strong) NSString *salutationArabic;
@property (nonatomic, strong) NSString *applicantFullName;
@property (nonatomic, strong) NSString *applicantFullNameArabic;
@property (nonatomic, strong) NSString *applicantFirstName;
@property (nonatomic, strong) NSString *applicantFirstNameArabic;
@property (nonatomic, strong) NSString *applicantMiddleName;
@property (nonatomic, strong) NSString *applicantMiddleNameArabic;
@property (nonatomic, strong) NSString *applicantLastName;
@property (nonatomic, strong) NSString *applicantLastNameArabic;
@property (nonatomic, strong) NSString *applicantEmail;
@property (nonatomic, strong) NSString *applicantMobileNumber;
@property (nonatomic, strong) NSString *applicantGender;
@property (nonatomic, strong) NSString *passportCountry;
@property (nonatomic, strong) NSString *passportNumber;
@property (nonatomic, strong) NSString *religion;
@property (nonatomic, strong) NSString *visaType;
@property (nonatomic, strong) NSString *validityStatus;
@property (nonatomic, strong) NSString *accompaniedBy;
@property (nonatomic, strong) NSString *visitVisaDuration;
@property (nonatomic, strong) NSString *employeeID;
@property (nonatomic, strong) NSString *dependentVisaType;
@property (nonatomic, strong) NSString *languages;
@property (nonatomic, strong) NSString *maritalStatus;
@property (nonatomic, strong) NSString *motherName;
@property (nonatomic, strong) NSString *passportPlaceOfIssue;
@property (nonatomic, strong) NSString *placeOfBirth;
@property (nonatomic, strong) NSString *serviceIdentifier;
@property (nonatomic, strong) NSString *transferringCompanyExternal;
@property (nonatomic, strong) NSString *transferringFreezone;

@property (nonatomic, assign) BOOL deliverEntryPermit;
@property (nonatomic, assign) BOOL deliverPassportVisaStamped;
@property (nonatomic, assign) BOOL inCountry;
@property (nonatomic, assign) BOOL localAmendment;
@property (nonatomic, assign) BOOL urgentProcessing;
@property (nonatomic, assign) BOOL urgentStamping;

@property (nonatomic, strong) NSNumber *monthlyAllowancesInAED;
@property (nonatomic, strong) NSNumber *monthlyBasicSalaryInAED;

@property (nonatomic, strong) NSDate *passportExpiry;
@property (nonatomic, strong) NSDate *expiryDate;
@property (nonatomic, strong) NSDate *dateOfBirth;

@property (nonatomic, strong) Account *sponsoringCompany;
@property (nonatomic, strong) Account *visaHolder;
@property (nonatomic, strong) Country *countryOfBirth;
@property (nonatomic, strong) Country *currentNationality;
@property (nonatomic, strong) Occupation *jobTitleAtImmigration;
@property (nonatomic, strong) Passport *passport;
@property (nonatomic, strong) Country *passportIssueCountry;
@property (nonatomic, strong) Country *previousNationality;
@property (nonatomic, strong) Qualification *qualification;
@property (nonatomic, strong) Visa *renewalForVisa;
@property (nonatomic, strong) Account *sponsoringEmployeeAcc;
@property (nonatomic, strong) Account *transferringCompany;

- (id)initVisa:(NSDictionary *)visaDict;
/*
- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name EmployeeId:(NSString*)EmployeeId PersonalPhoto:(NSString*)PersonalPhoto Salutation:(NSString*)Salutation SalutationArabic:(NSString*)SalutationArabic ApplicantFullName:(NSString*)ApplicantFullName ApplicantFirstNameArabic:(NSString*)ApplicantFirstNameArabic ApplicantMiddleNameArabic:(NSString*)ApplicantMiddleNameArabic ApplicantLastNameArabic:(NSString*)ApplicantLastNameArabic ApplicantEmail:(NSString*)ApplicantEmail ApplicantMobileNumber:(NSString*)ApplicantMobileNumber ApplicantGender:(NSString*)ApplicantGender PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber PassportExpiry:(NSString*)PassportExpiry Religion:(NSString*)Religion VisaType:(NSString*)VisaType ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate DateOfBirth:(NSString*)DateOfBirth SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder CountryOfBirth:(Country*)CountryOfBirth CurrentNationality:(Country*)CurrentNationality JobTitleAtImmigration:(Occupation*)JobTitleAtImmigration;

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name EmployeeId:(NSString*)EmployeeId PersonalPhoto:(NSString*)PersonalPhoto Salutation:(NSString*)Salutation SalutationArabic:(NSString*)SalutationArabic ApplicantFullName:(NSString*)ApplicantFullName ApplicantFirstNameArabic:(NSString*)ApplicantFirstNameArabic ApplicantMiddleNameArabic:(NSString*)ApplicantMiddleNameArabic ApplicantLastNameArabic:(NSString*)ApplicantLastNameArabic ApplicantEmail:(NSString*)ApplicantEmail ApplicantMobileNumber:(NSString*)ApplicantMobileNumber ApplicantGender:(NSString*)ApplicantGender PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber PassportExpiry:(NSString*)PassportExpiry Religion:(NSString*)Religion VisaType:(NSString*)VisaType ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate DateOfBirth:(NSString*)DateOfBirth AccompaniedBy:(NSString*)AccompaniedBy VisitVisaDuration:(NSString*)VisitVisaDuration SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder CountryOfBirth:(Country*)CountryOfBirth CurrentNationality:(Country*)CurrentNationality JobTitleAtImmigration:(Occupation*)JobTitleAtImmigration;

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber
SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder;
*/
@end
