//
//  Directorship.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface Directorship : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *roles;
@property (nonatomic, strong) NSString *directorStatus;
@property (nonatomic, strong) NSDate *directorshipStartDate;
@property (nonatomic, strong) NSDate *directorshipEndDate;
@property (nonatomic, strong) Account *director;

- (id)initDirectorship:(NSDictionary *)directorshipDict;
/*
- (id)initDirectorship:(NSString *)DirectorId Roles:(NSString *)Roles DirectorStatus:(NSString *)DirectorStatus DirectorshipStartDate:(NSString *)DirectorshipStartDate DirectorshipEndDate:(NSString *)DirectorshipEndDate Director:(Account *)Director;
*/
@end
