//
//  TableViewSection.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "TableViewSection.h"

@implementation TableViewSection

-(id)initTableViewSection:(NSString*)SectionLabel Fields:(NSArray*)Fields {
    if (!(self = [super init]))
        return nil;
    
    self.Label = SectionLabel;
    self.FieldsArray = Fields;
    
    return self;
}

@end
