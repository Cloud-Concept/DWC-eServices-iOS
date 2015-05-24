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
    return [self initDWCCompanyDocument:docLabel
                            NavBarTitle:navBarTitle
                 DWCCompanyDocumentType:companyDocumentType
                                  Query:query
                               CacheKey:@""
                             ObjectType:@""
                            ObjectClass:nil];
}

- (id)initDWCCompanyDocument:(NSString*)docLabel NavBarTitle:(NSString *)navBarTitle DWCCompanyDocumentType:(DWCCompanyDocumentType)companyDocumentType Query:(NSString*)query CacheKey:(NSString *)cacheKey ObjectType:(NSString *)objectType ObjectClass:(Class) objectClass {
    if (!(self = [super init]))
        return nil;
    
    self.Label = docLabel;
    self.NavBarTitle = navBarTitle;
    self.Type = companyDocumentType;
    self.SOQLQuery = query;
    self.CacheKey = cacheKey;
    self.ObjectType = objectType;
    self.ObjectClass = objectClass;
    
    return self;

}
@end
