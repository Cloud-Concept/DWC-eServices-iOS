//
//  FormField.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/8/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "FormField.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation FormField

- (id)initFormField:(NSString *)formFieldId Name:(NSString *)Name Type:(NSString*)Type MobileLabel:(NSString *)MobileLabel FieldValue:(NSString*)FieldValue {
    id formField = [self initFormField:formFieldId
                                  Name:Name
                           APIRequired:NO
                          BooleanValue:NO
                         CurrencyValue:nil
                         DateTimeValue:nil
                             DateValue:nil
                            EmailValue:nil
                                Hidden:NO
                          IsCalculated:NO
                           IsParameter:NO
                               IsQuery:NO
                                 Label:nil
                           NumberValue:nil
                                 Order:nil
                          PercentValue:nil
                            PhoneValue:nil
                         PicklistValue:nil
                       PicklistEntries:nil
                              Required:NO
                     TextAreaLongValue:nil
                         TextAreaValue:nil
                             TextValue:nil
                                  Type:Type
                              UrlValue:nil
                               WebForm:nil
                                 Width:nil
                     IsMobileAvailable:YES
                           MobileLabel:MobileLabel
                           MobileOrder:nil];
    
    formFieldValue = FieldValue;
    
    return formField;
}

- (id)initFormField:(NSString*)formFieldId Name:(NSString*)Name APIRequired:(BOOL)APIRequired BooleanValue:(BOOL)BooleanValue CurrencyValue:(NSNumber*)CurrencyValue DateTimeValue:(NSString*)DateTimeValue DateValue:(NSString*)DateValue EmailValue:(NSString*)EmailValue Hidden:(BOOL)Hidden IsCalculated:(BOOL)IsCalculated IsParameter:(BOOL)IsParameter IsQuery:(BOOL)IsQuery Label:(NSString*)Label NumberValue:(NSNumber*)NumberValue Order:(NSNumber*)Order PercentValue:(NSNumber*)PercentValue PhoneValue:(NSString*)PhoneValue PicklistValue:(NSString*)PicklistValue PicklistEntries:(NSString*)PicklistEntries Required:(BOOL)Required TextAreaLongValue:(NSString*)TextAreaLongValue TextAreaValue:(NSString*)TextAreaValue TextValue:(NSString*)TextValue Type:(NSString*)Type UrlValue:(NSString*)UrlValue WebForm:(NSString*)WebForm Width:(NSNumber*)Width IsMobileAvailable:(BOOL)IsMobileAvailable MobileLabel:(NSString*)MobileLabel MobileOrder:(NSNumber*)MobileOrder {
    
    if (!(self = [super init])) {
        return nil;
    }
    
    self.Id = formFieldId;
    self.name = Name;
    self.nameNoSpace = [Name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    self.apiRequired = APIRequired;
    self.booleanValue = BooleanValue;
    self.currencyValue = CurrencyValue;
    self.dateTimeValue = [HelperClass dateTimeFromString:DateTimeValue];
    self.dateValue = [HelperClass dateTimeFromString:DateValue];
    self.emailValue = [HelperClass stringCheckNull:EmailValue];
    self.hidden = Hidden;
    self.isCalculated = IsCalculated;
    self.isParameter = IsParameter;
    self.isQuery = IsQuery;
    self.label = [HelperClass stringCheckNull:Label];
    self.numberValue = [HelperClass numberCheckNull:NumberValue];
    self.order = [HelperClass numberCheckNull:Order];
    self.percentValue = [HelperClass numberCheckNull:PercentValue];
    self.phoneValue = [HelperClass stringCheckNull:PhoneValue];
    self.picklistValue = [HelperClass stringCheckNull:PicklistValue];
    self.picklistEntries = [HelperClass stringCheckNull:PicklistEntries];
    self.required = Required;
    self.textAreaLongValue = [HelperClass stringCheckNull:TextAreaLongValue];
    self.textAreaValue = [HelperClass stringCheckNull:TextAreaValue];
    self.textValue = [HelperClass stringCheckNull:TextValue];
    self.type = [HelperClass stringCheckNull:Type];
    self.urlValue = [HelperClass stringCheckNull:UrlValue];
    self.webForm = [HelperClass stringCheckNull:WebForm];
    self.width = [HelperClass numberCheckNull:Width];
    self.isMobileAvailable = IsMobileAvailable;
    self.mobileLabel = MobileLabel;
    self.mobileOrder = MobileOrder;
    
    fieldView = nil;
    formFieldValue = @"";
    
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    FormField *copy = [[[self class] allocWithZone:zone] init];
    copy.Id = _Id;
    copy.name = _name;
    copy.apiRequired = _apiRequired;
    copy.booleanValue = _booleanValue;
    copy.currencyValue = _currencyValue;
    copy.dateTimeValue = _dateTimeValue;
    copy.dateValue = _dateValue;
    copy.emailValue = _emailValue;
    copy.hidden = _hidden;
    copy.isCalculated = _isCalculated;
    copy.isParameter = _isParameter;
    copy.isQuery = _isQuery;
    copy.label = _label;
    copy.numberValue = _numberValue;
    copy.order = _order;
    copy.percentValue = _percentValue;
    copy.phoneValue = _phoneValue;
    copy.picklistValue = _picklistValue;
    copy.picklistEntries = _picklistEntries;
    copy.required = _required;
    copy.textAreaLongValue = _textAreaLongValue;
    copy.textAreaValue = _textAreaValue;
    copy.textValue = _textValue;
    copy.type = _type;
    copy.urlValue = _urlValue;
    copy.webForm = _webForm;
    copy.width = _width;
    copy.isMobileAvailable = _isMobileAvailable;
    copy.mobileLabel = _mobileLabel;
    copy.mobileOrder = _mobileOrder;
    copy.nameNoSpace = _nameNoSpace;

    return copy;
}


- (UILabel *)getReviewFieldNameLabel {
    if (!reviewFieldNameLabel) {
        reviewFieldNameLabel = [UILabel new];
        
        BOOL isCustomText = [self.type isEqualToString:@"CUSTOMTEXT"];
        
        NSString *textFormat = isCustomText ? @"%@" : @"%@:";
        [reviewFieldNameLabel setText:[NSString stringWithFormat:textFormat, self.mobileLabel]];
        
        UIColor *textColor = isCustomText ? [UIColor colorWithRed:0.25 green:0.31 blue:0.35 alpha:1] : [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
        [reviewFieldNameLabel setTextColor:textColor];
        
        float textSize = isCustomText ? 14 : 10;
        [reviewFieldNameLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:textSize]];
        
        reviewFieldNameLabel.textAlignment = isCustomText ? NSTextAlignmentCenter: NSTextAlignmentRight;
    }
    return reviewFieldNameLabel;
}

- (UILabel *)getReviewFieldValueLabel {
    if (!reviewFieldValueLabel) {
        reviewFieldValueLabel = [UILabel new];
        [reviewFieldValueLabel setText:formFieldValue];
        [reviewFieldValueLabel setTextColor:[UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1]];
        [reviewFieldValueLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:10.0f]];
        reviewFieldValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return reviewFieldValueLabel;
}

- (UILabel*)getLabelView {
    if (!labelView) {
        labelView = [UILabel new];
        [labelView setText:self.mobileLabel];
        [labelView setTextColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1]];
        
        [labelView setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
    }
    
    return labelView;
}

- (UIView*)getFieldView {
    if (!fieldView) {
        
        BOOL isEnabled = !(self.isCalculated || self.isParameter);
        
        if ([self.type isEqualToString:@"PICKLIST"] ||
            [self.type isEqualToString:@"DATE"]) {
            fieldView = [UIButton buttonWithType:UIButtonTypeSystem];
            [((UIButton*)fieldView) setTitleColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1]
                                         forState:UIControlStateNormal];
            [((UIButton*)fieldView) setTitle:self.mobileLabel forState:UIControlStateNormal];
            [((UIButton*)fieldView).titleLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
            NSString *backgroundImage = isEnabled ? @"Dropdown Button" : @"Textfield Background";
            [((UIButton*)fieldView) setBackgroundImage:[UIImage imageNamed:backgroundImage]
                                              forState:UIControlStateNormal];
            
            [((UIButton*)fieldView) setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 44)];
            
            if(![formFieldValue isEqualToString:@""])
                [((UIButton*)fieldView) setTitle:formFieldValue forState:UIControlStateNormal];
            
            SEL actionSelector = ([self.type isEqualToString:@"DATE"]) ? @selector(openDatePicker) : @selector(openPickList);
            
            [(UIButton*)fieldView addTarget:self
                                     action:actionSelector
                           forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([self.type isEqualToString:@"STRING"] ||
                 [self.type isEqualToString:@"DOUBLE"]) {
            
            fieldView = [UITextField new];
            [((UITextField*)fieldView) setBorderStyle:UITextBorderStyleNone];
            [((UITextField*)fieldView) setBackground:[UIImage imageNamed:@"Textfield Background"]];
            
            UIKeyboardType keyboardType = [self.type isEqualToString:@"STRING"] ? UIKeyboardTypeASCIICapable:UIKeyboardTypeDecimalPad;
            [((UITextField*)fieldView) setKeyboardType:keyboardType];
            
            [((UITextField*)fieldView) setPlaceholder:self.mobileLabel];
            [((UITextField*)fieldView) setText:formFieldValue];
            [((UITextField*)fieldView) setTextColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1]];
            [((UITextField*)fieldView) setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
            [((UITextField*)fieldView) setTextAlignment:NSTextAlignmentCenter];
            [((UITextField*)fieldView) setEnabled:isEnabled];
            
            [((UITextField*)fieldView) addTarget:self
                                          action:@selector(textFieldEditingChanged:)
                                forControlEvents:UIControlEventEditingChanged];
        }
        else if ([self.type isEqualToString:@"CUSTOMTEXT"]) {
            fieldView = [UITextField new];
            [((UITextField*)fieldView) setBorderStyle:UITextBorderStyleRoundedRect];
            [((UITextField*)fieldView) setPlaceholder:self.mobileLabel];
            [((UITextField*)fieldView) setText:formFieldValue];
            [((UITextField*)fieldView) setEnabled:NO];
        }
        
        [fieldView setUserInteractionEnabled:isEnabled];
    }
    
    return fieldView;
}

- (void)textFieldEditingChanged:(UITextField *)textField{
    formFieldValue = textField.text;
}

- (void)openPickList {
    
    NSArray *stringArray = [self.picklistEntries componentsSeparatedByString:@","];

    UIButton *senderButton = (UIButton*)fieldView;
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = stringArray;
    pickerTableVC.selectedIndexPath = selectedPicklistIndexPath;
    pickerTableVC.valuePicked = ^(NSString * value, NSIndexPath * indexPath, PickerTableViewController *picklist) {
        selectedPicklistIndexPath = indexPath;
        formFieldValue = value;
        [((UIButton*)fieldView) setTitle:value forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
    };
    
    [pickerTableVC showPopoverFromView:senderButton];
}

- (void)openDatePicker {
    UIButton *senderButton = (UIButton*)fieldView;
    
    DatePickerViewController *datePickerVC = [DatePickerViewController new];
    datePickerVC.DatePickerType = Date;
    
    if (![formFieldValue isEqualToString:@""])
        datePickerVC.defaultDate = [SFDateUtil SOQLDateTimeStringToDate:formFieldValue];
    
    datePickerVC.preferredContentSize = datePickerVC.view.bounds.size;
    
    datePickerVC.valuePicked = ^(NSDate *value, DatePickerViewController *picklist) {
        formFieldValue = [SFDateUtil toSOQLDateTimeString:value isDateTime:NO];
        [((UIButton*)fieldView) setTitle:[HelperClass formatDateToString:value] forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
    };
    
    [datePickerVC showPopoverFromView:senderButton];
}

- (NSString*)getFormFieldValue {
    return formFieldValue;
}

- (void)setFormFieldValue:(NSString*)value {
    if (![value isKindOfClass:[NSNull class]])
        formFieldValue = value;
    
    if (fieldView != nil) {
        if ([self.type isEqualToString:@"PICKLIST"]) {
            [((UIButton*)fieldView) setTitle:formFieldValue forState:UIControlStateNormal];
        }
        else if ([self.type isEqualToString:@"STRING"]) {
            [((UITextField*)fieldView) setText:formFieldValue];
        }
        else if ([self.type isEqualToString:@"CUSTOMTEXT"]) {
            [((UITextField*)fieldView) setText:formFieldValue];
        }
    }
}

#pragma UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if ([self.type isEqualToString:@"DATE"] && ![formFieldValue isEqualToString:@""]) {
        [((UIButton*)fieldView) setTitle:formFieldValue forState:UIControlStateNormal];
    }
}

@end
