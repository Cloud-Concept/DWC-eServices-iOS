//
//  RecordType.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "RecordType.h"
#import "HelperClass.h"

@implementation RecordType

- (id)initRecordType:(NSDictionary *)recordTypeDict {
    if (!(self = [super init]))
        return nil;
    
    if ([recordTypeDict isKindOfClass:[NSNull class]] || recordTypeDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[recordTypeDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[recordTypeDict objectForKey:@"Name"]];
    self.developerName = [HelperClass stringCheckNull:[recordTypeDict objectForKey:@"DeveloperName"]];
    self.isActive = [[HelperClass stringCheckNull:[recordTypeDict objectForKey:@"IsActive"]] boolValue];
    self.objectType = [HelperClass stringCheckNull:[recordTypeDict objectForKey:@"SobjectType"]];
    
    return self;
}

- (id)initRecordType:(NSString*)RecordTypeId Name:(NSString*)Name DeveloperName:(NSString*)DeveloperName IsActive:(BOOL)IsActive ObjectType:(NSString*)ObjectType {
    if (!(self = [super init]))
        return nil;
    
    self.Id = RecordTypeId;
    self.name = Name;
    self.developerName = DeveloperName;
    self.isActive = IsActive;
    self.objectType = ObjectType;
    
    return self;
}
@end
