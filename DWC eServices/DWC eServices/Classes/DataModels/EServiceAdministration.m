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

- (id)initEServiceAdministration:(NSString*)ServiceId Name:(NSString*)Name ServiceIdentifier:(NSString*)ServiceIdentifier Amount:(NSNumber*)Amount RelatedToObject:(NSString*)RelatedToObject VisualForceGenerator:(NSString*)VisualForceGenerator ServiceDocumentsArray:(NSArray*)ServiceDocumentsArray {
    
    if(!(self = [super init]))
        return nil;
    
    self.Id = ServiceId;
    self.name = Name;
    self.serviceIdentifier = [HelperClass stringCheckNull:ServiceIdentifier];
    self.amount = [HelperClass numberCheckNull:Amount];
    self.relatedToObject = [HelperClass stringCheckNull:RelatedToObject];
    self.visualForceGenerator = [HelperClass stringCheckNull:VisualForceGenerator];
    
    NSMutableArray *documentsMutableArray = [NSMutableArray new];
    for (NSDictionary *obj in ServiceDocumentsArray) {
        EServiceDocument *newDocument = [[EServiceDocument alloc] initEServiceDocument:[obj objectForKey:@"Id"]
                                                                                  Name:[obj objectForKey:@"Name"]
                                                                                  Type:[obj objectForKey:@"Type__c"]
                                                                              Language:[obj objectForKey:@"Language__c"]
                                                                          DocumentType:[obj objectForKey:@"Document_Type__c"]];
        [documentsMutableArray addObject:newDocument];
    }
    
    self.serviceDocumentsArray = [NSArray arrayWithArray:documentsMutableArray];
    
    return self;
}

@end
