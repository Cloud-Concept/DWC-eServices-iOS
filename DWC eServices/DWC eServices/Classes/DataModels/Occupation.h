//
//  Occupation.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Occupation : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *arabicName;
@property (nonatomic, strong) NSString *eDNRDName;
@property (nonatomic, strong) NSString *eFormCode;
@property (nonatomic) BOOL isActive;

- (id)initOccupation:(NSString*)OccupationId OccupationName:(NSString*)OccupationName ArabicName:(NSString*)ArabicName DNRDName:(NSString*)DNRDName FormCode:(NSString*)FormCode IsActive:(BOOL)IsActive;

@end
