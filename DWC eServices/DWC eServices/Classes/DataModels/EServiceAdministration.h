//
//  EServiceAdministration.h
//  DWCTest
//
//  Created by Mina Zaklama on 12/9/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EServiceAdministration : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *serviceIdentifier;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *relatedToObject;
@property (strong, nonatomic) NSString *visualForceGenerator;
@property (strong, nonatomic) NSArray *serviceDocumentsArray;

- (id)initEServiceAdministration:(NSString*)ServiceId Name:(NSString*)Name ServiceIdentifier:(NSString*)ServiceIdentifier Amount:(NSNumber*)Amount RelatedToObject:(NSString*)RelatedToObject VisualForceGenerator:(NSString*)VisualForceGenerator ServiceDocumentsArray:(NSArray*)ServiceDocumentsArray;

@end
