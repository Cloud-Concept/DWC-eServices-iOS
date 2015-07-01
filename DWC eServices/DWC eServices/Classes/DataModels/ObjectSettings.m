//
//  ObjectSettings.m
//  iDWC
//
//  Created by Mina Zaklama on 6/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ObjectSettings.h"
#import "HelperClass.h"

@implementation ObjectSettings

- (id)initObjectSettings:(NSDictionary *)objectSettingsDict {
    if (!(self = [super init]))
        return nil;
    
    if ([objectSettingsDict isKindOfClass:[NSNull class]] || objectSettingsDict == nil)
        return nil;
    
    self.defaultValue = [HelperClass stringCheckNull:[objectSettingsDict objectForKey:@"Default_Value__c"]];
    self.fieldAPIName = [HelperClass stringCheckNull:[objectSettingsDict objectForKey:@"Field_API_Name__c"]];
    self.objectAPIName = [HelperClass stringCheckNull:[objectSettingsDict objectForKey:@"Object_API_Name__c"]];
    self.relatedTo = [HelperClass stringCheckNull:[objectSettingsDict objectForKey:@"Related_To__c"]];
    
    self.availability = [[objectSettingsDict objectForKey:@"Availability__c"] boolValue];;
    self.editable = [[objectSettingsDict objectForKey:@"Editable__c"] boolValue];;
    self.isActive = [[objectSettingsDict objectForKey:@"Is_Active__c"] boolValue];;
    self.useDefaults = [[objectSettingsDict objectForKey:@"Use_Defaults__c"] boolValue];;
    
    return self;
}
@end
