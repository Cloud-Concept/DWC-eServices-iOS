//
//  DWCCompanyDocument.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DWCCompanyDocumentTypeDWCDocument,
    DWCCompanyDocumentTypeCustomerDocument,
} DWCCompanyDocumentType;


@interface DWCCompanyDocument : NSObject

@property (nonatomic, strong) NSString *Label;
@property (nonatomic, strong) NSString *SOQLQuery;
@property (nonatomic) DWCCompanyDocumentType Type;


- (id)initDWCCompanyDocument:(NSString*)docLabel DWCCompanyDocumentType:(DWCCompanyDocumentType)companyDocumentType Query:(NSString*)query;


@end
