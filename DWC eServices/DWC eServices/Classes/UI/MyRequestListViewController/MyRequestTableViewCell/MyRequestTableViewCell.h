//
//  MyRequestTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Request;

@interface MyRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *requestIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *requestNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestStatusValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestRequestedServiceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestPersonNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestPersonNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *requestStatusIconImageView;

- (void)displayValueForRequest:(Request *)currentRequest;

@end
