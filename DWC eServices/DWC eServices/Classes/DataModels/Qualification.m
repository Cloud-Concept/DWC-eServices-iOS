//
//  Qualification.m
//  iDWC
//
//  Created by Mina Zaklama on 6/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Qualification.h"
#import "HelperClass.h"

@implementation Qualification
- (id)initQualification:(NSDictionary *)qualificationDict {
    if (!(self = [super init]))
        return nil;
    
    if ([qualificationDict isKindOfClass:[NSNull class]] || qualificationDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[qualificationDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[qualificationDict objectForKey:@"Name"]];
    self.eDNRDCode = [HelperClass stringCheckNull:[qualificationDict objectForKey:@"eDNRD_Name__c"]];
    self.eFormCode = [HelperClass stringCheckNull:[qualificationDict objectForKey:@"eForm_Code__c"]];
    self.qualificationNameArabic = [HelperClass stringCheckNull:[qualificationDict objectForKey:@"Qualification_Name_Arabic__c"]];
    
    self.isActive = [[qualificationDict objectForKey:@"Is_Active__c"] boolValue];
    
    return self;
}
@end
