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

- (void)drawFormFields:(WebForm *)webForm {
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    
    for (FormField *field in webForm.formFields) {
        [viewsDictionary setObject:[field getFieldView] forKey:field.name];
        [viewsDictionary setObject:[field getLabelView] forKey:[NSString stringWithFormat:@"%@_label", field.name]];
        [field getFieldView].translatesAutoresizingMaskIntoConstraints = NO;
        [field getLabelView].translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:[field getFieldView]];
        [self addSubview:[field getLabelView]];
    }
    
    for (NSInteger index = 0; index < [webForm.formFields count]; index++) {
        
        FormField *currentField = [webForm.formFields objectAtIndex:index];
        FormField *previousField = nil;
        
        if (currentField.hidden)
            continue;
        
        NSString *heightRule = [NSString stringWithFormat:@"V:[%@(44)]", currentField.name];
        NSArray *field_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:heightRule
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewsDictionary];
        
        NSString *widthtRule = [NSString stringWithFormat:@"H:[%@(100)]", currentField.name];
        NSArray *field_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:widthtRule
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewsDictionary];
        
        [self addConstraints:field_constraint_V];
        //[self addConstraints:field_constraint_H];
        
        NSString *labelName = [NSString stringWithFormat:@"%@_label", currentField.name];
        
        NSString *labelHeightRule = [NSString stringWithFormat:@"V:[%@(44)]", labelName];
        NSArray *label_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:labelHeightRule
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewsDictionary];
        
        NSString *labelWidthtRule = [NSString stringWithFormat:@"H:[%@(200)]", labelName];
        NSArray *label_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:labelWidthtRule
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewsDictionary];
        
        [self addConstraints:label_constraint_V];
        [self addConstraints:label_constraint_H];
        
        if(index != 0)
            previousField = [webForm.formFields objectAtIndex:index - 1];
        
        NSString *horizontalRule = [NSString stringWithFormat:@"H:|-[%@]-[%@]-|", labelName, currentField.name];
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary];
        
        NSMutableString *verticalRule = [NSMutableString stringWithString:@"V:"];
        NSMutableString *verticalLabelRule = [NSMutableString stringWithString:@"V:"];
        
        if (previousField == nil)
        {
            [verticalRule appendFormat:@"|-"];
            [verticalLabelRule appendString:@"|-"];
        }
        else
        {
            [verticalRule appendFormat:@"[%@]-", previousField.name];
            [verticalLabelRule appendFormat:@"[%@]-", [NSString stringWithFormat:@"%@_label", previousField.name]];
        }
        
        [verticalRule appendFormat:@"[%@]", currentField.name];
        [verticalLabelRule appendFormat:@"[%@]", labelName];
        
        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary];
        
        NSArray *constraint_Label_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalLabelRule
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDictionary];
        
        [self addConstraints:constraint_POS_H];
        [self addConstraints:constraint_POS_V];
        [self addConstraints:constraint_Label_POS_V];
    }
}

@end
