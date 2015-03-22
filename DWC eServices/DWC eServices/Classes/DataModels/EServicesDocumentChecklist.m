//
//  EServicesDocumentChecklist.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "EServicesDocumentChecklist.h"
#import "HelperClass.h"
#import "EServiceAdministration.h"

@implementation EServicesDocumentChecklist

- (id)initEServicesDocumentChecklist:(NSDictionary *)documentChecklistDict {
    if (!(self = [super init]))
        return nil;
    
    if ([documentChecklistDict isKindOfClass:[NSNull class]] || documentChecklistDict == nil)
        return nil;
    
    
    self.Id = [HelperClass stringCheckNull:[documentChecklistDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[documentChecklistDict objectForKey:@"Name"]];
    self.templateNameLink = [HelperClass stringCheckNull:[documentChecklistDict objectForKey:@"Template_Name_Link__c"]];
    self.availableForPreview = [[documentChecklistDict objectForKey:@"Available_for_Preview__c"] boolValue];
    self.originalCanBeRequested = [[documentChecklistDict objectForKey:@"Original_can_be_Requested__c"] boolValue];
    
    self.eServiceAdministration = [[EServiceAdministration alloc]
                                   initEServiceAdministration:[documentChecklistDict objectForKey:@"eService_Administration__r"]];
    
    return self;
}

@end
