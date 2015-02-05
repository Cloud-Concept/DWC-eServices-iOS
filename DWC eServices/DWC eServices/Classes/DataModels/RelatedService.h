//
//  RelatedService.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RelatedServiceTypeNewNOC = 1,
    RelatedServiceTypeNewCard = 2,
    RelatedServiceTypeRenewCard = 4,
    RelatedServiceTypeCancelCard = 8,
    RelatedServiceTypeReplaceCard = 16,
    RelatedServiceTypeNewVisa = 32,
    RelatedServiceTypeRenewVisa = 64,
    RelatedServiceTypeCancelVisa = 128,
}RelatedServiceType;

@interface RelatedService : NSObject

@property (nonatomic, strong) NSString *IconName;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Label;
@property (nonatomic) NSUInteger Mask;

- (id)initRelatedService:(NSString*)ServiceName Label:(NSString*)ServiceLabel Icon:(NSString*)ServiceIconName Mask:(NSUInteger)ServiceMask;

@end
