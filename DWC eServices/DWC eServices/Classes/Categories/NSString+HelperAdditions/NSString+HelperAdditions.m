//
//  NSString+HelperAdditions.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NSString+HelperAdditions.h"

@implementation NSString (HelperAdditions)

- (BOOL)isValidEmail {
    
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self
                                                     options:0
                                                       range:NSMakeRange(0, [self length])];
    return (regExMatches == 0) ? NO : YES ;
    
}

@end
