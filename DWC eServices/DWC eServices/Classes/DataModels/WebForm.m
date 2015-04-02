//
//  WebForm.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/8/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "WebForm.h"
#import "HelperClass.h"
#import "FormField.h"
#import "SFRestAPI+Blocks.h"

@implementation WebForm

- (id)initWebForm:(NSDictionary *)webFormDict {
    if (!(self = [super init])) {
        return nil;
    }
    
    if ([webFormDict isKindOfClass:[NSNull class]] || webFormDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[webFormDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[webFormDict objectForKey:@"Name"]];
    self.formDescription = [HelperClass stringCheckNull:[webFormDict objectForKey:@"Description__c"]];
    self.title = [HelperClass stringCheckNull:[webFormDict objectForKey:@"Title__c"]];
    self.isNotesAttachments = [[HelperClass stringCheckNull:[webFormDict objectForKey:@"isNotesAttachments__c"]] boolValue];
    self.objectLabel = [HelperClass stringCheckNull:[webFormDict objectForKey:@"Object_Label__c"]];
    self.objectName = [HelperClass stringCheckNull:[webFormDict objectForKey:@"Object_Name__c"]];
    
    NSMutableArray *fieldsArray = [[NSMutableArray alloc] init];
    NSDictionary *fieldsDictionary = [webFormDict objectForKey:@"R00N70000002DiOrEAK__r"];
    
    if (![fieldsDictionary isKindOfClass:[NSNull class]]) {
        for (NSDictionary *fieldsDict in [fieldsDictionary objectForKey:@"records"]) {
            [fieldsArray addObject:[[FormField alloc] initFormField:fieldsDict]];
        }
    }
    
    self.formFields = [NSArray arrayWithArray:fieldsArray];
    
    for (FormField *currentFormField in self.formFields) {
        if (!currentFormField.isDependentPicklist)
            continue;
        
        for (FormField *parentFormField in self.formFields) {
            if (![parentFormField.name isEqualToString:currentFormField.controllingField])
                continue;
            
            currentFormField.controllingFormField = parentFormField;
            [parentFormField addChildPicklistFormField:currentFormField];
            break;
        }
    }
    
    return self;
}

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

- (WebForm *)copyDeep {
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
