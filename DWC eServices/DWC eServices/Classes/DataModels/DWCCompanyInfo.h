//
//  DWCCompanyInfo.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DWCCompanyInfoCompany,
    DWCCompanyInfoLicenseInfo,
    DWCCompanyInfoLeasingInfo,
    DWCCompanyInfoShareholders,
    DWCCompanyInfoDirectors,
    DWCCompanyInfoGeneralManagers,
    DWCCompanyInfoLegalRepresentative,
} DWCCompanyInfoType;

@interface DWCCompanyInfo : NSObject

@property (nonatomic, strong) NSString *Label;
@property (nonatomic, strong) NSString *SOQLQuery;
@property (nonatomic, strong) NSString *NavBarTitle;
@property (nonatomic) DWCCompanyInfoType Type;

- (id)initDWCCompanyInfo:(NSString*)infoLabel NavBarTitle:(NSString *)navBarTitle DWCCompanyInfoType:(DWCCompanyInfoType)companyInfoType;
- (id)initDWCCompanyInfo:(NSString*)infoLabel NavBarTitle:(NSString *)navBarTitle DWCCompanyInfoType:(DWCCompanyInfoType)companyInfoType Query:(NSString*)query;


@end
