//
//  FormFieldValidation.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/12/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FormFieldValidationComparisonEqual,
    FormFieldValidationComparisonNotEqual,
    FormFieldValidationComparisonGreaterThan,
    FormFieldValidationComparisonGreaterThanOrEqual,
    FormFieldValidationComparisonSmallerThan,
    FormFieldValidationComparisonSmallerThanOrEqual,
    FormFieldValidationComparisonRegex,
    FormFieldValidationComparisonContains,
    FormFieldValidationComparisonStartsWith,
    FormFieldValidationComparisonEndsWith,
    FormFieldValidationComparisonIn,
    FormFieldValidationComparisonNotIn,
} FormFieldValidationComparisonType;

@interface FormFieldValidation : NSObject

@property (assign, nonatomic) FormFieldValidationComparisonType comparisonType;

@property (strong, nonatomic) NSString *compareToValue;
@property (strong, nonatomic) NSArray *compareValuesArray;

@property (strong, nonatomic) NSString *errorMessage;

- (id)initFormFieldValidationWithValue:(NSString *)value compareType:(FormFieldValidationComparisonType)compareType errorMessage:(NSString *)userErrorMessage;
- (id)initFormFieldValidationWithArray:(NSArray *)array compareType:(FormFieldValidationComparisonType)compareType errorMessage:(NSString *)userErrorMessage;

- (BOOL)compare:(NSString *)compareValue;

@end
