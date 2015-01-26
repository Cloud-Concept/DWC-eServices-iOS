//
//  Visa.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Visa.h"

@implementation Visa

- (id)initVisa:(NSString*)VisaId Name:(NSString*)Name PassportCountry:(NSString*)PassportCountry PassportNumber:(NSString*)PassportNumber SponsoringCompany:(Account*)SponsoringCompany VisaHolder:(Account*)VisaHolder {
    if (!(self = [super init]))
        return nil;
    
    self.Id = VisaId;
    self.name = Name;
    self.passportCountry = PassportCountry;
    self.passportNumber = PassportNumber;
    self.sponsoringCompany = SponsoringCompany;
    self.visaHolder = VisaHolder;
    
    return self;
}

@end
