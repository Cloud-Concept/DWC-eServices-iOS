//
//  WebForm.h
//  DWCTest
//
//  Created by Mina Zaklama on 12/8/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebForm : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *formDescription;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) BOOL isNotesAttachments;
@property (strong, nonatomic) NSString *objectLabel;
@property (strong, nonatomic) NSString *objectName;
@property (strong, nonatomic) NSArray *formFields;

- (id)initWebForm:(NSString*)WebFormID Name:(NSString*)Name Description:(NSString*)Description Title:(NSString*)Title IsNotesAttachments:(BOOL)IsNotesAttachments ObjectLabel:(NSString*)ObjectLabel ObjectName:(NSString*)ObjectName;

- (WebForm*)copyDeep;
@end
