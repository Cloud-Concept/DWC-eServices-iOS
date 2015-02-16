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

@implementation UIView (DynamicForm)

- (void)drawFormFields:(WebForm *)webForm cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton {
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    
    for (FormField *field in webForm.formFields) {
        [viewsDictionary setObject:[field getFieldView] forKey:field.name];
        [viewsDictionary setObject:[field getLabelView] forKey:[NSString stringWithFormat:@"%@_label", field.name]];
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
    
    NSDictionary *metrics = @{@"fieldHeight": @44,
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
        
        if (currentField.hidden)
            continue;
        
        NSString *heightRule = [NSString stringWithFormat:@"V:[%@(fieldHeight)]", currentField.name];
        NSArray *field_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:heightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        /*
        NSString *widthtRule = [NSString stringWithFormat:@"H:[%@(100)]", currentField.name];
        NSArray *field_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:widthtRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        */
        [self addConstraints:field_constraint_V];
        //[self addConstraints:field_constraint_H];
        
        NSString *labelName = [NSString stringWithFormat:@"%@_label", currentField.name];
        
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
        
        if(index != 0)
            previousField = [webForm.formFields objectAtIndex:index - 1];
        
        NSString *labelHorizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-rightMargin-|", labelName];
        NSArray *label_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:labelHorizontalRule
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
        
        NSString *fieldHorizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-rightMargin-|", currentField.name];
        NSArray *field_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:fieldHorizontalRule
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
        
        NSMutableString *verticalRule = [NSMutableString stringWithFormat:@"V:[%@]-[%@]", labelName, currentField.name];
        NSMutableString *verticalLabelRule = [NSMutableString stringWithString:@"V:"];
        
        if (previousField == nil)
        {
            [verticalLabelRule appendString:@"|-topMargin-"];
        }
        else
        {
            [verticalLabelRule appendFormat:@"[%@]-fieldsMargin-", previousField.name];
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
        verticalRule = [NSString stringWithFormat:@"V:[%@]-buttonsTopMargin-[%@]-bottomMargin-|", previousField.name, @"cancelButton"];
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
