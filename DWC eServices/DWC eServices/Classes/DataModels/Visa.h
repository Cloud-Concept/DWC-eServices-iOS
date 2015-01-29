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

@interface Visa : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *personalPhotoId;
@property (nonatomic, strong) NSString *salutation;
@property (nonatomic, strong) NSString *salutationArabic;
@property (nonatomic, strong) NSString *applicantFullName;
@property (nonatomic, strong) NSString *applicantFirstNameArabic;
@property (nonatomic, strong) NSString *applicantMiddleNameArabic;
@property (nonatomic, strong) NSString *applicantLastNameArabic;
@property (nonatomic, strong) NSString *applicantEmail;
@property (nonatomic, strong) NSString *applicantMobileNumber;
@property (nonatomic, strong) NSString *applicantGender;
@property (nonatomic, strong) NSString *passportCountry;
@property (nonatomic, strong) NSString *passportNumber;
@property (nonatomic, strong) NSString *religion;
@property (nonatomic, strong) NSString *visaType;
@property (nonatomic, strong) NSString *validityStatus;

@property (nonatomic, strong) NSDate *expiryDate;
@property (nonatomic, strong) NSDate *dateOfBirth;

@property (nonatomic, strong) Account *sponsoringCompany;
@property (nonatomic, strong) Account *visaHolder;
@property (nonatomic, strong) Country *countryOfBirth;
@property (nonatomic, strong) Country *currentNationality;
@property (nonatomic, strong) Occupation *jobTitleAtImmigration;


- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name PersonalPhoto:(NSString*)PersonalPhoto Salutation:(NSString*)Salutation SalutationArabic:(NSString*)SalutationArabic ApplicantFullName:(NSString*)ApplicantFullName ApplicantFirstNameArabic:(NSString*)ApplicantFirstNameArabic ApplicantMiddleNameArabic:(NSString*)ApplicantMiddleNameArabic ApplicantLastNameArabic:(NSString*)ApplicantLastNameArabic ApplicantEmail:(NSString*)ApplicantEmail ApplicantMobileNumber:(NSString*)ApplicantMobileNumber ApplicantGender:(NSString*)ApplicantGender PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber Religion:(NSString*)Religion VisaType:(NSString*)VisaType ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate DateOfBirth:(NSString*)DateOfBirth SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder CountryOfBirth:(Country*)CountryOfBirth CurrentNationality:(Country*)CurrentNationality JobTitleAtImmigration:(Occupation*)JobTitleAtImmigration;

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber
SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder;

@end
