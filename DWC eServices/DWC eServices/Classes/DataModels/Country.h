//
//  Country.h
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *aramexCountryCode;
@property (nonatomic, strong) NSString *countryNameArabic;
@property (nonatomic, strong) NSString *eDNRDName;
@property (nonatomic, strong) NSString *eFormCode;
@property (nonatomic) BOOL isActive;
@property (nonatomic, strong) NSString *nationalityName;
@property (nonatomic, strong) NSString *nationalityNameArabic;


- (id)initCountry:(NSString*)Id Name:(NSString*)Name AramexCountryCode:(NSString*)AramexCountryCode CountryNameArabic:(NSString*)CountryNameArabic DNRDName:(NSString*)DNRDName FromCode:(NSString*)FormCode IsActive:(BOOL)IsActive NationalityName:(NSString*)NationalityName NationalityNameArabic:(NSString*)NationalityNameArabic;

@end
