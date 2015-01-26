//
//  WebForm.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/8/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "WebForm.h"
#import "FormField.h"
#import "SFRestAPI+Blocks.h"

@implementation WebForm

- (id)initWebForm:(NSString*)WebFormID Name:(NSString*)Name Description:(NSString*)Description Title:(NSString*)Title IsNotesAttachments:(BOOL)IsNotesAttachments ObjectLabel:(NSString*)ObjectLabel ObjectName:(NSString*)ObjectName {
    
    if (!(self = [super init])) {
        return nil;
    }
    
    self.Id = WebFormID;
    self.name = Name;
    self.formDescription = Description;
    self.title = Title;
    self.isNotesAttachments = IsNotesAttachments;
    self.objectLabel = ObjectLabel;
    self.objectName = ObjectName;
    
    return self;
}

- (WebForm*)copyDeep {
    WebForm *webForm = [[WebForm alloc] initWebForm:self.Id
                                               Name:self.name
                                        Description:self.description
                                              Title:self.title
                                 IsNotesAttachments:self.isNotesAttachments
                                        ObjectLabel:self.objectLabel
                                         ObjectName:self.objectName];
    
    webForm.formFields = [[NSArray alloc] initWithArray:self.formFields copyItems:YES];
    
    return webForm;
}

@end
