//
//  UIView+DynamicForm.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebForm;

@interface UIView (DynamicForm)

- (void)drawFormFields:(WebForm *)webForm cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton;

@end
