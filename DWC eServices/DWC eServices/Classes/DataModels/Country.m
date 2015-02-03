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
