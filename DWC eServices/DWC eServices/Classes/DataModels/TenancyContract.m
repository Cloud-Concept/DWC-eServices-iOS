//
//  TenancyContract.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/17/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "TenancyContract.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation TenancyContract

- (id)initTenanctContract:(NSString *)TenancyContractId Name:(NSString *)Name ContractType:(NSString *)ContractType Status:(NSString *)Status ContractDurationMonth:(NSString *)ContractDurationMonth ActivatedDate:(NSString *)ActivatedDate RentStartDate:(NSString *)RentStartDate ContractStartDate:(NSString *)ContractStartDate ContractExpiryDate:(NSString *)ContractExpiryDate TotalRentPrice:(NSNumber *)TotalRentPrice ContractDurationYear:(NSNumber *)ContractDurationYear IsBCContract:(BOOL)IsBCContract {
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:TenancyContractId];
    self.name = [HelperClass stringCheckNull:Name];
    self.contractType = [HelperClass stringCheckNull:ContractType];
    self.status = [HelperClass stringCheckNull:Status];
    self.contractDurationMonth = [HelperClass stringCheckNull:ContractDurationMonth];
    
    if (![ActivatedDate isKindOfClass:[NSNull class]])
        self.activatedDate = [SFDateUtil SOQLDateTimeStringToDate:ActivatedDate];
    
    if (![RentStartDate isKindOfClass:[NSNull class]])
        self.rentStartDate = [SFDateUtil SOQLDateTimeStringToDate:RentStartDate];
    
    if (![ContractStartDate isKindOfClass:[NSNull class]])
        self.contractStartDate = [SFDateUtil SOQLDateTimeStringToDate:ContractStartDate];
    
    if (![ContractExpiryDate isKindOfClass:[NSNull class]])
        self.contractExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:ContractExpiryDate];
    
    self.totalRentPrice = [HelperClass numberCheckNull:TotalRentPrice];
    self.contractDurationYear = [HelperClass numberCheckNull:ContractDurationYear];
    
    self.isBCContract = IsBCContract;
    
    return self;
}

@end
