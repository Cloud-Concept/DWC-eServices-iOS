//
//  Quote.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Quote.h"
#import "HelperClass.h"

@implementation Quote

- (id)initQuote:(NSDictionary *)quoteDict {
    if (!(self = [super init]))
        return nil;
    
    if ([quoteDict isKindOfClass:[NSNull class]] || quoteDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[quoteDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[quoteDict objectForKey:@"Name"]];
    
    return self;
}

@end
