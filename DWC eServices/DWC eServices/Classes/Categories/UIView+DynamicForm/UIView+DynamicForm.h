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

- (void)drawWebform:(WebForm *)webForm cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton;
- (void)drawFormFields:(NSArray *)formFields cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton;
- (void)drawAttachmentButtons:(NSArray *) attachmentArray cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton viewController:(UIViewController *)viewController;
- (void)drawReviewForm:(NSString *)requestNumber requestStatus:(NSString *)requestStatus requestType:(NSString *)requestType requestCreatedDate:(NSString *)requestCreatedDate totalAmount:(NSNumber *)totalAmount isCourierRequired:(BOOL) isCourierRequired formFieldsArray:(NSArray *)formFieldsArray cancelButton:(UIButton *)cancelButton nextButton:(UIButton *)nextButton showTotalAmout:(BOOL)showTotalAmout;
@end
