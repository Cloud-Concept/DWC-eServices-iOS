//
//  UIImageView+SFAttachment.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFRestAPI.h"

@class SFRestRequest;

@interface UIImageView (SFAttachment) <SFRestDelegate>

@property (nonatomic, strong) SFRestRequest *attachmentSFRequest;

- (void)loadImageFromSFAttachment:(NSString*)attachmentId placeholderImage:(UIImage*)placeholder;

@end
