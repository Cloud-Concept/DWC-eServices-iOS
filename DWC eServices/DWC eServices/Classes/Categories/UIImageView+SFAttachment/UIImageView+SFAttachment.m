//
//  UIImageView+SFAttachment.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIImageView+SFAttachment.h"
#import "SFRestAPI+Blocks.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import <objc/runtime.h>

static const char *kAttachmentSFRequestKey = "kAttachmentSFRequestKey";
static const char *kAttachmentId = "kAttachmentId";

@implementation UIImageView (SFAttachment)

@dynamic attachmentSFRequest;
@dynamic attachmentId;

- (void)loadImageFromSFAttachment:(NSString*)attachmentId placeholderImage:(UIImage*)placeholder {
    
    self.attachmentId = attachmentId;
    
    self.image = placeholder;
    
    if (self.attachmentSFRequest)
        [self.attachmentSFRequest cancel];
    
    NSString *key = [self.attachmentId MD5Hash];
    NSData *imageData = [FTWCache objectForKey:key];
    if (imageData) {
        [self setImageWithData:imageData];
        return;
    }
    
    // Manually set up request object
    if (![attachmentId isKindOfClass:[NSNull class]] && ![attachmentId isEqualToString:@""]) {
        self.attachmentSFRequest = [[SFRestRequest alloc] init];
        self.attachmentSFRequest.endpoint = [NSString stringWithFormat:@"/services/data/v31.0/sobjects/Attachment/%@/Body", attachmentId];
        self.attachmentSFRequest.method = SFRestMethodGET;
        self.attachmentSFRequest.path = [NSString stringWithFormat:@"/services/data/v31.0/sobjects/Attachment/%@/Body", attachmentId];
        
        [[SFRestAPI sharedInstance] send:self.attachmentSFRequest delegate:self];
    }
}

- (void)setAttachmentSFRequest:(SFRestRequest *)value {
    objc_setAssociatedObject(self, kAttachmentSFRequestKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAttachmentId:(NSString *)attachmentId {
    objc_setAssociatedObject(self, kAttachmentId, attachmentId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SFRestRequest*)attachmentSFRequest {
    return objc_getAssociatedObject(self, kAttachmentSFRequestKey);
}

- (NSString *)attachmentId {
    return objc_getAssociatedObject(self, kAttachmentId);
}

- (void)setImageWithData:(NSData *)imageData {
    if (![imageData isKindOfClass:[NSNull class]]) {
        self.image = [UIImage imageWithData:imageData];
        
        NSString *key = [self.attachmentId MD5Hash];
        [FTWCache setObject:imageData forKey:key];
    }
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSData *imageData = jsonResponse;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImageWithData:imageData];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

@end
