//
//  InventoryUnit.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "InventoryUnit.h"
#import "HelperClass.h"
#import "Product.h"

@implementation InventoryUnit

- (id)initInventoryUnit:(NSDictionary *)inventoryUnitDict {
    if (!(self = [super init]))
        return nil;
    
    if ([inventoryUnitDict isKindOfClass:[NSNull class]] || inventoryUnitDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[inventoryUnitDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[inventoryUnitDict objectForKey:@"Name"]];
    
    self.productType = [[Product alloc] initProduct:[inventoryUnitDict objectForKey:@"Product_Type__r"]];
    
    return self;
}

@end
