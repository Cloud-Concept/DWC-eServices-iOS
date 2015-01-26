//
//  CardManagement.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "CardManagement.h"

@implementation CardManagement

- (id)initCardManagement:(NSString*)CardId CardExpiryDate:(NSString*)CardExpiryDate CardNumber:(NSString*)CardNumber CardType:(NSString*)CardType CompanyName:(NSString*)CompanyName Duration:(NSString*)Duration FullName:(NSString*)FullName Name:(NSString*)Name Nationality:(Country*)Nationality Recordtype:(RecordType*)Recordtype Status:(NSString*)Status {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = CardId;
    self.cardExpiryDate = CardExpiryDate;
    self.cardNumber = CardNumber;
    self.cardType = CardType;
    self.companyName = CompanyName;
    self.duration = Duration;
    self.fullName = FullName;
    self.name = Name;
    self.nationality = Nationality;
    self.recordType = Recordtype;
    self.status = Status;
    
    return self;
}

@end
