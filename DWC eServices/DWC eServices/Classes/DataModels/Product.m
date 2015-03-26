//
//  Product.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Product.h"
#import "HelperClass.h"

@implementation Product

- (id)initProduct:(NSDictionary *)productDict {
    if (!(self = [super init]))
        return nil;
    
    if ([productDict isKindOfClass:[NSNull class]] || productDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[productDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[productDict objectForKey:@"Name"]];
    
    return self;
}

@end
