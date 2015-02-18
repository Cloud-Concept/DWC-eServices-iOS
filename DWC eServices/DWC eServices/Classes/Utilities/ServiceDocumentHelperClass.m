//
//  ServiceDocumentHelperClass.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/17/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ServiceDocumentHelperClass.h"
#import "EServiceDocument.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ServiceDocumentHelperClass

+ (UIButton *)getButtonForDocument:(EServiceDocument *)document Taregt:(id)target Action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitleColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1]
                 forState:UIControlStateNormal];
    
    [button setTitle:document.name forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
    
    NSString *backgroundImageName = document.attachment ? @"Delete Button" : @"Add Button";
    
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 44)];
    
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (void)refreshButton:(UIButton *)button forDocument:(EServiceDocument *)document {
    NSString *backgroundImageName = document.attachment ? @"Delete Button" : @"Add Button";
    
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName]
                      forState:UIControlStateNormal];
}

+ (void)confirmDeleteDocument:(EServiceDocument *)document ViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DeleteAlertTitle", @"")
                                                                   message:NSLocalizedString(@"DeleteDocumentAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          NSLog(@"Delete action");
                                                          [document deleteDocument];
                                                      }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          NSLog(@"Cancel action");
                                                      }];
    
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)documentSourceActionSheet:(EServiceDocument *)document ViewController:(UIViewController *)viewController {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DocumentSourceAlertTitle", @"")
                                                                         message:NSLocalizedString(@"DocumentSourceAlertMessage", @"")
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             NSLog(@"Cancel Action");
                                                         }];
    
    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"galleryDocumentSource", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Imagepicker Action");
                                                                  [ServiceDocumentHelperClass showImagePickerInViewContoller:viewController forDocument:document];
                                                              }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:imagePickerAction];
    
    [viewController presentViewController:actionSheet animated:YES completion:nil];
}

+ (void)showImagePickerInViewContoller:(UIViewController *)viewController forDocument:(EServiceDocument *)document {
    SEL selector = @selector(showImagePickerForDocument:);
    
    if ([viewController respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[viewController methodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:viewController];
        
        [invocation setArgument:&(document) atIndex:2];
        
        [invocation invoke];
    }
}

@end
