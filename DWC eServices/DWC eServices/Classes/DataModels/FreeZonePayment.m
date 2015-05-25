//
//  FreeZonePayment.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "FreeZonePayment.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "Request.h"

@implementation FreeZonePayment

- (id)initFreeZonePayment:(NSDictionary *)freeZonePaymentDict {
    if (!(self = [super init]))
        return nil;
    
    if ([freeZonePaymentDict isKindOfClass:[NSNull class]] || freeZonePaymentDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[freeZonePaymentDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[freeZonePaymentDict objectForKey:@"Name"]];
    self.status = [HelperClass stringCheckNull:[freeZonePaymentDict objectForKey:@"Status__c"]];
    self.paymentType = [HelperClass stringCheckNull:[freeZonePaymentDict objectForKey:@"Payment_Type__c"]];
    self.narrative = [HelperClass stringCheckNull:[freeZonePaymentDict objectForKey:@"Narrative__c"]];
    self.effectOnAccount = [HelperClass stringCheckNull:[freeZonePaymentDict objectForKey:@"Effect_on_Account__c"]];
    
    self.paypalAmount = [HelperClass numberCheckNull:[freeZonePaymentDict objectForKey:@"Paypal_Amount__c"]];
    self.debitAmount = [HelperClass numberCheckNull:[freeZonePaymentDict objectForKey:@"Debit_Amount__c"]];
    self.creditAmount = [HelperClass numberCheckNull:[freeZonePaymentDict objectForKey:@"Credit_Amount__c"]];
    self.closingBalance = [HelperClass numberCheckNull:[freeZonePaymentDict objectForKey:@"Closing_Balance__C"]];
    
    if (![[freeZonePaymentDict objectForKey:@"CreatedDate"] isKindOfClass:[NSNull class]])
        self.createdDate = [SFDateUtil SOQLDateTimeStringToDate:[freeZonePaymentDict objectForKey:@"CreatedDate"]];
    
    if (![[freeZonePaymentDict objectForKey:@"Transaction_Date__c"] isKindOfClass:[NSNull class]])
        self.transactionDate = [SFDateUtil SOQLDateTimeStringToDate:[freeZonePaymentDict objectForKey:@"Transaction_Date__c"]];
    
    if ([self.effectOnAccount isEqualToString:@"Credit"])
        self.freeZonePaymentType = FreeZonePaymentTypeCredit;
    else if ([self.effectOnAccount isEqualToString:@"Debit"])
        self.freeZonePaymentType = FreeZonePaymentTypeDebit;
    else
        self.freeZonePaymentType = FreeZonePaymentTypeNA;
    
    self.request = [[Request alloc] initRequest:[freeZonePaymentDict objectForKey:@"Request__r"]];
    
    return self;
}

@end
