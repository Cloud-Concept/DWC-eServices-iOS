//
//  RelatedService.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RelatedService.h"

@implementation RelatedService

- (id)initRelatedService:(NSString*)ServiceName Label:(NSString*)ServiceLabel Icon:(NSString*)ServiceIconName Mask:(NSUInteger)ServiceMask {
    if (!(self = [super init]))
        return nil;
    
    self.Name = ServiceName;
    self.Label = ServiceLabel;
    self.IconName = ServiceIconName;
    self.Mask = ServiceMask;
    
    return self;
}

@end
