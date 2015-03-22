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
#import "Account.h"

@implementation LegalRepresentative

- (id)initLegalRepresentative:(NSDictionary *)legalRepresentativeDict {
    if (!(self = [super init]))
        return nil;
    
    if ([legalRepresentativeDict isKindOfClass:[NSNull class]] || legalRepresentativeDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[legalRepresentativeDict objectForKey:@"Id"]];
    self.role = [HelperClass stringCheckNull:[legalRepresentativeDict objectForKey:@"Role__c"]];
    self.status = [HelperClass stringCheckNull:[legalRepresentativeDict objectForKey:@"Status__c"]];
    
    if (![[legalRepresentativeDict objectForKey:@"Legal_Representative_Start_Date__c"] isKindOfClass:[NSNull class]])
        self.legalRepresentativeStartDate = [SFDateUtil SOQLDateTimeStringToDate:
                                             [legalRepresentativeDict objectForKey:@"Legal_Representative_Start_Date__c"]];
    
    if (![[legalRepresentativeDict objectForKey:@"Legal_Representative_End_Date__c"] isKindOfClass:[NSNull class]])
        self.legalRepresentativeEndDate = [SFDateUtil SOQLDateTimeStringToDate:
                                           [legalRepresentativeDict objectForKey:@"Legal_Representative_End_Date__c"]];
    
    self.legalRepresentative = [[Account alloc] initAccount:[legalRepresentativeDict objectForKey:@"Legal_Representative__r"]];
    
    return self;
}

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
