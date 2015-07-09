//
//  Account.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Account.h"
#import "SFDateUtil.h"
#import "HelperClass.h"
#import "Passport.h"
#import "License.h"

@implementation Account

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode {
    return [self initAccount:AccountId
                        Name:Name
              AccountBalance:nil
        LicenseNumberFormula:@""
    LicenseExpiryDateFormula:@""
     CompanyRegistrationDate:@""
                   LegalForm:@""
     RegistrationNumberValue:@""
                       Phone:@""
                         Fax:@""
                       Email:@""
                      Mobile:@""
                    ProEmail:@""
             ProMobileNumber:@""
               BillingStreet:@""
           BillingPostalCode:@""
              BillingCountry:@""
                BillingState:@""
                 BillingCity:BillingCity
          BillingCountryCode:BillingCountryCode
            CurrentLicenseNumber:nil];
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance {
    return [self initAccount:AccountId
                        Name:Name
              AccountBalance:AccountBalance
        LicenseNumberFormula:@""
    LicenseExpiryDateFormula:@""
     CompanyRegistrationDate:@""
                   LegalForm:@""
     RegistrationNumberValue:@""
                       Phone:@""
                         Fax:@""
                       Email:@""
                      Mobile:@""
                    ProEmail:@""
             ProMobileNumber:@""
               BillingStreet:@""
           BillingPostalCode:@""
              BillingCountry:@""
                BillingState:@""
                 BillingCity:@""
          BillingCountryCode:@""
            CurrentLicenseNumber:nil];
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name {
    return [self initAccount:AccountId
                        Name:Name
              AccountBalance:nil
                 BillingCity:@""
          BillingCountryCode:@""
        LicenseNumberFormula:@""
    LicenseExpiryDateFormula:@""];
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name Nationality:(NSString *)Nationality AccountPassport:(Passport *)AccountPassport {
    return [self initAccount:AccountId
                        Name:Name
              AccountBalance:nil
        LicenseNumberFormula:@""
    LicenseExpiryDateFormula:@""
     CompanyRegistrationDate:@""
                   LegalForm:@""
     RegistrationNumberValue:@""
                       Phone:@""
                         Fax:@""
                       Email:@""
                      Mobile:@""
                    ProEmail:@""
             ProMobileNumber:@""
               BillingStreet:@""
           BillingPostalCode:@""
              BillingCountry:@""
                BillingState:@""
                 BillingCity:@""
          BillingCountryCode:@""
                 Nationality:Nationality
        CurrentLicenseNumber:nil
             AccountPassport:AccountPassport];
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula {
    
    return [self initAccount:AccountId
                        Name:Name
              AccountBalance:AccountBalance
        LicenseNumberFormula:LicenseNumberFormula
    LicenseExpiryDateFormula:LicenseExpiryDateFormula
     CompanyRegistrationDate:@""
                   LegalForm:@""
     RegistrationNumberValue:@""
                       Phone:@""
                         Fax:@""
                       Email:@""
                      Mobile:@""
                    ProEmail:@""
             ProMobileNumber:@""
               BillingStreet:@""
           BillingPostalCode:@""
              BillingCountry:@""
                BillingState:@""
                 BillingCity:BillingCity
          BillingCountryCode:BillingCountryCode
            CurrentLicenseNumber:nil];
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula CompanyRegistrationDate:(NSString *)CompanyRegistrationDate LegalForm:(NSString *)LegalForm RegistrationNumberValue:(NSString *)RegistrationNumberValue Phone:(NSString *)Phone Fax:(NSString *)Fax Email:(NSString *)Email Mobile:(NSString *)Mobile ProEmail:(NSString *)ProEmail ProMobileNumber:(NSString *)ProMobileNumber BillingStreet:(NSString *)BillingStreet BillingPostalCode:(NSString *)BillingPostalCode BillingCountry:(NSString *)BillingCountry BillingState:(NSString *)BillingState BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode CurrentLicenseNumber:(License *)CurrentLicenseNumber{
    
    return [self initAccount:AccountId
                        Name:Name
              AccountBalance:AccountBalance
        LicenseNumberFormula:LicenseNumberFormula
    LicenseExpiryDateFormula:LicenseExpiryDateFormula
     CompanyRegistrationDate:CompanyRegistrationDate
                   LegalForm:LegalForm
     RegistrationNumberValue:RegistrationNumberValue
                       Phone:Phone
                         Fax:Fax
                       Email:Email
                      Mobile:Mobile
                    ProEmail:ProEmail
             ProMobileNumber:ProMobileNumber
               BillingStreet:BillingStreet
           BillingPostalCode:BillingPostalCode
              BillingCountry:BillingCountry
                BillingState:BillingState
                 BillingCity:BillingCity
          BillingCountryCode:BillingCountryCode
                 Nationality:@""
        CurrentLicenseNumber:CurrentLicenseNumber
             AccountPassport:nil];
}

- (id)initAccount:(NSString*)AccountId Name:(NSString*)Name AccountBalance:(NSNumber*)AccountBalance LicenseNumberFormula:(NSString*)LicenseNumberFormula LicenseExpiryDateFormula:(NSString*)LicenseExpiryDateFormula CompanyRegistrationDate:(NSString *)CompanyRegistrationDate LegalForm:(NSString *)LegalForm RegistrationNumberValue:(NSString *)RegistrationNumberValue Phone:(NSString *)Phone Fax:(NSString *)Fax Email:(NSString *)Email Mobile:(NSString *)Mobile ProEmail:(NSString *)ProEmail ProMobileNumber:(NSString *)ProMobileNumber BillingStreet:(NSString *)BillingStreet BillingPostalCode:(NSString *)BillingPostalCode BillingCountry:(NSString *)BillingCountry BillingState:(NSString *)BillingState BillingCity:(NSString*)BillingCity BillingCountryCode:(NSString*)BillingCountryCode Nationality:(NSString *)Nationality CurrentLicenseNumber:(License *)CurrentLicenseNumber AccountPassport:(Passport *)AccountPassport {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:AccountId];
    self.name = [HelperClass stringCheckNull:Name];
    self.accountBalance = [HelperClass numberCheckNull:AccountBalance];
    self.licenseNumberFormula = [HelperClass stringCheckNull:LicenseNumberFormula];
    
    if (![LicenseExpiryDateFormula isKindOfClass:[NSNull class]])
        self.licenseExpiryDateFormula = [SFDateUtil SOQLDateTimeStringToDate:LicenseExpiryDateFormula];
    
    if (![CompanyRegistrationDate isKindOfClass:[NSNull class]])
        self.companyRegistrationDate = [SFDateUtil SOQLDateTimeStringToDate:CompanyRegistrationDate];
    
    self.legalForm = [HelperClass stringCheckNull:LegalForm];
    self.registrationNumberValue  = [HelperClass stringCheckNull:RegistrationNumberValue];
    self.phone = [HelperClass stringCheckNull:Phone];
    self.fax = [HelperClass stringCheckNull:Fax];
    self.email = [HelperClass stringCheckNull:Email];
    self.mobile = [HelperClass stringCheckNull:Mobile];
    self.proEmail = [HelperClass stringCheckNull:ProEmail];
    self.proMobileNumber  = [HelperClass stringCheckNull:ProMobileNumber];
    self.billingStreet  = [HelperClass stringCheckNull:BillingStreet];
    self.billingPostalCode  = [HelperClass stringCheckNull:BillingPostalCode];
    self.billingCountry = [HelperClass stringCheckNull:BillingCountry];
    self.billingState = [HelperClass stringCheckNull:BillingState];
    self.billingCity = [HelperClass stringCheckNull:BillingCity];
    self.billingCountryCode = [HelperClass stringCheckNull:BillingCountryCode];
    self.nationality = [HelperClass stringCheckNull:Nationality];
    self.currentLicenseNumber = CurrentLicenseNumber;
    self.currentPassport = AccountPassport;
    
    return self;
}

- (id)initAccount:(NSDictionary *)accountDict {
    if (!(self = [super init]))
        return nil;
    
    if ([accountDict isKindOfClass:[NSNull class]] || accountDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[accountDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[accountDict objectForKey:@"Name"]];
    self.accountBalance = [HelperClass numberCheckNull:[accountDict objectForKey:@"Account_Balance__c"]];
    self.portalBalance = [HelperClass numberCheckNull:[accountDict objectForKey:@"Portal_Balance__c"]];;
    self.licenseNumberFormula = [HelperClass stringCheckNull:[accountDict objectForKey:@"License_Number_Formula__c"]];
    
    if (![[accountDict objectForKey:@"License_Expiry_Date_Formula__c"] isKindOfClass:[NSNull class]])
        self.licenseExpiryDateFormula = [SFDateUtil SOQLDateTimeStringToDate:
                                         [accountDict objectForKey:@"License_Expiry_Date_Formula__c"]];
    
    if (![[accountDict objectForKey:@"Company_Registration_Date__c"] isKindOfClass:[NSNull class]])
        self.companyRegistrationDate = [SFDateUtil SOQLDateTimeStringToDate:
                                        [accountDict objectForKey:@"Company_Registration_Date__c"]];
    
    self.legalForm = [HelperClass stringCheckNull:[accountDict objectForKey:@"Legal_Form__c"]];
    self.registrationNumberValue  = [HelperClass stringCheckNull:[accountDict objectForKey:@"Registration_Number_Value__c"]];
    self.phone = [HelperClass stringCheckNull:[accountDict objectForKey:@"Phone"]];
    self.fax = [HelperClass stringCheckNull:[accountDict objectForKey:@"Fax"]];
    self.email = [HelperClass stringCheckNull:[accountDict objectForKey:@"Email__c"]];
    self.mobile = [HelperClass stringCheckNull:[accountDict objectForKey:@"Mobile__c"]];
    self.proEmail = [HelperClass stringCheckNull:[accountDict objectForKey:@"PRO_Email__c"]];
    self.proMobileNumber  = [HelperClass stringCheckNull:[accountDict objectForKey:@"PRO_Mobile_Number__c"]];
    self.billingStreet  = [HelperClass stringCheckNull:[accountDict objectForKey:@"BillingStreet"]];
    self.billingPostalCode  = [HelperClass stringCheckNull:[accountDict objectForKey:@"BillingPostalCode"]];
    self.billingCountry = [HelperClass stringCheckNull:[accountDict objectForKey:@"BillingCountry"]];
    self.billingState = [HelperClass stringCheckNull:[accountDict objectForKey:@"BillingState"]];
    self.billingCity = [HelperClass stringCheckNull:[accountDict objectForKey:@"BillingCity"]];
    self.billingCountryCode = [HelperClass stringCheckNull:[accountDict objectForKey:@"BillingCountryCode"]];
    self.nationality = [HelperClass stringCheckNull:[accountDict objectForKey:@"Nationality__c"]];
    self.companyLogo = [HelperClass stringCheckNull:[accountDict objectForKey:@"Company_Logo__c"]];
    self.arabicAccountName = [HelperClass stringCheckNull:[accountDict objectForKey:@"Arabic_Account_Name__c"]];
    self.personalPhotoId = [HelperClass stringCheckNull:[accountDict objectForKey:@"Personal_Photo__pc"]];
    
    self.currentLicenseNumber = [[License alloc] initLicense:
                                 [accountDict objectForKey:@"Current_License_Number__r"]];
    self.currentPassport = [[Passport alloc] initPassport:[accountDict objectForKey:@"Current_Passport__r"]];;
    
    self.currentManager = [[Account alloc] initAccount:[accountDict objectForKey:@"Current_Manager__r"]];
    
    return self;
}

- (NSString *)billingAddress {
    //{!acc.BillingStreet} {!acc.BillingPostalCode} {!acc.BillingCountry} {!acc.BillingState} {!acc.BillingCity}
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@", self.billingStreet, self.billingPostalCode, self.billingCountry, self.billingState, self.billingCity];
}

@end
