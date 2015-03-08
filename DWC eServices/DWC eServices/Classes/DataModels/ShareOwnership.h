//
//  ShareOwnership.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface ShareOwnership : NSObject

//No_of_Shares__c, Ownership_of_Share__c, Shareholder__r.Id, Shareholder__r.Name, Shareholder_Status__c, Ownership_End_Date__c, Ownership_Start_Date__c

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSNumber *noOfShares;
@property (nonatomic, strong) NSNumber *ownershipOfShare;
@property (nonatomic, strong) NSString *shareholderStatus;
@property (nonatomic, strong) NSDate *ownershipStartDate;
@property (nonatomic, strong) NSDate *ownershipEndDate;
@property (nonatomic, strong) Account *shareholder;

- (id)initShareOwnership:(NSString *)ShareId NoOfShares:(NSNumber *)NoOfShares OwnershipOfShare:(NSNumber *)OwnershipOfShare ShareholderStatus:(NSString *)ShareholderStatus OwnershipStartDate:(NSString *)OwnershipStartDate OwnershipEndDate:(NSString *)OwnershipEndDate Shareholder:(Account *)Shareholder;

@end
