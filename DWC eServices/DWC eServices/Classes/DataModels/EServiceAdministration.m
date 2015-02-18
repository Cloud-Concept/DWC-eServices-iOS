//
//  EServiceAdministration.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/9/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "EServiceAdministration.h"
#import "HelperClass.h"
#import "EServiceDocument.h"

@implementation EServiceAdministration

- (id)initEServiceAdministration:(NSString*)ServiceId Name:(NSString*)Name ServiceIdentifier:(NSString*)ServiceIdentifier Amount:(NSNumber*)Amount RelatedToObject:(NSString*)RelatedToObject NewEditVFGenerator:(NSString*)NewEditVFGenerator ServiceDocumentsArray:(NSArray*)ServiceDocumentsArray {
    
    if(!(self = [super init]))
        return nil;
    
    self.Id = ServiceId;
    self.name = Name;
    self.serviceIdentifier = [HelperClass stringCheckNull:ServiceIdentifier];
    self.amount = [HelperClass numberCheckNull:Amount];
    self.relatedToObject = [HelperClass stringCheckNull:RelatedToObject];
    self.editNewVFGenerator = [HelperClass stringCheckNull:NewEditVFGenerator];
    
    NSMutableArray *documentsMutableArray = [NSMutableArray new];
    NSMutableOrderedSet *authoritiesMutableOrderedSet = [NSMutableOrderedSet new];
    NSMutableDictionary *authorityLanguagesMutableDictionary = [NSMutableDictionary new];
    for (NSDictionary *obj in ServiceDocumentsArray) {
        if ([[obj objectForKey:@"Document_Type__c"] isEqualToString:@"Upload"]) {
            
            EServiceDocument *newDocument = [[EServiceDocument alloc] initEServiceDocument:[obj objectForKey:@"Id"]
                                                                                      Name:[obj objectForKey:@"Name"]
                                                                                      Type:[obj objectForKey:@"Type__c"]
                                                                                  Language:[obj objectForKey:@"Language__c"]
                                                                                 Authority:[obj objectForKey:@"Authority__c"]
                                                                              DocumentType:[obj objectForKey:@"Document_Type__c"]];
            [documentsMutableArray addObject:newDocument];
        }
        else {
            NSString *authority = [obj objectForKey:@"Authority__c"];
            [authoritiesMutableOrderedSet addObject:authority];
            
            NSMutableOrderedSet *languagesMutableOrderedSet;
            if ([authorityLanguagesMutableDictionary valueForKey:authority]) {
                languagesMutableOrderedSet = [authorityLanguagesMutableDictionary valueForKey:authority];
            }
            else {
                languagesMutableOrderedSet = [NSMutableOrderedSet new];
            }
            [languagesMutableOrderedSet addObject:[obj objectForKey:@"Language__c"]];
            [authorityLanguagesMutableDictionary setValue:languagesMutableOrderedSet forKey:authority];
        }
    }
    
    self.serviceDocumentsArray = [NSArray arrayWithArray:documentsMutableArray];
    self.authoritiesOrderedSet = [NSOrderedSet orderedSetWithOrderedSet:authoritiesMutableOrderedSet];
    self.authorityLanguagesDictionary = [NSDictionary dictionaryWithDictionary:authorityLanguagesMutableDictionary];
    
    return self;
}

- (BOOL)hasDocuments {
    return self.serviceDocumentsArray.count > 0;
}
@end
