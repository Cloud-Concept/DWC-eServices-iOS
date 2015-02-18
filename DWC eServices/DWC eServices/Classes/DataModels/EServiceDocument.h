//
//  EServiceDocument.h
//  DWCTest
//
//  Created by Mina Zaklama on 12/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EServiceDocument : NSObject
{
    UIButton *documentButton;
    UIViewController *buttonParentViewController;
}

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *authority;
@property (strong, nonatomic) NSString *documentType;
@property (strong, nonatomic) NSString *nameNoSpace;
@property (strong, nonatomic) NSData *attachment;

- (id)initEServiceDocument:(NSString *)ServiceId Name:(NSString *)Name Type:(NSString *)Type Language:(NSString *)Language Authority:(NSString*)Authority DocumentType:(NSString *)DocumentType;

- (UIButton *)getDocumentButton:(UIViewController *)parentViewController;
- (void)deleteDocumentAndButton;
- (void)deleteDocument;
- (void)refreshButton;

@end
