//
//  DWCSFRequestManager.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFRestAPI+Blocks.h"

#define kNotificationCacheKey @"NotificationsCacheKey"
#define kCustomerDocumentCacheKey @"CustomerDocumentCacheKey"
#define kDWCDocumentCacheKey @"DWCDocumentCacheKey"
#define kVisitVisaCacheKey @"VisitVisaCacheKey"
#define kAccessCardCacheKey @"AccessCardCacheKey"
#define kPermanentEmployeeCacheKey @"PermanentEmployeeCacheKey"
#define kMyRequestsCacheKey @"MyRequestsCacheKey"

@interface DWCSFRequestManager : NSObject

+ (void)writeRecordsArrayToCache:(NSArray *)recordsArray objectType:(NSString *)objectType cacheKey:(NSString *)cacheKey;
+ (void)removeCacheForCacheKey:(NSString *)cacheKey;
+ (SFRestRequest *)performSOQLQuery:(NSString *)query failBlock:(SFRestFailBlock)failBlock completeBlock:(SFRestDictionaryResponseBlock)completeBlock objectClass:(Class)objectClass cacheKey:(NSString *)cacheKey forceRequest:(BOOL)forceRequest;

@end
