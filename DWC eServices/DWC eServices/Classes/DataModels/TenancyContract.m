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
#import "Quote.h"
#import "ContractLineItem.h"
#import "TenancyContractPayment.h"

@implementation TenancyContract

- (id)initTenancyContract:(NSDictionary *)tenancyContractDict {
    if (!(self = [super init]))
        return nil;
    
    if ([tenancyContractDict isKindOfClass:[NSNull class]] || tenancyContractDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[tenancyContractDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[tenancyContractDict objectForKey:@"Name"]];
    self.contractType = [HelperClass stringCheckNull:[tenancyContractDict objectForKey:@"Contract_Type__c"]];
    self.status = [HelperClass stringCheckNull:[tenancyContractDict objectForKey:@"Status__c"]];
    self.contractDurationMonth = [HelperClass stringCheckNull:
                                  [tenancyContractDict objectForKey:@"Contract_Duration_Year_Month__c"]];
    self.contractNumber = [HelperClass stringCheckNull:[tenancyContractDict objectForKey:@"Contract_Number__c"]];
    
    if (![[tenancyContractDict objectForKey:@"Activated_Date__c"] isKindOfClass:[NSNull class]])
        self.activatedDate = [SFDateUtil SOQLDateTimeStringToDate:[tenancyContractDict objectForKey:@"Activated_Date__c"]];
    
    if (![[tenancyContractDict objectForKey:@"Rent_Start_Date__c"] isKindOfClass:[NSNull class]])
        self.rentStartDate = [SFDateUtil SOQLDateTimeStringToDate:[tenancyContractDict objectForKey:@"Rent_Start_Date__c"]];
    
    if (![[tenancyContractDict objectForKey:@"Contract_Start_Date__c"] isKindOfClass:[NSNull class]])
        self.contractStartDate = [SFDateUtil SOQLDateTimeStringToDate:
                                  [tenancyContractDict objectForKey:@"Contract_Start_Date__c"]];
    
    if (![[tenancyContractDict objectForKey:@"Contract_Expiry_Date__c"] isKindOfClass:[NSNull class]])
        self.contractExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:
                                   [tenancyContractDict objectForKey:@"Contract_Expiry_Date__c"]];
    
    self.totalRentPrice = [HelperClass numberCheckNull:[tenancyContractDict objectForKey:@"Total_Rent_Price__c"]];
    self.contractDurationYear = [HelperClass numberCheckNull:[tenancyContractDict objectForKey:@"Contract_Duration__c"]];
    
    self.isBCContract = [[tenancyContractDict objectForKey:@"IS_BC_Contract__c"] boolValue];
    
    self.quote = [[Quote alloc] initQuote:[tenancyContractDict objectForKey:@"Quote__r"]];
    
    self.contractLineItems = [NSArray new];
    if (![[tenancyContractDict objectForKey:@"Contract_Line_Items__r"] isKindOfClass:[NSNull class]]) {
        NSMutableArray *contractLineItemsMutableArray = [NSMutableArray new];
        for (NSDictionary *contractLineItemDict in [[tenancyContractDict objectForKey:@"Contract_Line_Items__r"] objectForKey:@"records"]) {
            [contractLineItemsMutableArray addObject:[[ContractLineItem alloc] initContractLineItem:contractLineItemDict]];
        }
        self.contractLineItems = [NSArray arrayWithArray:contractLineItemsMutableArray];
    }
    
    self.tenancyContractPayments = [NSArray new];
    if (![[tenancyContractDict objectForKey:@"Tenancy_Contract_Payments__r"] isKindOfClass:[NSNull class]]) {
        NSMutableArray *contractPaymentsMutableArray = [NSMutableArray new];
        for (NSDictionary *contractPaymentDict in [[tenancyContractDict objectForKey:@"Tenancy_Contract_Payments__r"] objectForKey:@"records"]) {
            [contractPaymentsMutableArray addObject:[[TenancyContractPayment alloc] initTenancyContractPayment:contractPaymentDict]];
        }
        self.tenancyContractPayments = [NSArray arrayWithArray:contractPaymentsMutableArray];
    }
    
    return self;
}

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
