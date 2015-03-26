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

- (id)initEServiceAdministration:(NSDictionary *)eServiceAdministrationDict {
    if(!(self = [super init]))
        return nil;
    
    if ([eServiceAdministrationDict isKindOfClass:[NSNull class]] || eServiceAdministrationDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Name"]];
    self.displayName = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Display_Name__c"]];
    self.serviceIdentifier = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Service_Identifier__c"]];
    self.amount = [HelperClass numberCheckNull:[eServiceAdministrationDict objectForKey:@"Amount__c"]];
    self.relatedToObject = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Related_to_Object__c"]];
    self.editNewVFGenerator = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"New_Edit_VF_Generator__c"]];
    self.cancelVFGenerator = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Cancel_VF_Generator__c"]];
    self.renewVFGenerator = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Renewal_VF_Generator__c"]];
    self.replaceVFGenerator = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Replace_VF_Generator__c"]];
    self.recordTypePicklist = [HelperClass stringCheckNull:[eServiceAdministrationDict objectForKey:@"Record_Type_Picklist__c"]];
    self.requireKnowledgeFee = [[eServiceAdministrationDict objectForKey:@"Require_Knowledge_Fee__c"] boolValue];
    
    NSArray *serviceDocumentsArray = [NSArray new];
    NSMutableArray *documentsMutableArray = [NSMutableArray new];
    NSMutableOrderedSet *authoritiesMutableOrderedSet = [NSMutableOrderedSet new];
    NSMutableDictionary *authorityLanguagesMutableDictionary = [NSMutableDictionary new];
    if(![[eServiceAdministrationDict objectForKey:@"eServices_Document_Checklists__r"] isKindOfClass:[NSNull class]])
        serviceDocumentsArray = [[eServiceAdministrationDict
                                 objectForKey:@"eServices_Document_Checklists__r"] objectForKey:@"records"];
    
    for (NSDictionary *obj in serviceDocumentsArray) {
        NSString *currentDocumentType = [HelperClass stringCheckNull:[obj objectForKey:@"Document_Type__c"]];
        if ([currentDocumentType isEqualToString:@"Upload"]) {
            EServiceDocument *newDocument = [[EServiceDocument alloc] initEServiceDocument:obj];
            
            [documentsMutableArray addObject:newDocument];
        }
        else if ([currentDocumentType isEqualToString:@"Download"]) {
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
    
    self.knowledgeFeeService = [[EServiceAdministration alloc] initEServiceAdministration:[eServiceAdministrationDict objectForKey:@"Knowledge_Fee__r"]];
    
    return self;
}

- (id)initEServiceAdministration:(NSString*)ServiceId Name:(NSString*)Name ServiceIdentifier:(NSString*)ServiceIdentifier Amount:(NSNumber*)Amount RelatedToObject:(NSString*)RelatedToObject NewEditVFGenerator:(NSString*)NewEditVFGenerator ServiceDocumentsArray:(NSArray*)ServiceDocumentsArray {
    return [self initEServiceAdministration:ServiceId Name:Name ServiceIdentifier:ServiceIdentifier Amount:Amount RelatedToObject:RelatedToObject NewEditVFGenerator:NewEditVFGenerator CancelVFGenerator:@"" RenewVFGenerator:@"" ReplaceVFGenerator:@"" RecordTypePicklist:@"" ServiceDocumentsArray:ServiceDocumentsArray];
}


- (id)initEServiceAdministration:(NSString*)ServiceId Name:(NSString*)Name ServiceIdentifier:(NSString*)ServiceIdentifier Amount:(NSNumber*)Amount RelatedToObject:(NSString*)RelatedToObject NewEditVFGenerator:(NSString*)NewEditVFGenerator CancelVFGenerator:(NSString *)CancelVFGenerator RenewVFGenerator:(NSString *)RenewVFGenerator ReplaceVFGenerator:(NSString *) ReplaceVFGenerator RecordTypePicklist:(NSString *)RecordTypePicklist ServiceDocumentsArray:(NSArray*)ServiceDocumentsArray {
    
    if(!(self = [super init]))
        return nil;
    
    self.Id = ServiceId;
    self.name = Name;
    self.serviceIdentifier = [HelperClass stringCheckNull:ServiceIdentifier];
    self.amount = [HelperClass numberCheckNull:Amount];
    self.relatedToObject = [HelperClass stringCheckNull:RelatedToObject];
    self.editNewVFGenerator = [HelperClass stringCheckNull:NewEditVFGenerator];
    self.cancelVFGenerator = [HelperClass stringCheckNull:CancelVFGenerator];
    self.renewVFGenerator = [HelperClass stringCheckNull:RenewVFGenerator];
    self.replaceVFGenerator = [HelperClass stringCheckNull:ReplaceVFGenerator];
    self.recordTypePicklist = [HelperClass stringCheckNull:RecordTypePicklist];
    
    NSMutableArray *documentsMutableArray = [NSMutableArray new];
    NSMutableOrderedSet *authoritiesMutableOrderedSet = [NSMutableOrderedSet new];
    NSMutableDictionary *authorityLanguagesMutableDictionary = [NSMutableDictionary new];
    for (NSDictionary *obj in ServiceDocumentsArray) {
        NSString *currentDocumentType = [HelperClass stringCheckNull:[obj objectForKey:@"Document_Type__c"]];
        if ([currentDocumentType isEqualToString:@"Upload"]) {
            
            EServiceDocument *newDocument = [[EServiceDocument alloc] initEServiceDocument:obj];
            [documentsMutableArray addObject:newDocument];
        }
        else if ([currentDocumentType isEqualToString:@"Download"]) {
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
