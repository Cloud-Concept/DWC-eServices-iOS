//
//  TableViewSection.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewSection : NSObject

@property (nonatomic, strong) NSString *Label;
@property (nonatomic, strong) NSArray *FieldsArray;

-(id)initTableViewSection:(NSString*)SectionLabel Fields:(NSArray*)Fields;

@end
