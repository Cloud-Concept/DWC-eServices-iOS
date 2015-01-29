//
//  Visa.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Visa.h"
#import "SFDateUtil.h"

@implementation Visa

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder {
    if (!(self = [super init]))
        return nil;
    
    self.Id = VisaId;
    self.name = Name;
    self.validityStatus = ValidityStatus;
    
    if ([ExpiryDate isKindOfClass:[NSNull class]])
        self.expiryDate = [NSDate new];
    else
        self.expiryDate = [SFDateUtil SOQLDateTimeStringToDate:ExpiryDate];
    
    self.passportCountry = PassportCountry;
    self.passportNumber = PassportNumber;
    self.sponsoringCompany = SponsoringCompany;
    self.visaHolder = VisaHolder;
    
    return self;
}

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name PersonalPhoto:(NSString*)PersonalPhoto Salutation:(NSString*)Salutation SalutationArabic:(NSString*)SalutationArabic ApplicantFullName:(NSString*)ApplicantFullName ApplicantFirstNameArabic:(NSString*)ApplicantFirstNameArabic ApplicantMiddleNameArabic:(NSString*)ApplicantMiddleNameArabic ApplicantLastNameArabic:(NSString*)ApplicantLastNameArabic ApplicantEmail:(NSString*)ApplicantEmail ApplicantMobileNumber:(NSString*)ApplicantMobileNumber ApplicantGender:(NSString*)ApplicantGender PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber Religion:(NSString*)Religion VisaType:(NSString*)VisaType ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate DateOfBirth:(NSString*)DateOfBirth SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder CountryOfBirth:(Country*)CountryOfBirth CurrentNationality:(Country*)CurrentNationality JobTitleAtImmigration:(Occupation*)JobTitleAtImmigration {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = VisaId;
    self.name = Name;
    self.personalPhotoId = PersonalPhoto;
    self.salutation = Salutation;
    self.salutationArabic = SalutationArabic;
    self.applicantFullName = ApplicantFullName;
    self.applicantFirstNameArabic = ApplicantFirstNameArabic;
    self.applicantMiddleNameArabic = ApplicantMiddleNameArabic;
    self.applicantLastNameArabic = ApplicantLastNameArabic;
    self.applicantEmail = ApplicantEmail;
    self.applicantMobileNumber = ApplicantMobileNumber;
    self.applicantGender = ApplicantGender;
    self.passportCountry = PassportCountry;
    self.passportNumber = PassportNumber;
    self.religion = Religion;
    self.visaType = VisaType;
    self.validityStatus = ValidityStatus;
    
    if ([ExpiryDate isKindOfClass:[NSNull class]])
        self.expiryDate = [NSDate new];
    else
        self.expiryDate = [SFDateUtil SOQLDateTimeStringToDate:ExpiryDate];
    
    if ([DateOfBirth isKindOfClass:[NSNull class]])
        self.dateOfBirth = [NSDate new];
    else
        self.dateOfBirth = [SFDateUtil SOQLDateTimeStringToDate:DateOfBirth];
    
    self.sponsoringCompany = SponsoringCompany;
    self.visaHolder = VisaHolder;
    self.countryOfBirth = CountryOfBirth;
    self.currentNationality = CurrentNationality;
    self.jobTitleAtImmigration = JobTitleAtImmigration;
    
    return self;
    
}
@end
