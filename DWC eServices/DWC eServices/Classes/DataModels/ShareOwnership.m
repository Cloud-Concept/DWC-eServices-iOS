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

@implementation ShareOwnership

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
