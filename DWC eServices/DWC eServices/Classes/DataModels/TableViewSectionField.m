//
//  TableViewSectionField.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "TableViewSectionField.h"

@implementation TableViewSectionField

-(id)initTableViewSectionField:(NSString*)fieldLabel FieldValue:(NSString*)FieldValue {
    if (!(self = [super init]))
        return nil;
    
    self.Label = fieldLabel;
    self.Value = FieldValue;
    
    return self;
}

@end
