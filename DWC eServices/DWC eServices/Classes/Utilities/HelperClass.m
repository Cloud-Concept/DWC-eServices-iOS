//
//  HelperClass.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "HelperClass.h"
#import "SFAuthenticationManager.h"
#import "NSDate+CreateSpecificDate.h"

@implementation HelperClass

+ (NSDate*)dateTimeFromString:(NSString*)dateStringValue {
    dateStringValue = [HelperClass stringCheckNull:dateStringValue];
    
    if ([dateStringValue isEqualToString:@""]) {
        return [NSDate date];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateStringValue = [dateStringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateStringValue = [dateStringValue substringToIndex:[dateStringValue rangeOfString:@"."].location];
    
    return [format dateFromString:dateStringValue];
}

+ (NSString*)stringCheckNull:(NSString*)stringValue {
    if(![stringValue isKindOfClass:[NSNull class]] && stringValue)
        return stringValue;
    else
        return @"";
}

+ (NSNumber*)numberCheckNull:(NSNumber*)numberValue {
    if(![numberValue isKindOfClass:[NSNull class]] && numberValue)
        return numberValue;
    else
        return [NSNumber numberWithInt:0];
}

+ (NSString*)formatDateToString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSLog(@"%@", dateStr);
    
    return dateStr;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSString*)formatNumberToString:(NSNumber*)number FormatStyle:(NSNumberFormatterStyle)numberFormatStyle MaximumFractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:numberFormatStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:fractionDigits]; // to avoid any decimal
    
    return [fmt stringFromNumber:number];
}

+ (void)displayAlertDialogWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"")
                                          otherButtonTitles: nil];
    
    [alert show];
}

+ (NSString*)getRelationshipValue:(NSDictionary*)dictionary Key:(NSString*)key {
    if ([key containsString:@"."]) {
        //NSArray *keyValue = [key componentsSeparatedByString:@"."];
        //NSDictionary *newDictionary = [dictionary objectForKey:[keyValue objectAtIndex:0]];
        //NSString *newKey = [keyValue objectAtIndex:1];
        
        NSRange range = [key rangeOfString:@"."];
        NSDictionary *newDictionary = [dictionary objectForKey:[key substringToIndex:range.location]];
        NSString *newKey = [key substringFromIndex:range.location + 1];
        
        return [HelperClass getRelationshipValue:newDictionary Key:newKey];
    }
    else {
        if ([dictionary isKindOfClass:[NSNull class]])
            return @"";
        else
            return [NSString stringWithFormat:@"%@", [HelperClass stringCheckNull:[dictionary objectForKey:key]]];
    }
    
}

+ (NSString *)formatBoolToString:(BOOL)booleanValue {
    NSString *localizedStringName = booleanValue ? @"yes" : @"no";
    
    return NSLocalizedString(localizedStringName, @"");
}

+ (void)showLogoutConfirmationDialog:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"LogoutAlertTitle", @"")
                                                                   message:NSLocalizedString(@"LogoutAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[SFAuthenticationManager sharedManager] logout];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)setRequestIconForImageView:(UIImageView *)imageView requestType:(NSString *)requestType {
    NSString *iconName = nil;
    
    if ([requestType isEqualToString:@"NOC Services"])
        iconName = @"Notification NOC Icon";
    else if ([requestType isEqualToString:@"Visa Services"])
        iconName = @"Notification Visa Icon";
    else if ([requestType isEqualToString:@"Access Card Services"])
        iconName = @"Notification Card Icon";
    
    imageView.image = [UIImage imageNamed:iconName];
}

+ (void)formatDatesForFilterOperation:(NSString *)operation startDate:(NSDate **)startDate endDate:(NSDate **)endDate {
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* calendarComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                               fromDate:currentDate];
    
    NSDate *quarterStartDate;
    
    NSInteger currentMonth = [calendarComponents month];
    NSInteger currentYear = [calendarComponents year];
    
    if (currentMonth >= 1 && currentMonth <= 3)
        quarterStartDate = [NSDate createNSDateFromDay:1 month:1 year:currentYear hour:0 minute:0 second:0];
    else if (currentMonth >= 4 && currentMonth <= 6)
        quarterStartDate = [NSDate createNSDateFromDay:1 month:4 year:currentYear hour:0 minute:0 second:0];
    else if (currentMonth >= 7 && currentMonth <= 9)
        quarterStartDate = [NSDate createNSDateFromDay:1 month:7 year:currentYear hour:0 minute:0 second:0];
    else if (currentMonth >= 10 && currentMonth <= 12)
        quarterStartDate = [NSDate createNSDateFromDay:1 month:10 year:currentYear hour:0 minute:0 second:0];
    
    if ([operation isEqualToString:@"Current Quarter"]) {
        *startDate = quarterStartDate;
        *endDate = [NSDate addMonths:3 toDate:quarterStartDate];
    }
    else if ([operation isEqualToString:@"Last Quarter"]) {
        *startDate = [NSDate addMonths:-3 toDate:quarterStartDate];
        *endDate = quarterStartDate;
    }
    else if ([operation isEqualToString:@"Current Year"]) {
        *startDate = [NSDate createNSDateFromDay:1 month:1 year:currentYear hour:0 minute:0 second:0];
        *endDate = [NSDate addYears:1 toDate:*startDate];
    }
    else if ([operation isEqualToString:@"Last Year"]) {
        *endDate = [NSDate createNSDateFromDay:1 month:1 year:currentYear hour:0 minute:0 second:0];
        *startDate = [NSDate addYears:-1 toDate:*endDate];
    }
}

@end
