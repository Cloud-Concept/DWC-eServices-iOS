//
//  CompanyInfoListShareholderTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyInfoListBaseTableViewCell.h"

@class ShareOwnership;

@interface CompanyInfoListShareholderTableViewCell : CompanyInfoListBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationalityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *passportNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownershipPercentValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfShares;
@property (weak, nonatomic) IBOutlet UILabel *startDateValueLabel;

- (void)refreshCellForShareholder:(ShareOwnership *)shareholder indexPath:(NSIndexPath *)indexPath;

@end
