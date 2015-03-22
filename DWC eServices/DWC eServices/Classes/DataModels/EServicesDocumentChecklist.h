//
//  EServicesDocumentChecklist.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EServiceAdministration;

@interface EServicesDocumentChecklist : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *templateNameLink;
@property (nonatomic) BOOL availableForPreview;
@property (nonatomic) BOOL originalCanBeRequested;

@property (nonatomic, strong) EServiceAdministration *eServiceAdministration;

- (id)initEServicesDocumentChecklist:(NSDictionary *)documentChecklistDict;

@end
