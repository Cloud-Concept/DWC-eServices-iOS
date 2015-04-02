//
//  FormField.h
//  DWCTest
//
//  Created by Mina Zaklama on 12/8/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFPickListViewController.h"
#import "DatePickerViewController.h"
#import "PickerTableViewController.h"

@interface FormField : NSObject <UIPopoverControllerDelegate, NSCopying>
{
    NSString *formFieldValue;
    UIView *fieldView;
    UILabel *labelView;
    UIPopoverController *popoverController;
    
    UILabel *reviewFieldValueLabel;
    UILabel *reviewFieldNameLabel;
    
    NSIndexPath *selectedPicklistIndexPath;
    
    NSMutableArray *childrenPicklistFormFieldsArray;
}

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL apiRequired;
@property (nonatomic) BOOL booleanValue;
@property (strong, nonatomic) NSNumber *currencyValue;
@property (strong, nonatomic) NSDate *dateTimeValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (strong, nonatomic) NSString *emailValue;
@property (nonatomic) BOOL hidden;
@property (nonatomic) BOOL isCalculated;
@property (nonatomic) BOOL isParameter;
@property (nonatomic) BOOL isQuery;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSNumber *numberValue;
@property (strong, nonatomic) NSNumber *order;
@property (strong, nonatomic) NSNumber *percentValue;
@property (strong, nonatomic) NSString *phoneValue;
@property (strong, nonatomic) NSString *picklistValue;
@property (strong, nonatomic) NSString *picklistEntries;
@property (nonatomic) BOOL required;
@property (strong, nonatomic) NSString *textAreaLongValue;
@property (strong, nonatomic) NSString *textAreaValue;
@property (strong, nonatomic) NSString *textValue;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *urlValue;
@property (strong, nonatomic) NSString *webForm;
@property (strong, nonatomic) NSNumber *width;
@property (nonatomic) BOOL isMobileAvailable;
@property (strong, nonatomic) NSString *mobileLabel;
@property (strong, nonatomic) NSNumber *mobileOrder;
@property (strong, nonatomic) NSString *nameNoSpace;
@property (strong, nonatomic) NSString *controllingField;
@property (nonatomic) BOOL isDependentPicklist;

@property (strong, nonatomic) NSDictionary *picklistValuesDictionary;
@property (strong, nonatomic) FormField *controllingFormField;

- (id)initFormField:(NSString *)formFieldId Name:(NSString *)Name Type:(NSString*)Type MobileLabel:(NSString *)MobileLabel FieldValue:(NSString*)FieldValue;
- (id)initFormField:(NSString *)formFieldId Name:(NSString *)Name Type:(NSString*)Type MobileLabel:(NSString *)MobileLabel FieldValue:(NSString*)FieldValue IsParameter:(BOOL)IsParameter;
/*
- (id)initFormField:(NSString*)formFieldId Name:(NSString*)Name APIRequired:(BOOL)APIRequired BooleanValue:(BOOL)BooleanValue CurrencyValue:(NSNumber*)CurrencyValue DateTimeValue:(NSString*)DateTimeValue DateValue:(NSString*)DateValue EmailValue:(NSString*)EmailValue Hidden:(BOOL)Hidden IsCalculated:(BOOL)IsCalculated IsParameter:(BOOL)IsParameter IsQuery:(BOOL)IsQuery Label:(NSString*)Label NumberValue:(NSNumber*)NumberValue Order:(NSNumber*)Order PercentValue:(NSNumber*)PercentValue PhoneValue:(NSString*)PhoneValue PicklistValue:(NSString*)PicklistValue PicklistEntries:(NSString*)PicklistEntries Required:(BOOL)Required TextAreaLongValue:(NSString*)TextAreaLongValue TextAreaValue:(NSString*)TextAreaValue TextValue:(NSString*)TextValue Type:(NSString*)Type UrlValue:(NSString*)UrlValue WebForm:(NSString*)WebForm Width:(NSNumber*)Width IsMobileAvailable:(BOOL)IsMobileAvailable MobileLabel:(NSString*)MobileLabel MobileOrder:(NSNumber*)MobileOrder;
*/
- (id)initFormField:(NSDictionary *)formFieldDict;

- (UIView*)getFieldView;
- (UILabel *)getLabelView;
- (NSString *)getFormFieldValue;
- (void)setFormFieldValue:(NSString *)value;
- (UILabel *)getReviewFieldNameLabel;
- (UILabel *)getReviewFieldValueLabel;
- (void)addChildPicklistFormField:(FormField *)childFormField;
- (void)parentPicklistChanged;
@end
