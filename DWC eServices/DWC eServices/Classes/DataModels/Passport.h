//
//  Passport.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Passport : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *passportNumber;
@property (nonatomic, strong) NSString *passportType;
@property (nonatomic, strong) NSString *passportPlaceOfIssue;

@property (nonatomic, strong) NSDate *passportIssueDate;
@property (nonatomic, strong) NSDate *passportExpiryDate;

- (id)initPassport:(NSDictionary *)passportDict;
/*
- (id)initPassport:(NSString *)PassportId PassportNumber:(NSString *)PassportNumber PassportType:(NSString *)PassportType PassportPlaceOfIssue:(NSString *)PassportPlaceOfIssue PassportIssueDate:(NSString *)PassportIssueDate PassportExpiryDate:(NSString *)PassportExpiryDate;
*/
@end
