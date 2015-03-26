//
//  ContractLineItem.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InventoryUnit;

@interface ContractLineItem : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) InventoryUnit *inventoryUnit;

- (id)initContractLineItem:(NSDictionary *)contractLineItemDict;

@end
