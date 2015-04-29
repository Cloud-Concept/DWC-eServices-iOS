//
//  ManagementMember.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ManagementMember.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "Account.h"

@implementation ManagementMember

- (id)initManagementMember:(NSDictionary *)managementMemberDict {
    if (!(self = [super init]))
        return nil;
    
    if ([managementMemberDict isKindOfClass:[NSNull class]] || managementMemberDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[managementMemberDict objectForKey:@"Id"]];
    self.managerStatus = [HelperClass stringCheckNull:[managementMemberDict objectForKey:@"Manager_Status__c"]];
    self.role = [HelperClass stringCheckNull:[managementMemberDict objectForKey:@"Role__c"]];
    self.status = [HelperClass stringCheckNull:[managementMemberDict objectForKey:@"Status__c"]];
    self.personalPhotoId = [HelperClass stringCheckNull:[managementMemberDict objectForKey:@"Personal_Photo__c"]];
    
    if (![[managementMemberDict objectForKey:@"Manager_Start_Date__c"] isKindOfClass:[NSNull class]])
        self.managerStartDate = [SFDateUtil SOQLDateTimeStringToDate:[managementMemberDict objectForKey:@"Manager_Start_Date__c"]];
    
    if (![[managementMemberDict objectForKey:@"Manager_End_Date__c"] isKindOfClass:[NSNull class]])
        self.managerEndDate = [SFDateUtil SOQLDateTimeStringToDate:[managementMemberDict objectForKey:@"Manager_End_Date__c"]];
    
    
    self.manager = [[Account alloc] initAccount:[managementMemberDict objectForKey:@"Manager__r"]];
    
    return self;
}

- (id)initManagementMember:(NSString *)MemberId ManagerStatus:(NSString *)ManagerStatus Role:(NSString *)Role Status:(NSString *)Status ManagerStartDate:(NSString *)ManagerStartDate ManagerEndDate:(NSString *)ManagerEndDate Manager:(Account *)Manager {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:MemberId];
    self.managerStatus = [HelperClass stringCheckNull:ManagerStatus];
    self.role = [HelperClass stringCheckNull:Role];
    self.status = [HelperClass stringCheckNull:Status];
    
    if (![ManagerStartDate isKindOfClass:[NSNull class]])
        self.managerStartDate = [SFDateUtil SOQLDateTimeStringToDate:ManagerStartDate];
    
    if (![ManagerEndDate isKindOfClass:[NSNull class]])
        self.managerEndDate = [SFDateUtil SOQLDateTimeStringToDate:ManagerEndDate];
    
    
    self.manager = Manager;
    
    return self;
}

@end
