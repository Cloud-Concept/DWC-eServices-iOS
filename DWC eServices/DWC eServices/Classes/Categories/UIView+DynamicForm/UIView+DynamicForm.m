//
//  UIView+DynamicForm.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIView+DynamicForm.h"
#import "WebForm.h"
#import "FormField.h"
#import "EServiceDocument.h"
#import "HelperClass.h"

@implementation UIView (DynamicForm)

- (void)drawFormFields:(WebForm *)webForm cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton {
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    
    for (FormField *field in webForm.formFields) {
        
        if (field.hidden || [field.type isEqualToString:@"CUSTOMTEXT"] || [field.type isEqualToString:@"REFERENCE"])
            continue;
        
        [viewsDictionary setObject:[field getFieldView] forKey:field.nameNoSpace];
        [viewsDictionary setObject:[field getLabelView] forKey:[NSString stringWithFormat:@"%@_label", field.nameNoSpace]];
        [field getFieldView].translatesAutoresizingMaskIntoConstraints = NO;
        [field getLabelView].translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:[field getFieldView]];
        [self addSubview:[field getLabelView]];
    }
    
    [viewsDictionary setObject:cancelButton forKey:@"cancelButton"];
    [viewsDictionary setObject:nextButton forKey:@"nextButton"];
    
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:cancelButton];
    [self addSubview:nextButton];
    
    NSDictionary *metrics = @{@"fieldHeight": @40,
                              @"labelHeight": @20,
                              @"leftMargin": @16,
                              @"rightMargin": @16,
                              @"fieldsMargin": @16,
                              @"topMargin": @20,
                              @"bottomMargin": @20,
                              @"buttonHeight": @47,
                              @"buttonsSpacing": @16,
                              @"buttonsTopMargin": @40
                              };
    
    for (NSInteger index = 0; index < [webForm.formFields count]; index++) {
        
        FormField *currentField = [webForm.formFields objectAtIndex:index];
        FormField *previousField = nil;
        
        if (currentField.hidden || [currentField.type isEqualToString:@"CUSTOMTEXT"] || [currentField.type isEqualToString:@"REFERENCE"])
            continue;
        
        NSString *heightRule = [NSString stringWithFormat:@"V:[%@(fieldHeight)]", currentField.nameNoSpace];
        NSArray *field_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:heightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        /*
         NSString *widthtRule = [NSString stringWithFormat:@"H:[%@(100)]", currentField.nameNoSpace];
         NSArray *field_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:widthtRule
         options:0
         metrics:metrics
         views:viewsDictionary];
         */
        [self addConstraints:field_constraint_V];
        //[self addConstraints:field_constraint_H];
        
        NSString *labelName = [NSString stringWithFormat:@"%@_label", currentField.nameNoSpace];
        
        NSString *labelHeightRule = [NSString stringWithFormat:@"V:[%@(labelHeight)]", labelName];
        NSArray *label_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:labelHeightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        /*
         NSString *labelWidthtRule = [NSString stringWithFormat:@"H:[%@(200)]", labelName];
         NSArray *label_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:labelWidthtRule
         options:0
         metrics:metrics
         views:viewsDictionary];
         */
        [self addConstraints:label_constraint_V];
        //[self addConstraints:label_constraint_H];
        
        for (NSInteger i = index - 1; i >=0 ; i--) {
            FormField *tempField = [webForm.formFields objectAtIndex:i];
            
            if (![tempField.type isEqualToString:@"CUSTOMTEXT"] && ![tempField.type isEqualToString:@"REFERENCE"] && !tempField.hidden) {
                previousField = tempField;
                break;
            }
        }
        
        
        NSString *labelHorizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-rightMargin-|", labelName];
        NSArray *label_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:labelHorizontalRule
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
        
        NSString *fieldHorizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-rightMargin-|", currentField.nameNoSpace];
        NSArray *field_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:fieldHorizontalRule
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
        
        NSMutableString *verticalRule = [NSMutableString stringWithFormat:@"V:[%@]-[%@]", labelName, currentField.nameNoSpace];
        NSMutableString *verticalLabelRule = [NSMutableString stringWithString:@"V:"];
        
        if (previousField == nil)
        {
            [verticalLabelRule appendString:@"|-topMargin-"];
        }
        else
        {
            [verticalLabelRule appendFormat:@"[%@]-fieldsMargin-", previousField.nameNoSpace];
        }
        
        [verticalLabelRule appendFormat:@"[%@]", labelName];
        
        if (index == webForm.formFields.count - 1 && (!cancelButton && !nextButton)) {
            [verticalRule appendString:@"-|"];
        }
        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        NSArray *constraint_Label_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalLabelRule
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
        
        [self addConstraints:label_constraint_POS_H];
        [self addConstraints:field_constraint_POS_H];
        [self addConstraints:constraint_POS_V];
        [self addConstraints:constraint_Label_POS_V];
    }
    
    NSString *cancelHeightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", @"cancelButton"];
    NSArray *cancel_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:cancelHeightRule
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:viewsDictionary];
    
    NSString *nextHeightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", @"nextButton"];
    NSArray *next_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:nextHeightRule
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:viewsDictionary];
    
    [self addConstraints:cancel_constraint_V];
    [self addConstraints:next_constraint_V];
    
    NSString *horizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-buttonsSpacing-[%@]-rightMargin-|", @"cancelButton", @"nextButton"];
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    [self addConstraints:constraint_POS_H];
    
    FormField *previousField;
    if (webForm.formFields.count > 0) {
        previousField = [webForm.formFields objectAtIndex:webForm.formFields.count - 1];
    }
    
    NSString *verticalRule = @"";
    if (previousField)
        verticalRule = [NSString stringWithFormat:@"V:[%@]-buttonsTopMargin-[%@]-bottomMargin-|", previousField.nameNoSpace, @"cancelButton"];
    else
        verticalRule = [NSString stringWithFormat:@"V:|-buttonsTopMargin-[%@]-bottomMargin-|", @"cancelButton"];
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    [self addConstraints:constraint_POS_V];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeTopMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeBottomMargin
                                                    multiplier:1
                                                      constant:0.0]];
}

- (void)drawAttachmentButtons:(NSArray *) attachmentArray cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton viewController:(UIViewController *)viewController {
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    
    for (EServiceDocument *document in attachmentArray) {
        UIButton *button = [document getDocumentButton:viewController];
        [viewsDictionary setObject:button forKey:document.nameNoSpace];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:button];
    }
    
    [viewsDictionary setObject:cancelButton forKey:@"cancelButton"];
    [viewsDictionary setObject:nextButton forKey:@"nextButton"];
    
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:cancelButton];
    [self addSubview:nextButton];
    
    NSDictionary *metrics = @{@"fieldHeight": @40,
                              @"leftMargin": @16,
                              @"rightMargin": @16,
                              @"fieldsMargin": @16,
                              @"topMargin": @20,
                              @"bottomMargin": @20,
                              @"buttonHeight": @47,
                              @"buttonsSpacing": @16,
                              @"buttonsTopMargin": @40
                              };
    
    
    for (NSInteger index = 0; index < attachmentArray.count; index++) {
        
        EServiceDocument *currentdocument = [attachmentArray objectAtIndex:index];
        EServiceDocument *previousdocument = nil;
        
        NSString *heightRule = [NSString stringWithFormat:@"V:[%@(fieldHeight)]", currentdocument.nameNoSpace];
        NSArray *field_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:heightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        [self addConstraints:field_constraint_V];
        
        if(index != 0)
            previousdocument = [attachmentArray objectAtIndex:index - 1];
        
        NSString *horizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-rightMargin-|", currentdocument.nameNoSpace];
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        NSMutableString *verticalRule = [NSMutableString stringWithString:@"V:"];
        
        if (previousdocument == nil)
        {
            [verticalRule appendString:@"|-topMargin-"];
        }
        else
        {
            [verticalRule appendFormat:@"[%@]-fieldsMargin-", previousdocument.nameNoSpace];
        }
        
        [verticalRule appendFormat:@"[%@]", currentdocument.nameNoSpace];
        
        if (index == attachmentArray.count - 1 && (!cancelButton && !nextButton)) {
            [verticalRule appendString:@"-|"];
        }
        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        
        [self addConstraints:constraint_POS_H];
        [self addConstraints:constraint_POS_V];
        
    }
    
    NSString *cancelHeightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", @"cancelButton"];
    NSArray *cancel_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:cancelHeightRule
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:viewsDictionary];
    
    NSString *nextHeightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", @"nextButton"];
    NSArray *next_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:nextHeightRule
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:viewsDictionary];
    
    [self addConstraints:cancel_constraint_V];
    [self addConstraints:next_constraint_V];
    
    NSString *horizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-buttonsSpacing-[%@]-rightMargin-|", @"cancelButton", @"nextButton"];
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    [self addConstraints:constraint_POS_H];
    
    EServiceDocument *previousDocument;
    if (attachmentArray.count > 0) {
        previousDocument = [attachmentArray objectAtIndex:attachmentArray.count - 1];
    }
    
    NSString *verticalRule = @"";
    if (previousDocument)
        verticalRule = [NSString stringWithFormat:@"V:[%@]-buttonsTopMargin-[%@]-bottomMargin-|", previousDocument.nameNoSpace, @"cancelButton"];
    else
        verticalRule = [NSString stringWithFormat:@"V:|-buttonsTopMargin-[%@]-bottomMargin-|", @"cancelButton"];
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    [self addConstraints:constraint_POS_V];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeTopMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeBottomMargin
                                                    multiplier:1
                                                      constant:0.0]];
}

- (void)drawReviewForm:(NSString *)requestNumber requestStatus:(NSString *)requestStatus requestType:(NSString *)requestType requestCreatedDate:(NSString *)requestCreatedDate totalAmount:(NSNumber *)totalAmount isCourierRequired:(BOOL) isCourierRequired formFieldsArray:(NSArray *)formFieldsArray cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton {
    
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"requestInfoTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"RequestInfoLabel", @"") FieldValue:@""]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"requestNumber" Type:@"STRING" MobileLabel:NSLocalizedString(@"RequestNumberLabel", @"") FieldValue:requestNumber]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"requestStatus" Type:@"STRING" MobileLabel:NSLocalizedString(@"RequestStatusLabel", @"") FieldValue:requestStatus]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"requestType" Type:@"STRING" MobileLabel:NSLocalizedString(@"RequestTypeLabel", @"") FieldValue:requestType]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"requestCreatedDate" Type:@"STRING" MobileLabel:NSLocalizedString(@"RequestCreatedDateLabel", @"") FieldValue:requestCreatedDate]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"totalAmount" Type:@"STRING" MobileLabel:NSLocalizedString(@"RequestTotalAmountLabel", @"") FieldValue:[HelperClass formatNumberToString:totalAmount FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"requestIsCourierRequired" Type:@"STRING" MobileLabel:NSLocalizedString(@"RequestIsCourierRequiredLabel", @"") FieldValue:[HelperClass formatBoolToString:isCourierRequired]]];
    
    [formFieldsMutableArray addObjectsFromArray:formFieldsArray];
    
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    
    for (FormField *field in formFieldsMutableArray) {
        
        if (field.hidden || [field.type isEqualToString:@"REFERENCE"])
            continue;
        
        [viewsDictionary setObject:[field getReviewFieldValueLabel] forKey:field.nameNoSpace];
        [viewsDictionary setObject:[field getReviewFieldNameLabel] forKey:[NSString stringWithFormat:@"%@_label", field.nameNoSpace]];
        [field getReviewFieldValueLabel].translatesAutoresizingMaskIntoConstraints = NO;
        [field getReviewFieldNameLabel].translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:[field getReviewFieldValueLabel]];
        [self addSubview:[field getReviewFieldNameLabel]];
    }
    
    [viewsDictionary setObject:cancelButton forKey:@"cancelButton"];
    [viewsDictionary setObject:nextButton forKey:@"nextButton"];
    
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:cancelButton];
    [self addSubview:nextButton];
    
    
    NSNumber *fieldWidth = [NSNumber numberWithFloat:((self.frame.size.width - (2 * 30) - 16) / 2.0)];
    
    NSDictionary *metrics = @{@"labelHeight": @20,
                              @"labelWidth": fieldWidth,
                              @"leftMargin": @30,
                              @"rightMargin": @30,
                              @"fieldsMargin": @8,
                              @"sectionsMargin": @16,
                              @"topMargin": @20,
                              @"bottomMargin": @20,
                              @"buttonHeight": @47,
                              @"buttonsSpacing": @16,
                              @"buttonsTopMargin": @40
                              };
    
    for (NSInteger index = 0; index < [formFieldsMutableArray count]; index++) {
        
        FormField *currentField = [formFieldsMutableArray objectAtIndex:index];
        FormField *previousField = nil;
        
        if (currentField.hidden)
            continue;
        
        NSString *heightRule = [NSString stringWithFormat:@"V:[%@(labelHeight)]", currentField.nameNoSpace];
        NSArray *field_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:heightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        
        NSString *labelWith = [currentField.type isEqualToString:@"CUSTOMTEXT"] ? @"0" : @"labelWidth";
        NSString *widthRule = [NSString stringWithFormat:@"H:[%@(%@)]", currentField.nameNoSpace, labelWith];
        NSArray *field_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:widthRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        
        [self addConstraints:field_constraint_V];
        [self addConstraints:field_constraint_H];
        
        NSString *labelName = [NSString stringWithFormat:@"%@_label", currentField.nameNoSpace];
        
        NSString *labelHeightRule = [NSString stringWithFormat:@"V:[%@(labelHeight)]", labelName];
        NSArray *label_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:labelHeightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        
        
        NSString *labelWidthRule = [NSString stringWithFormat:@"H:[%@(labelWidth)]", labelName];
        NSArray *label_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:labelWidthRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        
        [self addConstraints:label_constraint_V];
        if (![currentField.type isEqualToString:@"CUSTOMTEXT"])
            [self addConstraints:label_constraint_H];
        
        
        for (NSInteger i = index - 1; i >=0 ; i--) {
            FormField *tempField = [formFieldsMutableArray objectAtIndex:i];
            
            if (![tempField.type isEqualToString:@"REFERENCE"] && !tempField.hidden) {
                previousField = tempField;
                break;
            }
        }
        
        /*
        if(index != 0)
            previousField = [formFieldsMutableArray objectAtIndex:index - 1];
        */
        NSString *horizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-[%@]-rightMargin-|", labelName, currentField.nameNoSpace];
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
        
        NSMutableString *verticalFieldRule = [NSMutableString stringWithFormat:@"V:"];
        NSMutableString *verticalLabelRule = [NSMutableString stringWithString:@"V:"];
        
        if (previousField == nil)
        {
            [verticalLabelRule appendString:@"|-topMargin-"];
            [verticalFieldRule appendString:@"|-topMargin-"];
        }
        else
        {
            NSString *margin = [currentField.type isEqualToString:@"CUSTOMTEXT"] ? @"sectionsMargin" : @"fieldsMargin";
            
            [verticalLabelRule appendFormat:@"[%@_label]-%@-", previousField.nameNoSpace, margin];
            [verticalFieldRule appendFormat:@"[%@]-%@-", previousField.nameNoSpace, margin];
        }
        
        [verticalLabelRule appendFormat:@"[%@]", labelName];
        [verticalFieldRule appendFormat:@"[%@]", currentField.nameNoSpace];
        
        if (index == formFieldsMutableArray.count - 1 && (!cancelButton && !nextButton)) {
            [verticalFieldRule appendString:@"-|"];
            [verticalLabelRule appendString:@"-|"];
        }
        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalFieldRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        NSArray *constraint_Label_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalLabelRule
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
        
        [self addConstraints:constraint_POS_H];
        [self addConstraints:constraint_POS_V];
        [self addConstraints:constraint_Label_POS_V];
    }
    
    NSString *cancelHeightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", @"cancelButton"];
    NSArray *cancel_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:cancelHeightRule
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:viewsDictionary];
    
    NSString *nextHeightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", @"nextButton"];
    NSArray *next_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:nextHeightRule
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:viewsDictionary];
    
    [self addConstraints:cancel_constraint_V];
    [self addConstraints:next_constraint_V];
    
    NSString *horizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-buttonsSpacing-[%@]-rightMargin-|", @"cancelButton", @"nextButton"];
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    [self addConstraints:constraint_POS_H];
    
    FormField *previousField;
    if (formFieldsMutableArray.count > 0) {
        previousField = [formFieldsMutableArray objectAtIndex:formFieldsMutableArray.count - 1];
    }
    
    NSString *verticalRule = @"";
    if (previousField)
        verticalRule = [NSString stringWithFormat:@"V:[%@]-buttonsTopMargin-[%@]-bottomMargin-|", previousField.nameNoSpace, @"cancelButton"];
    else
        verticalRule = [NSString stringWithFormat:@"V:|-buttonsTopMargin-[%@]-bottomMargin-|", @"cancelButton"];
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    [self addConstraints:constraint_POS_V];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeTopMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nextButton
                                                     attribute:NSLayoutAttributeBottomMargin
                                                    multiplier:1
                                                      constant:0.0]];
    
}
@end
