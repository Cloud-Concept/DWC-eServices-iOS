//
//  UIImageView+SFAttachment.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIImageView+SFAttachment.h"
#import "SFRestAPI+Blocks.h"
#import <objc/runtime.h>


static const char *kAttachmentSFRequestKey = "kAttachmentSFRequestKey";

@implementation UIImageView (SFAttachment)

@dynamic attachmentSFRequest;

- (void)loadImageFromSFAttachment:(NSString*)attachmentId placeholderImage:(UIImage*)placeholder {
    
    self.image = placeholder;
    
    if (self.attachmentSFRequest)
        [self.attachmentSFRequest cancel];
    
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

- (SFRestRequest*)attachmentSFRequest {
    return objc_getAssociatedObject(self, kAttachmentSFRequestKey);
}


#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSData *imageData = jsonResponse;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![imageData isKindOfClass:[NSNull class]])
            self.image = [UIImage imageWithData:imageData];
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
