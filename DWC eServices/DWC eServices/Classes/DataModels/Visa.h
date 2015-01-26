//
//  Visa.h
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface Visa : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *passportCountry;
@property (nonatomic, strong) NSString *passportNumber;
@property (nonatomic, strong) Account *sponsoringCompany;
@property (nonatomic, strong) Account *visaHolder;

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder;

@end
