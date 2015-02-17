//
//  ServiceDocumentHelperClass.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/17/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EServiceDocument;

@interface ServiceDocumentHelperClass : NSObject

+ (UIButton *)getButtonForDocument:(EServiceDocument *)document Taregt:(id)target Action:(SEL)action;
+ (void)confirmDeleteDocument:(EServiceDocument *)document ViewController:(UIViewController *)viewController;
+ (void)documentSourceActionSheet:(EServiceDocument *)document ViewController:(UIViewController *)viewController;
+ (void)refreshButton:(UIButton *)button forDocument:(EServiceDocument *)document;
@end
