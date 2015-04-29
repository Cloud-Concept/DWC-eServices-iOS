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

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *personalPhotoId;
@property (nonatomic, strong) NSNumber *noOfShares;
@property (nonatomic, strong) NSNumber *ownershipOfShare;
@property (nonatomic, strong) NSString *shareholderStatus;
@property (nonatomic, strong) NSDate *ownershipStartDate;
@property (nonatomic, strong) NSDate *ownershipEndDate;
@property (nonatomic, strong) Account *shareholder;

- (id)initShareOwnership:(NSDictionary *)shareOwnershipDict;
/*
- (id)initShareOwnership:(NSString *)ShareId NoOfShares:(NSNumber *)NoOfShares OwnershipOfShare:(NSNumber *)OwnershipOfShare ShareholderStatus:(NSString *)ShareholderStatus OwnershipStartDate:(NSString *)OwnershipStartDate OwnershipEndDate:(NSString *)OwnershipEndDate Shareholder:(Account *)Shareholder;
*/
@end
