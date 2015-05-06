//
//  RelatedService.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RelatedServiceTypeViewMyRequest = 0,
    RelatedServiceTypeNewEmployeeNOC = 1,
    RelatedServiceTypeNewCard = 2,
    RelatedServiceTypeRenewCard = 4,
    RelatedServiceTypeCancelCard = 8,
    RelatedServiceTypeReplaceCard = 16,
    RelatedServiceTypeNewVisa = 32,
    RelatedServiceTypeRenewVisa = 64,
    RelatedServiceTypeCancelVisa = 128,
    RelatedServiceTypeRegistrationDocuments = 256,
    RelatedServiceTypeContractRenewal = 512,
    RelatedServiceTypeLicenseRenewal = 1024,
    RelatedServiceTypeNewCompanyNOC = 2048,
    RelatedServiceTypeOpenDetials = 4096,
    RelatedServiceTypeDocumentTrueCopy = 8192,
    RelatedServiceTypeDocumentPreview = 16384,
    RelatedServiceTypeDocumentEdit = 32768,
    RelatedServiceTypeDocumentDelete = 65536,
}RelatedServiceType;

@interface RelatedService : NSObject

@property (nonatomic, strong) NSString *IconName;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Label;
@property (nonatomic) RelatedServiceType Mask;

- (id)initRelatedService:(NSString*)ServiceName Label:(NSString*)ServiceLabel Icon:(NSString*)ServiceIconName Mask:(RelatedServiceType)ServiceMask;

@end
