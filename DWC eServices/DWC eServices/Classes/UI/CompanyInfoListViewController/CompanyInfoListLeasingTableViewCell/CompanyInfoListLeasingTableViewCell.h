//
//  CompanyInfoListLeasingTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyInfoListBaseTableViewCell.h"

@class TenancyContract;

@interface CompanyInfoListLeasingTableViewCell : CompanyInfoListBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateValueLabel;

- (void)refreshCellForTenancyContract:(TenancyContract *)tenancyContract indexPath:(NSIndexPath *)indexPath;
@end
