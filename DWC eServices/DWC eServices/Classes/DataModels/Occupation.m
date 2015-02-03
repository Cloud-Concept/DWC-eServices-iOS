//
//  Occupation.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Occupation.h"
#import "HelperClass.h"

@implementation Occupation

- (id)initOccupation:(NSString*)OccupationId OccupationName:(NSString*)OccupationName ArabicName:(NSString*)ArabicName DNRDName:(NSString*)DNRDName FormCode:(NSString*)FormCode IsActive:(BOOL)IsActive {
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:OccupationId];
    self.name = [HelperClass stringCheckNull:OccupationName];
    self.arabicName = [HelperClass stringCheckNull:ArabicName];
    self.eDNRDName = [HelperClass stringCheckNull:DNRDName];
    self.eFormCode = [HelperClass stringCheckNull:FormCode];
    self.isActive = IsActive;
    
    return self;
}
@end
