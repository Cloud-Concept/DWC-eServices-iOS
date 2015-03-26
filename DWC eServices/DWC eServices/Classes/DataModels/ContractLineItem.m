//
//  ContractLineItem.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ContractLineItem.h"
#import "HelperClass.h"
#import "InventoryUnit.h"

@implementation ContractLineItem

- (id)initContractLineItem:(NSDictionary *)contractLineItemDict {
    if (!(self = [super init]))
        return nil;
    
    if ([contractLineItemDict isKindOfClass:[NSNull class]] || contractLineItemDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[contractLineItemDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[contractLineItemDict objectForKey:@"Name"]];
    
    self.inventoryUnit = [[InventoryUnit alloc] initInventoryUnit:[contractLineItemDict objectForKey:@"Inventory_Unit__r"]];
    
    return self;
}
@end
