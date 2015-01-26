//
//  EServiceDocument.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "EServiceDocument.h"

@implementation EServiceDocument

- (id)initEServiceDocument:(NSString*)ServiceId Name:(NSString*)Name Type:(NSString*)Type Language:(NSString*)Language DocumentType:(NSString*)DocumentType {
    if (!(self = [super init]))
        return nil;
    
    self.Id = ServiceId;
    self.name = Name;
    
    if(![Type isKindOfClass:[NSNull class]])
        self.type = Type;
    
    if(![Language isKindOfClass:[NSNull class]])
        self.language = Language;
    
    if(![DocumentType isKindOfClass:[NSNull class]])
        self.documentType = DocumentType;
    
    return self;
}

@end
