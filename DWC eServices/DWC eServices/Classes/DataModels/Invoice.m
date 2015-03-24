//
//  Invoice.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/24/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Invoice.h"
#import "HelperClass.h"

@implementation Invoice

- (id)initInvoice:(NSDictionary *)invoiceDict {
    if (!(self = [super init]))
        return nil;
    
    if ([invoiceDict isKindOfClass:[NSNull class]] || invoiceDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[invoiceDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[invoiceDict objectForKey:@"Name"]];
    self.status = [HelperClass stringCheckNull:[invoiceDict objectForKey:@"Status__c"]];
    self.amount = [HelperClass numberCheckNull:[invoiceDict objectForKey:@"Amount__c"]];
    
    return self;
}

@end
