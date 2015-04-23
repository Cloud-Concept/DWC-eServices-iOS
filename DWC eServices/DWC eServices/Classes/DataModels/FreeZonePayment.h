//
//  FreeZonePayment.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FreeZonePaymentTypeNA,
    FreeZonePaymentTypeCredit,
    FreeZonePaymentTypeDebit,
} FreeZonePaymentType;

@interface FreeZonePayment : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *paymentType;
@property (strong, nonatomic) NSString *narrative;
@property (strong, nonatomic) NSString *effectOnAccount;

@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *transactionDate;

@property (strong, nonatomic) NSNumber *paypalAmount;
@property (strong, nonatomic) NSNumber *debitAmount;
@property (strong, nonatomic) NSNumber *creditAmount;
@property (strong, nonatomic) NSNumber *closingBalance;

@property (assign, nonatomic) FreeZonePaymentType freeZonePaymentType;

- (id)initFreeZonePayment:(NSDictionary *)freeZonePaymentDict;

@end
