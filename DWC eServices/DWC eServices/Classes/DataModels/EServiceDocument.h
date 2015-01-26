//
//  EServiceDocument.h
//  DWCTest
//
//  Created by Mina Zaklama on 12/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EServiceDocument : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *documentType;
@property (strong, nonatomic) UIImage *attachment;

- (id)initEServiceDocument:(NSString*)ServiceId Name:(NSString*)Name Type:(NSString*)Type Language:(NSString*)Language DocumentType:(NSString*)DocumentType;

@end
