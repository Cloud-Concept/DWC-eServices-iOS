//
//  DWCCompanyInfo.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DWCCompanyInfo.h"

@implementation DWCCompanyInfo
- (id)initDWCCompanyInfo:(NSString*)infoLabel NavBarTitle:(NSString *)navBarTitle DWCCompanyInfoType:(DWCCompanyInfoType)companyInfoType {
    return [self initDWCCompanyInfo:infoLabel NavBarTitle:navBarTitle DWCCompanyInfoType:companyInfoType Query:@""];
}

- (id)initDWCCompanyInfo:(NSString*)infoLabel NavBarTitle:(NSString *)navBarTitle DWCCompanyInfoType:(DWCCompanyInfoType)companyInfoType Query:(NSString*)query {
    if (!(self = [super init]))
        return nil;
    
    self.Label = infoLabel;
    self.NavBarTitle = navBarTitle;
    self.Type = companyInfoType;
    self.SOQLQuery = query;
    
    return self;
}

@end
