//
//  NSDate+CreateSpecificDate.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CreateSpecificDate)

+ (NSDate *)createNSDateFromDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)addDays:(NSInteger)addDays toDate:(NSDate *)date;
+ (NSDate *)addMonths:(NSInteger)addMonths toDate:(NSDate *)date;
+ (NSDate *)addYears:(NSInteger)addYears toDate:(NSDate *)date;
+ (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days months:(NSInteger)months years:(NSInteger)years hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
@end
