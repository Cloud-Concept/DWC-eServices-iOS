//
//  CardManagement.h
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Country;
@class RecordType;

@interface CardManagement : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *cardExpiryDate;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Country *nationality;
@property (nonatomic, strong) RecordType *recordType;
@property (nonatomic, strong) NSString *status;

- (id)initCardManagement:(NSString*)CardId CardExpiryDate:(NSString*)CardExpiryDate CardNumber:(NSString*)CardNumber CardType:(NSString*)CardType CompanyName:(NSString*)CompanyName Duration:(NSString*)Duration FullName:(NSString*)FullName Name:(NSString*)Name Nationality:(Country*)Nationality Recordtype:(RecordType*)Recordtype Status:(NSString*)Status;

@end
