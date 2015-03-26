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
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *relatedToObject;
@property (strong, nonatomic) NSString *editNewVFGenerator;
@property (strong, nonatomic) NSString *cancelVFGenerator;
@property (strong, nonatomic) NSString *renewVFGenerator;
@property (strong, nonatomic) NSString *replaceVFGenerator;
@property (strong, nonatomic) NSString *recordTypePicklist;
@property (strong, nonatomic) NSArray *serviceDocumentsArray;
@property (strong, nonatomic) NSOrderedSet *authoritiesOrderedSet;
@property (strong, nonatomic) NSDictionary *authorityLanguagesDictionary;
@property (strong, nonatomic) EServiceAdministration *knowledgeFeeService;

@property (nonatomic) BOOL requireKnowledgeFee;

- (id)initEServiceAdministration:(NSDictionary *)eServiceAdministrationDict;
/*
- (id)initEServiceAdministration:(NSString*)ServiceId Name:(NSString*)Name ServiceIdentifier:(NSString*)ServiceIdentifier Amount:(NSNumber*)Amount RelatedToObject:(NSString*)RelatedToObject NewEditVFGenerator:(NSString*)NewEditVFGenerator ServiceDocumentsArray:(NSArray*)ServiceDocumentsArray;

- (id)initEServiceAdministration:(NSString*)ServiceId Name:(NSString*)Name ServiceIdentifier:(NSString*)ServiceIdentifier Amount:(NSNumber*)Amount RelatedToObject:(NSString*)RelatedToObject NewEditVFGenerator:(NSString*)NewEditVFGenerator CancelVFGenerator:(NSString *)CancelVFGenerator RenewVFGenerator:(NSString *)RenewVFGenerator ReplaceVFGenerator:(NSString *) ReplaceVFGenerator RecordTypePicklist:(NSString *)RecordTypePicklist ServiceDocumentsArray:(NSArray*)ServiceDocumentsArray;
*/
- (BOOL)hasDocuments;

@end
