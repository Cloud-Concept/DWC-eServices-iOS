//
//  FormFieldValidation.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/12/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "FormFieldValidation.h"

@implementation FormFieldValidation

- (id)initFormFieldValidationWithValue:(NSString *)value compareType:(FormFieldValidationComparisonType)compareType errorMessage:(NSString *)userErrorMessage {
    
    if (!(self = [super init]))
        return nil;
    
    self.compareToValue = value;
    self.comparisonType = compareType;
    self.errorMessage = userErrorMessage;
    
    return self;
}

- (id)initFormFieldValidationWithArray:(NSArray *)array compareType:(FormFieldValidationComparisonType)compareType errorMessage:(NSString *)userErrorMessage {
    if (!(self = [super init]))
        return nil;
    
    self.compareValuesArray = array;
    self.comparisonType = compareType;
    self.errorMessage = userErrorMessage;
    
    return self;
}

- (BOOL)compare:(NSString *)compareValue {
    BOOL comparisonReturn = NO;
    
    switch (self.comparisonType) {
        case FormFieldValidationComparisonEqual:
            // compareValue == self.compareToValue
            comparisonReturn = ([compareValue compare:self.compareToValue] == NSOrderedSame);
            break;
        case FormFieldValidationComparisonNotEqual:
            // compareValue != self.compareToValue
            comparisonReturn = ([compareValue compare:self.compareToValue] != NSOrderedSame);
            break;
        case FormFieldValidationComparisonGreaterThan:
            // compareValue > self.compareToValue
            comparisonReturn = ([compareValue compare:self.compareToValue] == NSOrderedDescending);
            break;
        case FormFieldValidationComparisonGreaterThanOrEqual:
            // NOT(compareValue < self.compareToValue)
            comparisonReturn = ([compareValue compare:self.compareToValue] != NSOrderedAscending);
            break;
        case FormFieldValidationComparisonSmallerThan:
            // compareValue < self.compareToValue
            comparisonReturn = ([compareValue compare:self.compareToValue] == NSOrderedAscending);
            break;
        case FormFieldValidationComparisonSmallerThanOrEqual:
            // NOT(compareValue > self.compareToValue)
            comparisonReturn = ([compareValue compare:self.compareToValue] != NSOrderedDescending);
            break;
        case FormFieldValidationComparisonRegex:
            
            break;
        case FormFieldValidationComparisonContains:
            comparisonReturn = [compareValue containsString:self.compareToValue];
            break;
        case FormFieldValidationComparisonStartsWith:
            comparisonReturn = [compareValue hasPrefix:self.compareToValue];
            break;
        case FormFieldValidationComparisonEndsWith:
            comparisonReturn = [compareValue hasSuffix:self.compareToValue];
            break;
        case FormFieldValidationComparisonIn:
            comparisonReturn = [self isValueInValuesArray:compareValue];
            break;
        case FormFieldValidationComparisonNotIn:
            comparisonReturn = ![self isValueInValuesArray:compareValue];
            break;
        default:
            
            break;
    }
    
    return comparisonReturn;
}

- (BOOL)isValueInValuesArray:(NSString *)value {
    
    for (NSString *comparingToValue in self.compareValuesArray) {
        if ([value isEqualToString:comparingToValue])
            return YES;
    }
    
    return NO;
}

@end
