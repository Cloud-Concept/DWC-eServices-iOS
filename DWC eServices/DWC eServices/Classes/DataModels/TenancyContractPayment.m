//
//  TenancyContractPayment.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/6/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "TenancyContractPayment.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation TenancyContractPayment

- (id)initTenancyContractPayment:(NSDictionary *)contractPaymentDict {
    if (!(self = [super init]))
        return nil;
    
    if ([contractPaymentDict isKindOfClass:[NSNull class]] || contractPaymentDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[contractPaymentDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[contractPaymentDict objectForKey:@"Name"]];
    self.descriptionPayment = [HelperClass stringCheckNull:[contractPaymentDict objectForKey:@"Description__c"]];
    self.paymentAmount = [HelperClass numberCheckNull:[contractPaymentDict objectForKey:@"Payment_Amount__c"]];
    
    if (![[contractPaymentDict objectForKey:@"Due_Date__c"] isKindOfClass:[NSNull class]])
        self.dueDate = [SFDateUtil SOQLDateTimeStringToDate:[contractPaymentDict objectForKey:@"Due_Date__c"]];
    
    if (![[contractPaymentDict objectForKey:@"Due_Date_To__c"] isKindOfClass:[NSNull class]])
        self.dueDateTo = [SFDateUtil SOQLDateTimeStringToDate:[contractPaymentDict objectForKey:@"Due_Date_To__c"]];
    
    return self;
}

@end
