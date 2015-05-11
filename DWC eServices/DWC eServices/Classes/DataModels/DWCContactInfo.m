//
//  DWCContactInfo.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DWCContactInfo.h"
#import "HelperClass.h"

@implementation DWCContactInfo

- (id)initDWCContactInfo:(NSDictionary *)infoDict {
    if (!(self = [super init]))
        return nil;
    
    if ([infoDict isKindOfClass:[NSNull class]] || infoDict == nil)
        return nil;
    
    self.accountNumber = [HelperClass stringCheckNull:[infoDict objectForKey:@"Account_Number__c"]];
    self.bankAccountName = [HelperClass stringCheckNull:[infoDict objectForKey:@"Bank_Account_Name__c"]];
    self.bankName = [HelperClass stringCheckNull:[infoDict objectForKey:@"Bank_Name__c"]];
    self.iBANNumber = [HelperClass stringCheckNull:[infoDict objectForKey:@"Branch__c"]];
    self.poBox = [HelperClass stringCheckNull:[infoDict objectForKey:@"P_O_Box__c"]];
    self.swiftCode = [HelperClass stringCheckNull:[infoDict objectForKey:@"City_Country__c"]];
    
    return self;
}

@end
