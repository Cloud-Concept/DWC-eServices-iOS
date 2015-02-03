//
//  TableViewSectionField.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewSectionField : NSObject

@property (nonatomic, strong) NSString *Label;
@property (nonatomic, strong) NSString *Value;

-(id)initTableViewSectionField:(NSString*)fieldLabel FieldValue:(NSString*)FieldValue;

@end
