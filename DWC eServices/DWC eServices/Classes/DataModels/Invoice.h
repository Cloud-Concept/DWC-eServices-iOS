//
//  Invoice.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/24/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invoice : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *amount;

- (id)initInvoice:(NSDictionary *)invoiceDict;

@end
