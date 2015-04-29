//
//  ManagementMember.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface ManagementMember : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *managerStatus;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *personalPhotoId;
@property (nonatomic, strong) NSDate *managerStartDate;
@property (nonatomic, strong) NSDate *managerEndDate;
@property (nonatomic, strong) Account *manager;

- (id)initManagementMember:(NSDictionary *)managementMemberDict;
/*
- (id)initManagementMember:(NSString *)MemberId ManagerStatus:(NSString *)ManagerStatus Role:(NSString *)Role Status:(NSString *)Status ManagerStartDate:(NSString *)ManagerStartDate ManagerEndDate:(NSString *)ManagerEndDate Manager:(Account *)Manager;
*/
@end
