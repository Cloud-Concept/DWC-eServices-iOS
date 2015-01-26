//
//  Country.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Country.h"

@implementation Country
- (id)initCountry:(NSString*)countryId Name:(NSString*)Name AramexCountryCode:(NSString*)AramexCountryCode CountryNameArabic:(NSString*)CountryNameArabic DNRDName:(NSString*)DNRDName FromCode:(NSString*)FormCode IsActive:(BOOL)IsActive NationalityName:(NSString*)NationalityName NationalityNameArabic:(NSString*)NationalityNameArabic {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = countryId;
    self.name = Name;
    self.aramexCountryCode = AramexCountryCode;
    self.countryNameArabic = CountryNameArabic;
    self.eDNRDName = DNRDName;
    self.eFormCode = FormCode;
    self.isActive = IsActive;
    self.nationalityName = NationalityName;
    self.nationalityNameArabic = NationalityNameArabic;
    
    return self;
    
}
@end
