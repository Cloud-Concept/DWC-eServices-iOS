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

@implementation ManagementMember

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
