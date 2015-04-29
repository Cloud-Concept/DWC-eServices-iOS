//
//  CompanyInfoListLeasingExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListLeasingExpandedTableViewCell.h"
#import "RelatedServicesBarScrollView.h"
#import "TenancyContract.h"
#import "RelatedService.h"

@implementation CompanyInfoListLeasingExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForObject:currentObject companyInfoType:companyInfoType indexPath:currentIndexPath];
    
    [self refreshTenancyContractServices:(TenancyContract *)currentObject];
}

- (void)refreshCellForTenancyContract:(TenancyContract *)tenancyContract indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForTenancyContract:tenancyContract indexPath:indexPath];
    
    [self refreshTenancyContractServices:tenancyContract];
}

- (void)refreshTenancyContractServices:(TenancyContract *)tenancyContract {
    self.relatedServicesScrollView.contractObject = tenancyContract;
    
    servicesMask = 0;
    NSTimeInterval daysToExpire = [tenancyContract.contractExpiryDate timeIntervalSinceNow] / (3600 * 24);
    if (tenancyContract.isBCContract && daysToExpire <= 60)
        servicesMask |= RelatedServiceTypeContractRenewal;
    
    [self renderServicesButtons];
}

- (void)renderServicesButtons {
    [self.relatedServicesScrollView displayRelatedServicesForMask:servicesMask parentViewController:self.parentViewController];
    [self.relatedServicesScrollView layoutIfNeeded];
}

@end
