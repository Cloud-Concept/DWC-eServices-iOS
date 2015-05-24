//
//  DWCSFRequestManager.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DWCSFRequestManager.h"
#import "SFUserAccountManager.h"
#import "SFSmartSyncCacheManager.h"
#import "SFObject.h"

@implementation DWCSFRequestManager

+ (void)writeRecordsArrayToCache:(NSArray *)recordsArray objectType:(NSString *)objectType cacheKey:(NSString *)cacheKey {
    NSMutableArray *sfObjectArray = [NSMutableArray new];
    
    for (NSDictionary *notificationDict in recordsArray) {
        SFObject *sfObject = [[SFObject alloc] initWithDictionary:notificationDict
                                                    forObjectType:objectType];
        [sfObjectArray addObject:sfObject];
    }
    
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    SFSmartSyncCacheManager *cacheManager = [SFSmartSyncCacheManager sharedInstance:accountManager.currentUser];
    
    [cacheManager writeDataToCache:sfObjectArray
                         cacheType:cacheKey
                          cacheKey:cacheKey];
    
}

+ (void)removeCacheForCacheKey:(NSString *)cacheKey {
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    SFSmartSyncCacheManager *cacheManager = [SFSmartSyncCacheManager sharedInstance:accountManager.currentUser];
    
    [cacheManager removeCache:cacheKey cacheKey:cacheKey];
}

+ (SFRestRequest *)performSOQLQuery:(NSString *)query failBlock:(SFRestFailBlock)failBlock completeBlock:(SFRestDictionaryResponseBlock)completeBlock objectClass:(Class)objectClass cacheKey:(NSString *)cacheKey forceRequest:(BOOL)forceRequest {
    
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    SFSmartSyncCacheManager *cacheManager = [SFSmartSyncCacheManager sharedInstance:accountManager.currentUser];
    
    NSDate *date;
    NSArray *sfObjectsArray = [cacheManager readDataWithCacheType:cacheKey
                                                       cacheKey:cacheKey
                                                    cachePolicy:SFDataCachePolicyReturnCacheDataDontReload
                                                    objectClass:objectClass
                                                     cachedTime:&date];
    
    SFRestRequest *request = nil;
    
    if (!sfObjectsArray || forceRequest) {
        request =  [[SFRestAPI sharedInstance] performSOQLQuery:query
                                                      failBlock:failBlock
                                                  completeBlock:completeBlock];
    } else if (sfObjectsArray) {
        NSMutableArray *recordsArray = [NSMutableArray new];
        
        for (SFObject *sfObject in sfObjectsArray) {
            [recordsArray addObject:sfObject.rawData];
        }
        
        completeBlock([NSDictionary dictionaryWithObject:recordsArray forKey:@"records"]);
    }
    else {
        failBlock([NSError new]);
    }

    return request;
}


@end
