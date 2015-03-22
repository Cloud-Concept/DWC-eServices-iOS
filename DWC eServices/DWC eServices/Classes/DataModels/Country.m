//
//  Country.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Country.h"
#import "HelperClass.h"

@implementation Country

- (id)initCountry:(NSDictionary *)countryDict {
    if (!(self = [super init]))
        return nil;
    
    if ([countryDict isKindOfClass:[NSNull class]] || countryDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[countryDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[countryDict objectForKey:@"Name"]];
    self.aramexCountryCode = [HelperClass stringCheckNull:[countryDict objectForKey:@"Aramex_Country_Code__c"]];
    self.countryNameArabic = [HelperClass stringCheckNull:[countryDict objectForKey:@"Country_Name_Arabic__c"]];
    self.eDNRDName = [HelperClass stringCheckNull:[countryDict objectForKey:@"eDNRD_Name__c"]];
    self.eFormCode = [HelperClass stringCheckNull:[countryDict objectForKey:@"eForm_Code__c"]];
    self.isActive = [[countryDict objectForKey:@"Is_Active__c"] boolValue];
    self.nationalityName = [HelperClass stringCheckNull:[countryDict objectForKey:@"Nationality_Name__c"]];
    self.nationalityNameArabic = [HelperClass stringCheckNull:[countryDict objectForKey:@"Nationality_Name_Arabic__c"]];
    
    return self;
}

- (id)initCountry:(NSString*)countryId Name:(NSString*)Name AramexCountryCode:(NSString*)AramexCountryCode CountryNameArabic:(NSString*)CountryNameArabic DNRDName:(NSString*)DNRDName FromCode:(NSString*)FormCode IsActive:(BOOL)IsActive NationalityName:(NSString*)NationalityName NationalityNameArabic:(NSString*)NationalityNameArabic {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:countryId];
    self.name = [HelperClass stringCheckNull:Name];
    self.aramexCountryCode = [HelperClass stringCheckNull:AramexCountryCode];
    self.countryNameArabic = [HelperClass stringCheckNull:CountryNameArabic];
    self.eDNRDName = [HelperClass stringCheckNull:DNRDName];
    self.eFormCode = [HelperClass stringCheckNull:FormCode];
    self.isActive = IsActive;
    self.nationalityName = [HelperClass stringCheckNull:NationalityName];
    self.nationalityNameArabic = [HelperClass stringCheckNull:NationalityNameArabic];
    
    return self;
    
}
@end
