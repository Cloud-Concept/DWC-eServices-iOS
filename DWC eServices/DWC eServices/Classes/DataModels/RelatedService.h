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
    RelatedServiceTypeCompanyAddressChange = 131072,
    RelatedServiceTypeCompanyNameChange = 262144,
    // added by george
    RelatedServiceTypeRenewPassport = 524288,
    
    // added by george cancel License
    RelatedServiceTypeLicenseCancelation = 1048576,
    // added by george cancel Contract
    RelatedServiceTypeContractCancelation = 2097152,
    
    // added by George (Name Reservation, Director Removal, Capital Change)
    RelatedServiceTypeNameReservation = 4194304,
    RelatedServiceTypeDirectorRemoval = 8388608,
    RelatedServiceTypeCapitalChange = 16777216,
    
    // added by George (renew license, Change License)
        RelatedServiceTypeLicenseRenewActivityChange = 33554432,
        RelatedServiceTypeLicenseChangeActivityChange = 67108864,
    
}RelatedServiceType;

@interface RelatedService : NSObject

@property (nonatomic, strong) NSString *IconName;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Label;
@property (nonatomic) RelatedServiceType Mask;

- (id)initRelatedService:(NSString*)ServiceName Label:(NSString*)ServiceLabel Icon:(NSString*)ServiceIconName Mask:(RelatedServiceType)ServiceMask;

@end
