//
//  Occupation.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Occupation.h"
#import "HelperClass.h"

@implementation Occupation

- (id)initOccupation:(NSDictionary *)occupationDict {
    if (!(self = [super init]))
        return nil;
    
    if ([occupationDict isKindOfClass:[NSNull class]] || occupationDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[occupationDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[occupationDict objectForKey:@"Name"]];
    self.arabicName = [HelperClass stringCheckNull:[occupationDict objectForKey:@"Occupation_Arabic__c"]];
    self.eDNRDName = [HelperClass stringCheckNull:[occupationDict objectForKey:@"eDNRD_Name__c"]];
    self.eFormCode = [HelperClass stringCheckNull:[occupationDict objectForKey:@"eForm_Code__c"]];
    self.isActive = [[occupationDict objectForKey:@"Is_Active__c"] boolValue];
    
    return self;
}

- (id)initOccupation:(NSString*)OccupationId OccupationName:(NSString*)OccupationName ArabicName:(NSString*)ArabicName DNRDName:(NSString*)DNRDName FormCode:(NSString*)FormCode IsActive:(BOOL)IsActive {
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:OccupationId];
    self.name = [HelperClass stringCheckNull:OccupationName];
    self.arabicName = [HelperClass stringCheckNull:ArabicName];
    self.eDNRDName = [HelperClass stringCheckNull:DNRDName];
    self.eFormCode = [HelperClass stringCheckNull:FormCode];
    self.isActive = IsActive;
    
    return self;
}
@end
