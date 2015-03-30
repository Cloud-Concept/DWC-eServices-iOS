//
//  TenancyContract.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/17/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Quote;

@interface TenancyContract : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *contractType;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *contractDurationMonth;
@property (nonatomic, strong) NSString *contractNumber;
@property (nonatomic, strong) NSNumber *totalRentPrice;
@property (nonatomic, strong) NSNumber *contractDurationYear;
@property (nonatomic, strong) NSDate *activatedDate;
@property (nonatomic, strong) NSDate *rentStartDate;
@property (nonatomic, strong) NSDate *contractStartDate;
@property (nonatomic, strong) NSDate *contractExpiryDate;
@property (nonatomic) BOOL isBCContract;

@property (nonatomic, strong) Quote *quote;

- (id)initTenancyContract:(NSDictionary *)tenancyContractDict;
/*
- (id)initTenanctContract:(NSString *)TenancyContractId Name:(NSString *)Name ContractType:(NSString *)ContractType Status:(NSString *)Status ContractDurationMonth:(NSString *)ContractDurationMonth ActivatedDate:(NSString *)ActivatedDate RentStartDate:(NSString *)RentStartDate ContractStartDate:(NSString *)ContractStartDate ContractExpiryDate:(NSString *)ContractExpiryDate TotalRentPrice:(NSNumber *)TotalRentPrice ContractDurationYear:(NSNumber *)ContractDurationYear IsBCContract:(BOOL)IsBCContract;
*/

@end
