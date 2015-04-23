//
//  NSDate+CreateSpecificDate.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NSDate+CreateSpecificDate.h"

@implementation NSDate (CreateSpecificDate)

+ (NSDate *)createNSDateFromDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    [comps setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [gregorianCalendar dateFromComponents:comps];
}

+ (NSDate *)addDays:(NSInteger)addDays toDate:(NSDate *)date {
    return [self addToDate:date days:addDays months:0 years:0 hour:0 minute:0 second:0];
}

+ (NSDate *)addMonths:(NSInteger)addMonths toDate:(NSDate *)date {
    return [self addToDate:date days:-1 months:addMonths years:0 hour:0 minute:0 second:0];
}

+ (NSDate *)addYears:(NSInteger)addYears toDate:(NSDate *)date {
    return [self addToDate:date days:0 months:0 years:addYears hour:0 minute:0 second:0];
}

+ (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days months:(NSInteger)months years:(NSInteger)years hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    [components setMonth:months];
    [components setYear:years];
    
    return [calendar dateByAddingComponents:components toDate:date options:0];
}

@end
