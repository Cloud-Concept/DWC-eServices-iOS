//
//  ObjectSettings.h
//  iDWC
//
//  Created by Mina Zaklama on 6/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectSettings : NSObject

@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) NSString *fieldAPIName;
@property (nonatomic, strong) NSString *objectAPIName;
@property (nonatomic, strong) NSString *relatedTo;

@property (nonatomic) BOOL availability;
@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL useDefaults;

- (id)initObjectSettings:(NSDictionary *)objectSettingsDict;

@end
