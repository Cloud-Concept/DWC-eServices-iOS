//
//  Visa.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Visa.h"
#import "SFDateUtil.h"
#import "HelperClass.h"

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

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name EmployeeId:(NSString*)EmployeeId PersonalPhoto:(NSString*)PersonalPhoto Salutation:(NSString*)Salutation SalutationArabic:(NSString*)SalutationArabic ApplicantFullName:(NSString*)ApplicantFullName ApplicantFirstNameArabic:(NSString*)ApplicantFirstNameArabic ApplicantMiddleNameArabic:(NSString*)ApplicantMiddleNameArabic ApplicantLastNameArabic:(NSString*)ApplicantLastNameArabic ApplicantEmail:(NSString*)ApplicantEmail ApplicantMobileNumber:(NSString*)ApplicantMobileNumber ApplicantGender:(NSString*)ApplicantGender PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber PassportExpiry:(NSString*)PassportExpiry Religion:(NSString*)Religion VisaType:(NSString*)VisaType ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate DateOfBirth:(NSString*)DateOfBirth SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder CountryOfBirth:(Country*)CountryOfBirth CurrentNationality:(Country*)CurrentNationality JobTitleAtImmigration:(Occupation*)JobTitleAtImmigration {
    
    return [self initVisa:VisaId Name:Name EmployeeId:EmployeeId PersonalPhoto:PersonalPhoto Salutation:Salutation SalutationArabic:SalutationArabic ApplicantFullName:ApplicantFullName ApplicantFirstNameArabic:ApplicantFirstNameArabic ApplicantMiddleNameArabic:ApplicantMiddleNameArabic ApplicantLastNameArabic:ApplicantLastNameArabic ApplicantEmail:ApplicantEmail ApplicantMobileNumber:ApplicantMobileNumber ApplicantGender:ApplicantGender PassportCountry:PassportCountry PassportNumber:PassportNumber PassportExpiry:PassportExpiry Religion:Religion VisaType:VisaType ValidityStatus:ValidityStatus ExpiryDate:ExpiryDate DateOfBirth:DateOfBirth AccompaniedBy:@"" VisitVisaDuration:@"" SponsoringCompany:SponsoringCompany VisaHolder:VisaHolder CountryOfBirth:CountryOfBirth CurrentNationality:CurrentNationality JobTitleAtImmigration:JobTitleAtImmigration];
    
}

-(id)initVisa:(NSString*)VisaId Name:(NSString*)Name EmployeeId:(NSString*)EmployeeId PersonalPhoto:(NSString*)PersonalPhoto Salutation:(NSString*)Salutation SalutationArabic:(NSString*)SalutationArabic ApplicantFullName:(NSString*)ApplicantFullName ApplicantFirstNameArabic:(NSString*)ApplicantFirstNameArabic ApplicantMiddleNameArabic:(NSString*)ApplicantMiddleNameArabic ApplicantLastNameArabic:(NSString*)ApplicantLastNameArabic ApplicantEmail:(NSString*)ApplicantEmail ApplicantMobileNumber:(NSString*)ApplicantMobileNumber ApplicantGender:(NSString*)ApplicantGender PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber PassportExpiry:(NSString*)PassportExpiry Religion:(NSString*)Religion VisaType:(NSString*)VisaType ValidityStatus:(NSString*)ValidityStatus ExpiryDate:(NSString*)ExpiryDate DateOfBirth:(NSString*)DateOfBirth AccompaniedBy:(NSString*)AccompaniedBy VisitVisaDuration:(NSString*)VisitVisaDuration SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder CountryOfBirth:(Country*)CountryOfBirth CurrentNationality:(Country*)CurrentNationality JobTitleAtImmigration:(Occupation*)JobTitleAtImmigration {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:VisaId];
    self.name = [HelperClass stringCheckNull:Name];
    self.employeeID = [HelperClass stringCheckNull:EmployeeId];
    self.personalPhotoId = [HelperClass stringCheckNull:PersonalPhoto];
    self.salutation = [HelperClass stringCheckNull:Salutation];
    self.salutationArabic = [HelperClass stringCheckNull:SalutationArabic];
    self.applicantFullName = [HelperClass stringCheckNull:ApplicantFullName];
    self.applicantFirstNameArabic = [HelperClass stringCheckNull:ApplicantFirstNameArabic];
    self.applicantMiddleNameArabic = [HelperClass stringCheckNull:ApplicantMiddleNameArabic];
    self.applicantLastNameArabic = [HelperClass stringCheckNull:ApplicantLastNameArabic];
    self.applicantEmail = [HelperClass stringCheckNull:ApplicantEmail];
    self.applicantMobileNumber = [HelperClass stringCheckNull:ApplicantMobileNumber];
    self.applicantGender = [HelperClass stringCheckNull:ApplicantGender];
    self.passportCountry = [HelperClass stringCheckNull:PassportCountry];
    self.passportNumber = [HelperClass stringCheckNull:PassportNumber];
    self.religion = [HelperClass stringCheckNull:Religion];
    self.visaType = [HelperClass stringCheckNull:VisaType];
    self.validityStatus = [HelperClass stringCheckNull:ValidityStatus];
    self.accompaniedBy = [HelperClass stringCheckNull:AccompaniedBy];
    self.visitVisaDuration = [HelperClass stringCheckNull:VisitVisaDuration];

    if ([ExpiryDate isKindOfClass:[NSNull class]])
        self.expiryDate = [NSDate new];
    else
        self.expiryDate = [SFDateUtil SOQLDateTimeStringToDate:ExpiryDate];
    
    if ([DateOfBirth isKindOfClass:[NSNull class]])
        self.dateOfBirth = [NSDate new];
    else
        self.dateOfBirth = [SFDateUtil SOQLDateTimeStringToDate:DateOfBirth];
    
    if ([PassportExpiry isKindOfClass:[NSNull class]])
        self.passportExpiry = [NSDate new];
    else
        self.passportExpiry = [SFDateUtil SOQLDateTimeStringToDate:PassportExpiry];
    
    self.sponsoringCompany = SponsoringCompany;
    self.visaHolder = VisaHolder;
    self.countryOfBirth = CountryOfBirth;
    self.currentNationality = CurrentNationality;
    self.jobTitleAtImmigration = JobTitleAtImmigration;
    
    return self;
    
}
@end
