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

- (id)initFormField:(NSString *)formFieldId Name:(NSString *)Name Type:(NSString*)Type MobileLabel:(NSString *)MobileLabel FieldValue:(NSString*)FieldValue{
    return [self initFormField:formFieldId Name:Name Type:Type MobileLabel:MobileLabel FieldValue:FieldValue IsParameter:NO];
}

- (id)initFormField:(NSString *)formFieldId Name:(NSString *)Name Type:(NSString*)Type MobileLabel:(NSString *)MobileLabel FieldValue:(NSString*)FieldValue IsParameter:(BOOL)IsParameter {
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
                           IsParameter:IsParameter
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

- (id)initFormField:(NSDictionary *)formFieldDict {
    if (!(self = [super init])) {
        return nil;
    }
    
    if ([formFieldDict isKindOfClass:[NSNull class]] || formFieldDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Name"]];
    self.nameNoSpace = [self.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    self.emailValue = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Email_Value__c"]];
    self.label = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Label__c"]];
    self.phoneValue = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Phone_Value__c"]];
    self.picklistValue = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Picklist_Value__c"]];
    self.picklistEntries = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"PicklistEntries__c"]];
    self.textAreaLongValue = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Text_Area_Long_Value__c"]];
    self.textAreaValue = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Text_Area_Value__c"]];
    self.textValue = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Text_Value__c"]];
    self.type = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Type__c"]];
    self.urlValue = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"URL_Value__c"]];
    self.webForm = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Web_Form__c"]];
    self.mobileLabel = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Mobile_Label__c"]];
    self.controllingField = [HelperClass stringCheckNull:[formFieldDict objectForKey:@"Controlling_Field__c"]];
    
    self.apiRequired = [[formFieldDict objectForKey:@"APIRequired__c"] boolValue];
    self.booleanValue = [[formFieldDict objectForKey:@"Boolean_Value__c"] boolValue];
    self.hidden = [[formFieldDict objectForKey:@"Hidden__c"] boolValue];
    self.isCalculated = [[formFieldDict objectForKey:@"isCalculated__c"] boolValue];
    self.isParameter = [[formFieldDict objectForKey:@"isParameter__c"] boolValue];
    self.isQuery = [[formFieldDict objectForKey:@"isQuery__c"] boolValue];
    self.required = [[formFieldDict objectForKey:@"Required__c"] boolValue];
    self.isMobileAvailable = [[formFieldDict objectForKey:@"isMobileAvailable__c"] boolValue];
    self.isDependentPicklist = [[formFieldDict objectForKey:@"isDependentPicklist__c"] boolValue];
    self.shouldBeCloned = [[formFieldDict objectForKey:@"should_Be_Cloned__c"] boolValue];
    
    self.currencyValue = [HelperClass numberCheckNull:[formFieldDict objectForKey:@"Currency_Value__c"]];
    self.numberValue = [HelperClass numberCheckNull:[formFieldDict objectForKey:@"Number_Value__c"]];
    self.order = [HelperClass numberCheckNull:[formFieldDict objectForKey:@"Order__c"]];
    self.mobileOrder = [HelperClass numberCheckNull:[formFieldDict objectForKey:@"Mobile_Order__c"]];
    self.percentValue = [HelperClass numberCheckNull:[formFieldDict objectForKey:@"Percent_Value__c"]];
    self.width = [HelperClass numberCheckNull:[formFieldDict objectForKey:@"Width__c"]];
    
    if (![[formFieldDict objectForKey:@"DateTime_Value__c"] isKindOfClass:[NSNull class]])
        self.dateTimeValue = [SFDateUtil SOQLDateTimeStringToDate:[formFieldDict objectForKey:@"DateTime_Value__c"]];
    
    if (![[formFieldDict objectForKey:@"Date_Value__c"] isKindOfClass:[NSNull class]])
        self.dateValue = [SFDateUtil SOQLDateTimeStringToDate:[formFieldDict objectForKey:@"Date_Value__c"]];
    
    fieldView = nil;
    formFieldValue = @"";
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
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
    copy.isDependentPicklist = _isDependentPicklist;
    copy.controllingField = _controllingField;
    
    [copy setPicklistNamesDictionary:picklistNamesDictionary PicklistValuesDictionary:picklistValuesDictionary];
    [copy setFormFieldValue:formFieldValue];

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
        
        if ([self.type isEqualToString:@"BOOLEAN"])
            [reviewFieldValueLabel setText:[HelperClass formatBoolToString:[formFieldValue boolValue]]];
        
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
            [self.type isEqualToString:@"REFERENCE"] ||
            [self.type isEqualToString:@"DATE"]) {
            fieldView = [UIButton buttonWithType:UIButtonTypeSystem];
            [((UIButton*)fieldView) setTitleColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1]
                                         forState:UIControlStateNormal];
            [((UIButton*)fieldView) setTitle:self.mobileLabel forState:UIControlStateNormal];
            [((UIButton*)fieldView).titleLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
            NSString *backgroundImage = isEnabled ? @"Dropdown Button" : @"Textfield Background";
            [((UIButton*)fieldView) setBackgroundImage:[UIImage imageNamed:backgroundImage]
                                              forState:UIControlStateNormal];
            
            if (isEnabled)
                [((UIButton*)fieldView) setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 44)];
            
            if(![formFieldValue isEqualToString:@""])
                [((UIButton*)fieldView) setTitle:formFieldValue forState:UIControlStateNormal];
            
            if ([self.type isEqualToString:@"PICKLIST"] ||
                [self.type isEqualToString:@"REFERENCE"]) {
                [((UIButton*)fieldView) setTitle:pickListLabelValue forState:UIControlStateNormal];
            }
            
            SEL actionSelector = ([self.type isEqualToString:@"DATE"]) ? @selector(openDatePicker) : @selector(openPickList);
            
            [(UIButton*)fieldView addTarget:self
                                     action:actionSelector
                           forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([self.type isEqualToString:@"STRING"] ||
                 [self.type isEqualToString:@"EMAIL"] ||
                 [self.type isEqualToString:@"DOUBLE"]) {
            
            fieldView = [UITextField new];
            [((UITextField*)fieldView) setBorderStyle:UITextBorderStyleNone];
            [((UITextField*)fieldView) setBackground:[UIImage imageNamed:@"Textfield Background"]];
            
            UIKeyboardType keyboardType = [self.type isEqualToString:@"DOUBLE"] ? UIKeyboardTypeDecimalPad : UIKeyboardTypeASCIICapable;
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
        else if ([self.type isEqualToString:@"BOOLEAN"]) {
            fieldView = [UISwitch new];
            [((UISwitch *)fieldView) setOnTintColor:[UIColor colorWithRed:0.274 green:0.545 blue:0.733 alpha:1]];
            [((UISwitch *)fieldView) setOn:[formFieldValue boolValue]];
            [((UISwitch *)fieldView) setEnabled:isEnabled];
            [((UISwitch *)fieldView) addTarget:self
                                        action:@selector(switchValueChanged:)
                              forControlEvents:UIControlEventValueChanged];
        }
        
        [fieldView setUserInteractionEnabled:isEnabled];
    }
    
    return fieldView;
}

- (void)switchValueChanged:(UISwitch *)switchSender {
    formFieldValue = switchSender.isOn ? @"1" : @"0";
}

- (void)textFieldEditingChanged:(UITextField *)textField{
    formFieldValue = textField.text;
}

- (void)openPickList {
    
    NSArray *stringArray = [NSArray new];
    
    if (self.isDependentPicklist) {
        stringArray = [picklistNamesDictionary objectForKey:[self.controllingFormField getFormFieldValue]];
    }
    else {
        stringArray = [picklistNamesDictionary objectForKey:self.name];
    }

    UIButton *senderButton = (UIButton*)fieldView;
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = stringArray;
    pickerTableVC.selectedIndexPath = selectedPicklistIndexPath;
    pickerTableVC.valuePicked = ^(NSString * value, NSIndexPath * indexPath, PickerTableViewController *picklist) {
        
        [self picklistValueSelected:value indexPath:indexPath];
        
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
    formFieldValue = [HelperClass stringCheckNull:value];
    pickListLabelValue = formFieldValue;
    
    if (fieldView != nil) {
        if ([self.type isEqualToString:@"PICKLIST"]) {
            [((UIButton*)fieldView) setTitle:pickListLabelValue forState:UIControlStateNormal];
        }
        else if ([self.type isEqualToString:@"STRING"] ||
                 [self.type isEqualToString:@"DOUBLE"] ||
                 [self.type isEqualToString:@"CUSTOMTEXT"]) {
            [((UITextField*)fieldView) setText:formFieldValue];
        }
        else if ([self.type isEqualToString:@"BOOLEAN"]) {
            [((UISwitch *)fieldView) setOn:[formFieldValue isEqualToString:@"1"]];
        }
    }
}

- (void)setPicklistLabel:(NSString *)value {
    pickListLabelValue = value;
    if (fieldView != nil)
        [((UIButton*)fieldView) setTitle:value forState:UIControlStateNormal];
}

- (void)setPicklistNamesDictionary:(NSDictionary *)namesDict PicklistValuesDictionary:(NSDictionary *)valuesDict {
    picklistNamesDictionary = namesDict;
    picklistValuesDictionary = valuesDict;
    
    if (formFieldValue && ![formFieldValue isEqualToString:@""])
        return;
    
    if (picklistNamesDictionary && picklistNamesDictionary.count > 0) {
        NSArray *stringArray = [NSArray new];
        if (self.isDependentPicklist) {
            stringArray = [picklistNamesDictionary objectForKey:[self.controllingFormField getFormFieldValue]];
        }
        else {
            stringArray = [picklistNamesDictionary objectForKey:self.name];
        }
        
        if (!stringArray || stringArray.count <= 0)
            return;
        
        [self picklistValueSelected:[stringArray objectAtIndex:0] indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)picklistValueSelected:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    selectedPicklistIndexPath = indexPath;
    formFieldValue = value;
    pickListLabelValue = value;
    
    if ([self.type isEqualToString:@"REFERENCE"])
        formFieldValue = [[picklistValuesDictionary objectForKey:self.name] objectAtIndex:indexPath.row];
    
    [((UIButton*)fieldView) setTitle:value forState:UIControlStateNormal];
    
    for (FormField *childFormField in childrenPicklistFormFieldsArray) {
        [childFormField parentPicklistChanged];
    }
}

- (void)addChildPicklistFormField:(FormField *)childFormField {
    [childrenPicklistFormFieldsArray addObject:childFormField];
}

- (void)parentPicklistChanged {
    selectedPicklistIndexPath = nil;
    formFieldValue = nil;
    [((UIButton*)fieldView) setTitle:self.mobileLabel forState:UIControlStateNormal];
}

#pragma UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if ([self.type isEqualToString:@"DATE"] && ![formFieldValue isEqualToString:@""]) {
        [((UIButton*)fieldView) setTitle:formFieldValue forState:UIControlStateNormal];
    }
}

@end
