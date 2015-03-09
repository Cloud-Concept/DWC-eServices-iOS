//
//  LegalRepresentative.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface LegalRepresentative : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *legalRepresentativeStartDate;
@property (nonatomic, strong) NSDate *legalRepresentativeEndDate;
@property (nonatomic, strong) Account *legalRepresentative;

- (id)initLegalRepresentative:(NSString *)legalId Role:(NSString *)Role Status:(NSString *)Status LegalRepresentativeStartDate:(NSString *)LegalRepresentativeStartDate LegalRepresentativeEndDate:(NSString *)LegalRepresentativeEndDate LegalRepresentative:(Account *)LegalRepresentative;

@end
