//
//  Directorship.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Directorship.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "Account.h"

@implementation Directorship

- (id)initDirectorship:(NSDictionary *)directorshipDict {
    if (!(self = [super init]))
        return nil;
    
    if ([directorshipDict isKindOfClass:[NSNull class]] || directorshipDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[directorshipDict objectForKey:@"Id"]];
    self.roles = [HelperClass stringCheckNull:[directorshipDict objectForKey:@"Roles__c"]];
    self.directorStatus = [HelperClass stringCheckNull:[directorshipDict objectForKey:@"Director_Status__c"]];
    
    if (![[directorshipDict objectForKey:@"Directorship_Start_Date__c"] isKindOfClass:[NSNull class]])
        self.directorshipStartDate = [SFDateUtil SOQLDateTimeStringToDate:
                                      [directorshipDict objectForKey:@"Directorship_Start_Date__c"]];
    
    if (![[directorshipDict objectForKey:@"Directorship_End_Date__c"] isKindOfClass:[NSNull class]])
        self.directorshipEndDate = [SFDateUtil SOQLDateTimeStringToDate:
                                    [directorshipDict objectForKey:@"Directorship_End_Date__c"]];
    
    self.director = [[Account alloc] initAccount:[directorshipDict objectForKey:@"Director__r"]];
    
    return self;
}

- (id)initDirectorship:(NSString *)DirectorId Roles:(NSString *)Roles DirectorStatus:(NSString *)DirectorStatus DirectorshipStartDate:(NSString *)DirectorshipStartDate DirectorshipEndDate:(NSString *)DirectorshipEndDate Director:(Account *)Director {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:DirectorId];
    self.roles = [HelperClass stringCheckNull:Roles];
    self.directorStatus = [HelperClass stringCheckNull:DirectorStatus];
    
    if (![DirectorshipStartDate isKindOfClass:[NSNull class]])
        self.directorshipStartDate = [SFDateUtil SOQLDateTimeStringToDate:DirectorshipStartDate];
    
    if (![DirectorshipEndDate isKindOfClass:[NSNull class]])
        self.directorshipEndDate = [SFDateUtil SOQLDateTimeStringToDate:DirectorshipEndDate];
    
    self.director = Director;
    
    return self;
}
@end
