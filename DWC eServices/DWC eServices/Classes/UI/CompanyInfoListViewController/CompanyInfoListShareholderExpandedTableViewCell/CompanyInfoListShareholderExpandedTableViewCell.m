//
//  CompanyInfoListShareholderExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListShareholderExpandedTableViewCell.h"
#import "RelatedServicesBarScrollView.h"

@implementation CompanyInfoListShareholderExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForObject:currentObject companyInfoType:companyInfoType indexPath:currentIndexPath];
    
    [self refreshShareholderServices:(ShareOwnership *)currentObject];
}

- (void)refreshCellForShareholder:(ShareOwnership *)shareholder companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForShareholder:shareholder indexPath:indexPath];
    
    [self refreshShareholderServices:shareholder];
}

- (void)refreshShareholderServices:(ShareOwnership *)shareholder {
    servicesMask = 0;
    
    [self renderServicesButtons];
}

- (void)renderServicesButtons {
    [self.relatedServicesScrollView displayRelatedServicesForMask:servicesMask parentViewController:self.parentViewController];
    [self.relatedServicesScrollView layoutIfNeeded];
}

@end
