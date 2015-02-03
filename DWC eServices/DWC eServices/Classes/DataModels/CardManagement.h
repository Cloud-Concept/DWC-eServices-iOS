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
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *personalPhoto;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *sponsor;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *salutation;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *designation;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *passportNumber;

@property (nonatomic, strong) NSDate *cardExpiryDate;
@property (nonatomic, strong) NSDate *cardIssueDate;

@property (nonatomic, strong) RecordType *recordType;
@property (nonatomic, strong) Country *nationality;

- (id)initCardManagement:(NSString*)Id Name:(NSString*)Name PersonalPhoto:(NSString*)PersonalPhoto CardNumber:(NSString*)CardNumber Status:(NSString*)Status Sponsor:(NSString*)Sponsor CardType:(NSString*)CardType Salutation:(NSString*)Salutation FullName:(NSString*)FullName Designation:(NSString*)Designation Duration:(NSString*)Duration CardExpiryDate:(NSString*)CardExpiryDate CardIssueDate:(NSString*)CardIssueDate PassportNumber:(NSString*)PassportNumber RecordType:(RecordType*)RecordType Nationality:(Country*)Nationality;

@end
