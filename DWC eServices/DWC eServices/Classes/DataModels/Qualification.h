//
//  Qualification.h
//  iDWC
//
//  Created by Mina Zaklama on 6/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Qualification : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eDNRDCode;
@property (nonatomic, strong) NSString *eFormCode;
@property (nonatomic, strong) NSString *qualificationNameArabic;

@property (nonatomic) BOOL isActive;

- (id)initQualification:(NSDictionary *)qualificationDict;

@end
