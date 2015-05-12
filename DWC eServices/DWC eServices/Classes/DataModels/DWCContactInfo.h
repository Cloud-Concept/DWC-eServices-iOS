//
//  DWCContactInfo.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWCContactInfo : NSObject

@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *bankAccountName;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *iBANNumber;
@property (nonatomic, strong) NSString *poBox;
@property (nonatomic, strong) NSString *swiftCode;

- (id)initDWCContactInfo:(NSDictionary *)infoDict;

@end
