//
//  ShareOwnership.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ShareOwnership.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "Account.h"

@implementation ShareOwnership

- (id)initShareOwnership:(NSDictionary *)shareOwnershipDict {
    if (!(self = [super init]))
        return nil;
    
    if ([shareOwnershipDict isKindOfClass:[NSNull class]] || shareOwnershipDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[shareOwnershipDict objectForKey:@"Id"]];
    self.personalPhotoId = [HelperClass stringCheckNull:[shareOwnershipDict objectForKey:@"Personal_Photo__c"]];
    self.noOfShares = [HelperClass numberCheckNull:[shareOwnershipDict objectForKey:@"No_of_Shares__c"]];
    self.ownershipOfShare = [HelperClass numberCheckNull:[shareOwnershipDict objectForKey:@"Ownership_of_Share__c"]];
    self.shareholderStatus = [HelperClass stringCheckNull:[shareOwnershipDict objectForKey:@"Shareholder_Status__c"]];
    
    if (![[shareOwnershipDict objectForKey:@"Ownership_Start_Date__c"] isKindOfClass:[NSNull class]])
        self.ownershipStartDate = [SFDateUtil SOQLDateTimeStringToDate:
                                   [shareOwnershipDict objectForKey:@"Ownership_Start_Date__c"]];
    
    if (![[shareOwnershipDict objectForKey:@"Ownership_End_Date__c"] isKindOfClass:[NSNull class]])
        self.ownershipEndDate = [SFDateUtil SOQLDateTimeStringToDate:[shareOwnershipDict objectForKey:@"Ownership_End_Date__c"]];
    
    self.shareholder = [[Account alloc] initAccount:[shareOwnershipDict objectForKey:@"Shareholder__r"]];
    
    return self;
}

- (id)initShareOwnership:(NSString *)ShareId NoOfShares:(NSNumber *)NoOfShares OwnershipOfShare:(NSNumber *)OwnershipOfShare ShareholderStatus:(NSString *)ShareholderStatus OwnershipStartDate:(NSString *)OwnershipStartDate OwnershipEndDate:(NSString *)OwnershipEndDate Shareholder:(Account *)Shareholder {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:ShareId];
    self.noOfShares = [HelperClass numberCheckNull:NoOfShares];
    self.ownershipOfShare = [HelperClass numberCheckNull:OwnershipOfShare];
    self.shareholderStatus = [HelperClass stringCheckNull:ShareholderStatus];
    
    if (![OwnershipStartDate isKindOfClass:[NSNull class]])
        self.ownershipStartDate = [SFDateUtil SOQLDateTimeStringToDate:OwnershipStartDate];
    
    if (![OwnershipEndDate isKindOfClass:[NSNull class]])
        self.ownershipEndDate = [SFDateUtil SOQLDateTimeStringToDate:OwnershipEndDate];
    
    self.shareholder = Shareholder;
    
    return self;
}

@end
