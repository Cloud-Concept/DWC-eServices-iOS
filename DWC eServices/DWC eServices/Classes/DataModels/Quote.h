//
//  Quote.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;

- (id)initQuote:(NSDictionary *)quoteDict;

@end
