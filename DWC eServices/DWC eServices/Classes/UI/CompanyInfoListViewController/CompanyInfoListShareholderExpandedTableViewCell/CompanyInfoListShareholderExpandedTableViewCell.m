//
//  CompanyInfoListShareholderExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListShareholderExpandedTableViewCell.h"
#import "RelatedServicesBarScrollView.h"
#import "RelatedService.h"

@implementation CompanyInfoListShareholderExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForObject:currentObject companyInfo:companyInfo indexPath:currentIndexPath];
    
    [self refreshShareholderServices:(ShareOwnership *)currentObject companyInfo:companyInfo];
}

- (void)refreshCellForShareholder:(ShareOwnership *)shareholder companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForShareholder:shareholder indexPath:indexPath];
    
    [self refreshShareholderServices:shareholder companyInfo:companyInfo];
}

- (void)refreshShareholderServices:(ShareOwnership *)shareholder companyInfo:(DWCCompanyInfo *)companyInfo {
    self.relatedServicesScrollView.shareholderObject = shareholder;
    self.relatedServicesScrollView.currentDWCCompanyInfo = companyInfo;
    
    servicesMask = 0;
    
    servicesMask |= RelatedServiceTypeOpenDetials;
    
    [self renderServicesButtons];
}

- (void)renderServicesButtons {
    [self.relatedServicesScrollView displayRelatedServicesForMask:servicesMask parentViewController:self.parentViewController];
    [self.relatedServicesScrollView layoutIfNeeded];
}

@end
