//
//  DWCContactInfo.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWCContactInfo : NSObject

@property (nonatomic, weak) NSString *accountNumber;
@property (nonatomic, weak) NSString *bankAccountName;
@property (nonatomic, weak) NSString *bankName;
@property (nonatomic, weak) NSString *iBANNumber;
@property (nonatomic, weak) NSString *poBox;
@property (nonatomic, weak) NSString *swiftCode;

- (id)initDWCContactInfo:(NSDictionary *)infoDict;

@end
