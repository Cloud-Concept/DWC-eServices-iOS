//
//  TenancyContractPayment.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/6/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenancyContractPayment : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionPayment;
@property (nonatomic, strong) NSString *inventoryUnit;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSDate *dueDateTo;
@property (nonatomic, strong) NSNumber *paymentAmount;

- (id)initTenancyContractPayment:(NSDictionary *)contractPaymentDict;

@end
