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
#import "Account.h"
#import "Country.h"
#import "Occupation.h"
#import "Passport.h"
#import "Qualification.h"

@implementation Visa

- (id)initVisa:(NSDictionary *)visaDict {
    if (!(self = [super init]))
        return nil;
    
    if ([visaDict isKindOfClass:[NSNull class]] || visaDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[visaDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[visaDict objectForKey:@"Name"]];
    self.personalPhotoId = [HelperClass stringCheckNull:[visaDict objectForKey:@"Personal_Photo__c"]];
    self.salutation = [HelperClass stringCheckNull:[visaDict objectForKey:@"Salutation__c"]];
    self.salutationArabic = [HelperClass stringCheckNull:[visaDict objectForKey:@"Salutation_Arabic__c"]];
    self.applicantFullName = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Full_Name__c"]];
    self.applicantFirstNameArabic = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_First_Name_Arabic__c"]];
    self.applicantMiddleNameArabic = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Middle_Name_Arabic__c"]];
    self.applicantLastNameArabic = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Last_Name_Arabic__c"]];
    self.applicantEmail = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Email__c"]];
    self.applicantMobileNumber = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Mobile_Number__c"]];
    self.applicantGender = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Gender__c"]];
    self.passportCountry = [HelperClass stringCheckNull:[visaDict objectForKey:@"Passport_Country__c"]];
    self.passportNumber = [HelperClass stringCheckNull:[visaDict objectForKey:@"Passport_Number__c"]];
    self.religion = [HelperClass stringCheckNull:[visaDict objectForKey:@"Religion__c"]];
    self.visaType = [HelperClass stringCheckNull:[visaDict objectForKey:@"Visa_Type__c"]];
    self.validityStatus = [HelperClass stringCheckNull:[visaDict objectForKey:@"Visa_Validity_Status__c"]];
    self.employeeID = [HelperClass stringCheckNull:[visaDict objectForKey:@"Employee_ID__c"]];
    self.accompaniedBy = [HelperClass stringCheckNull:[visaDict objectForKey:@"Accompanied_By__c"]];
    self.visitVisaDuration = [HelperClass stringCheckNull:[visaDict objectForKey:@"Visit_Visa_Duration__c"]];
    
    self.applicantFirstName = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_First_Name__c"]];
    self.applicantMiddleName = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Middle_Name__c"]];
    self.applicantLastName = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Last_Name__c"]];
    self.dependentVisaType = [HelperClass stringCheckNull:[visaDict objectForKey:@"Dependent_Visa_Type__c"]];
    self.languages = [HelperClass stringCheckNull:[visaDict objectForKey:@"Languages__c"]];
    self.maritalStatus = [HelperClass stringCheckNull:[visaDict objectForKey:@"Marital_Status__c"]];
    self.motherName = [HelperClass stringCheckNull:[visaDict objectForKey:@"Mother_Name__c"]];
    self.passportPlaceOfIssue = [HelperClass stringCheckNull:[visaDict objectForKey:@"Passport_Place_of_Issue__c"]];
    self.placeOfBirth = [HelperClass stringCheckNull:[visaDict objectForKey:@"Place_of_Birth__c"]];
    self.serviceIdentifier = [HelperClass stringCheckNull:[visaDict objectForKey:@"Service_Identifier__c"]];
    self.transferringCompanyExternal = [HelperClass stringCheckNull:[visaDict objectForKey:@"Transferring_Company_External__c"]];
    self.transferringFreezone = [HelperClass stringCheckNull:[visaDict objectForKey:@"Transferring_Freezone__c"]];
    self.applicantFullNameArabic  = [HelperClass stringCheckNull:[visaDict objectForKey:@"Applicant_Full_Name_Arabic__c"]];
    
    self.deliverEntryPermit = [[visaDict objectForKey:@"Deliver_Entry_Permit__c"] boolValue];
    self.deliverPassportVisaStamped = [[visaDict objectForKey:@"Deliver_Passport_Visa_Stamped__c"] boolValue];
    self.inCountry = [[visaDict objectForKey:@"In_Country__c"] boolValue];
    self.localAmendment = [[visaDict objectForKey:@"Local_Amendment__c"] boolValue];
    self.urgentProcessing = [[visaDict objectForKey:@"urgent_Processing__c"] boolValue];
    self.urgentStamping = [[visaDict objectForKey:@"Urgent_Stamping__c"] boolValue];

    self.monthlyAllowancesInAED = [HelperClass numberCheckNull:[visaDict objectForKey:@"Monthly_Allowances_in_AED__c"]];
    self.monthlyBasicSalaryInAED = [HelperClass numberCheckNull:[visaDict objectForKey:@"Monthly_Basic_Salary_in_AED__c"]];
    
    if (![[visaDict objectForKey:@"Passport_Expiry__c"] isKindOfClass:[NSNull class]])
        self.passportExpiry = [SFDateUtil SOQLDateTimeStringToDate:[visaDict objectForKey:@"Passport_Expiry__c"]];
    
    if (![[visaDict objectForKey:@"Visa_Expiry_Date__c"] isKindOfClass:[NSNull class]])
        self.expiryDate = [SFDateUtil SOQLDateTimeStringToDate:[visaDict objectForKey:@"Visa_Expiry_Date__c"]];
    
    if (![[visaDict objectForKey:@"Date_of_Birth__c"] isKindOfClass:[NSNull class]])
        self.dateOfBirth = [SFDateUtil SOQLDateTimeStringToDate:[visaDict objectForKey:@"Date_of_Birth__c"]];
    
    self.sponsoringCompany = [[Account alloc] initAccount:[visaDict objectForKey:@"Sponsoring_Company__r"]];
    self.visaHolder = [[Account alloc] initAccount:[visaDict objectForKey:@"Visa_Holder__r"]];
    self.countryOfBirth = [[Country alloc] initCountry:[visaDict objectForKey:@"Country_of_Birth__r"]];
    self.currentNationality = [[Country alloc] initCountry:[visaDict objectForKey:@"Current_Nationality__r"]];
    self.jobTitleAtImmigration = [[Occupation alloc] initOccupation:[visaDict objectForKey:@"Job_Title_at_Immigration__r"]];
    
    self.passport = [[Passport alloc] initPassport:[visaDict objectForKey:@"Passport__r"]];
    self.passportIssueCountry = [[Country alloc] initCountry:[visaDict objectForKey:@"Passport_Issue_Country__r"]];
    self.previousNationality = [[Country alloc] initCountry:[visaDict objectForKey:@"Previous_Nationality__r"]];
    self.qualification = [[Qualification alloc] initQualification:[visaDict objectForKey:@"Qualification__r"]];
    self.renewalForVisa = [[Visa alloc] initVisa:[visaDict objectForKey:@"Renewal_for_Visa__r"]];
    self.sponsoringEmployeeAcc = [[Account alloc] initAccount:[visaDict objectForKey:@"Sponsoring_Employee_Acc__r"]];
    self.transferringCompany = [[Account alloc] initAccount:[visaDict objectForKey:@"Transferring_Company__r"]];
    
    return self;
}

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
