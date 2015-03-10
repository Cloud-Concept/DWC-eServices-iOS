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
    self.currentLicenseNumber = CurrentLicenseNumber;
    
    return self;
}
@end
