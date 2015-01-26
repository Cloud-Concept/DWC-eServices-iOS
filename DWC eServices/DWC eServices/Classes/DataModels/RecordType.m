//
//  RecordType.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "RecordType.h"

@implementation RecordType

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
