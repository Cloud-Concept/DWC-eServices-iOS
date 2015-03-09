//
//  LegalRepresentative.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "LegalRepresentative.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation LegalRepresentative

- (id)initLegalRepresentative:(NSString *)legalId Role:(NSString *)Role Status:(NSString *)Status LegalRepresentativeStartDate:(NSString *)LegalRepresentativeStartDate LegalRepresentativeEndDate:(NSString *)LegalRepresentativeEndDate LegalRepresentative:(Account *)LegalRepresentative {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:legalId];
    self.role = [HelperClass stringCheckNull:Role];
    self.status = [HelperClass stringCheckNull:Status];
    
    if (![LegalRepresentativeStartDate isKindOfClass:[NSNull class]])
        self.legalRepresentativeStartDate = [SFDateUtil SOQLDateTimeStringToDate:LegalRepresentativeStartDate];
    
    if (![LegalRepresentativeEndDate isKindOfClass:[NSNull class]])
        self.legalRepresentativeEndDate = [SFDateUtil SOQLDateTimeStringToDate:LegalRepresentativeEndDate];
    
    self.legalRepresentative = LegalRepresentative;
    
    return self;
}

@end
