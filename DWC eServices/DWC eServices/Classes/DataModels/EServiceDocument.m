//
//  EServiceDocument.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "EServiceDocument.h"
#import "ServiceDocumentHelperClass.h"

@implementation EServiceDocument

- (id)initEServiceDocument:(NSString*)ServiceId Name:(NSString*)Name Type:(NSString*)Type Language:(NSString*)Language DocumentType:(NSString*)DocumentType {
    if (!(self = [super init]))
        return nil;
    
    self.Id = ServiceId;
    self.name = Name;
    self.nameNoSpace = [Name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    if(![Type isKindOfClass:[NSNull class]])
        self.type = Type;
    
    if(![Language isKindOfClass:[NSNull class]])
        self.language = Language;
    
    if(![DocumentType isKindOfClass:[NSNull class]])
        self.documentType = DocumentType;
    
    return self;
}

- (UIButton *)getDocumentButton:(UIViewController *)parentViewController {
    if (!documentButton) {
        documentButton = [ServiceDocumentHelperClass getButtonForDocument:self Taregt:self Action:@selector(documentButtonClicked)];
        buttonParentViewController = parentViewController;
    }
    
    return documentButton;
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
