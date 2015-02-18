//
//  EServiceDocument.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "EServiceDocument.h"
#import "ServiceDocumentHelperClass.h"
#import "HelperClass.h"

@implementation EServiceDocument

- (id)initEServiceDocument:(NSString*)ServiceId Name:(NSString*)Name Type:(NSString*)Type Language:(NSString*)Language Authority:(NSString*)Authority DocumentType:(NSString*)DocumentType {
    if (!(self = [super init]))
        return nil;
    
    self.Id = ServiceId;
    self.name = Name;
    self.nameNoSpace = [Name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    self.authority = [HelperClass stringCheckNull:Authority];
    self.type = [HelperClass stringCheckNull:Type];
    self.language = [HelperClass stringCheckNull:Language];
    self.documentType = [HelperClass stringCheckNull:DocumentType];
    
    return self;
}

- (UIButton *)getDocumentButton:(UIViewController *)parentViewController {
    if (!documentButton) {
        documentButton = [ServiceDocumentHelperClass getButtonForDocument:self Taregt:self Action:@selector(documentButtonClicked)];
        buttonParentViewController = parentViewController;
    }
    
    return documentButton;
}

- (void)deleteDocumentAndButton {
    [self deleteDocument];
    documentButton = nil;
}

- (void)deleteDocument {
    self.attachment = nil;
    [self refreshButton];
}

- (void)refreshButton {
    [ServiceDocumentHelperClass refreshButton:documentButton forDocument:self];
}

- (void)documentButtonClicked {
    if (self.attachment) {
        [ServiceDocumentHelperClass confirmDeleteDocument:self
                                           ViewController:buttonParentViewController];
    }
    else {
        [ServiceDocumentHelperClass documentSourceActionSheet:self
                                               ViewController:buttonParentViewController];
    }
}

@end
