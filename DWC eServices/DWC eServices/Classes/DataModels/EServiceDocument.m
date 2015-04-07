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

- (id)initEServiceDocument:(NSDictionary *)eServiceDocumentDict {
    if (!(self = [super init]))
        return nil;
    
    if ([eServiceDocumentDict isKindOfClass:[NSNull class]] || eServiceDocumentDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[eServiceDocumentDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[eServiceDocumentDict objectForKey:@"Name"]];
    
    self.nameNoSpace = [self.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    self.nameNoSpace = [self.nameNoSpace stringByReplacingOccurrencesOfString:@"(" withString:@"_"];
    self.nameNoSpace = [self.nameNoSpace stringByReplacingOccurrencesOfString:@")" withString:@"_"];
    
    self.type = [HelperClass stringCheckNull:[eServiceDocumentDict objectForKey:@"Type__c"]];
    self.language = [HelperClass stringCheckNull:[eServiceDocumentDict objectForKey:@"Language__c"]];
    self.authority = [HelperClass stringCheckNull:[eServiceDocumentDict objectForKey:@"Authority__c"]];
    self.documentType = [HelperClass stringCheckNull:[eServiceDocumentDict objectForKey:@"Document_Type__c"]];
    
    return self;
}

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
        documentButton = [ServiceDocumentHelperClass getButtonForDocument:self Taregt:self Action:@selector(documentButtonClicked:)];
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

- (void)documentButtonClicked:(id)sender {
    if (self.attachment) {
        [ServiceDocumentHelperClass confirmDeleteDocument:self
                                           ViewController:buttonParentViewController];
    }
    else {
        [ServiceDocumentHelperClass documentSourceActionSheet:self
                                               ViewController:buttonParentViewController
                                                       Sender:sender];
    }
}

@end
