//
//  CompanyInfoListExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListExpandedTableViewCell.h"
#import "RelatedServicesBarScrollView.h"

@implementation CompanyInfoListExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForObject:currentObject companyInfoType:companyInfoType indexPath:indexPath];
    
    switch (companyInfoType) {
        case DWCCompanyInfoDirectors:
            [self refreshDirectorServices:(Directorship *)currentObject];
            break;
        case DWCCompanyInfoGeneralManagers:
            [self refreshManagerServices:(ManagementMember *)currentObject];
            break;
        case DWCCompanyInfoLegalRepresentative:
            [self refreshLegalRepresentativeServices:(LegalRepresentative *)currentObject];
            break;
        default:
            break;
    }
}

- (void)refreshCellForDirector:(Directorship *)director companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForDirector:director indexPath:indexPath];
    
    [self refreshDirectorServices:director];
}

- (void)refreshCellForManager:(ManagementMember *)manager companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForManager:manager indexPath:indexPath];
    
    [self refreshManagerServices:manager];
}

- (void)refreshCellForLegalRepresentative:(LegalRepresentative *)legalRepresentative companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForLegalRepresentative:legalRepresentative indexPath:indexPath];
    
    [self refreshLegalRepresentativeServices:legalRepresentative];
}

- (void)refreshDirectorServices:(Directorship *)director {
    //self.relatedServicesScrollView
    
    servicesMask = 0;
    [self renderServicesButtons];
}

- (void)refreshManagerServices:(ManagementMember *)manager {
    servicesMask = 0;
    [self renderServicesButtons];
}

- (void)refreshLegalRepresentativeServices:(LegalRepresentative *)legalRepresentative {
    servicesMask = 0;
    [self renderServicesButtons];
}

- (void)renderServicesButtons {
    [self.relatedServicesScrollView displayRelatedServicesForMask:servicesMask parentViewController:self.parentViewController];
    [self.relatedServicesScrollView layoutIfNeeded];
}

@end
