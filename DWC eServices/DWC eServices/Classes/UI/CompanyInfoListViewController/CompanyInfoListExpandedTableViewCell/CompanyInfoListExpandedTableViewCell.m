//
//  CompanyInfoListExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListExpandedTableViewCell.h"
#import "RelatedServicesBarScrollView.h"
#import "RelatedService.h"

@implementation CompanyInfoListExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForObject:currentObject companyInfo:companyInfo indexPath:indexPath];
    
    switch (companyInfo.Type) {
        case DWCCompanyInfoDirectors:
            [self refreshDirectorServices:(Directorship *)currentObject companyInfo:companyInfo];
            break;
        case DWCCompanyInfoGeneralManagers:
            [self refreshManagerServices:(ManagementMember *)currentObject companyInfo:companyInfo];
            break;
        case DWCCompanyInfoLegalRepresentative:
            [self refreshLegalRepresentativeServices:(LegalRepresentative *)currentObject companyInfo:companyInfo];
            break;
        default:
            break;
    }
}

- (void)refreshCellForDirector:(Directorship *)director companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForDirector:director indexPath:indexPath];
    
    [self refreshDirectorServices:director companyInfo:companyInfo];
}

- (void)refreshCellForManager:(ManagementMember *)manager companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForManager:manager indexPath:indexPath];
    
    [self refreshManagerServices:manager companyInfo:companyInfo];
}

- (void)refreshCellForLegalRepresentative:(LegalRepresentative *)legalRepresentative companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForLegalRepresentative:legalRepresentative indexPath:indexPath];
    
    [self refreshLegalRepresentativeServices:legalRepresentative companyInfo:companyInfo];
}

- (void)refreshDirectorServices:(Directorship *)director companyInfo:(DWCCompanyInfo *)companyInfo{
    self.relatedServicesScrollView.directorObject = director;
    self.relatedServicesScrollView.currentDWCCompanyInfo = companyInfo;
    
    servicesMask = 0;
    servicesMask |= RelatedServiceTypeOpenDetials;
    
    [self renderServicesButtons];
}

- (void)refreshManagerServices:(ManagementMember *)manager companyInfo:(DWCCompanyInfo *)companyInfo{
    self.relatedServicesScrollView.managerObject = manager;
    self.relatedServicesScrollView.currentDWCCompanyInfo = companyInfo;
    
    servicesMask = 0;
    servicesMask |= RelatedServiceTypeOpenDetials;
    
    [self renderServicesButtons];
}

- (void)refreshLegalRepresentativeServices:(LegalRepresentative *)legalRepresentative companyInfo:(DWCCompanyInfo *)companyInfo{
    self.relatedServicesScrollView.legalRepresentativeObject = legalRepresentative;
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
