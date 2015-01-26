//
//  RecordType.h
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordType : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *developerName;
@property (nonatomic) BOOL isActive;
@property (nonatomic, strong) NSString *objectType;

- (id)initRecordType:(NSString*)RecordTypeId Name:(NSString*)Name DeveloperName:(NSString*)DeveloperName IsActive:(BOOL)IsActive ObjectType:(NSString*)ObjectType;

@end
