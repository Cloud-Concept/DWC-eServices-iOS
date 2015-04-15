//
//  DWCCompanyDocument.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DWCCompanyDocument.h"

@implementation DWCCompanyDocument

- (id)initDWCCompanyDocument:(NSString*)docLabel NavBarTitle:(NSString *)navBarTitle DWCCompanyDocumentType:(DWCCompanyDocumentType)companyDocumentType Query:(NSString*)query {
    if (!(self = [super init]))
        return nil;
    
    self.Label = docLabel;
    self.NavBarTitle = navBarTitle;
    self.Type = companyDocumentType;
    self.SOQLQuery = query;
    
    return self;

}
@end
