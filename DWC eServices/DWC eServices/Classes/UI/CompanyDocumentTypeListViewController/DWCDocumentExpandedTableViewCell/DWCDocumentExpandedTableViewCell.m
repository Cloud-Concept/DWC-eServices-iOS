//
//  DWCDocumentExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DWCDocumentExpandedTableViewCell.h"
#import "EServicesDocumentChecklist.h"
#import "RelatedService.h"
#import "RelatedServicesBarScrollView.h"

@implementation DWCDocumentExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForEServicesDocumentChecklist:(EServicesDocumentChecklist *)currentEServicesDocumentChecklist activeBCTenancyContract:(TenancyContract *)activeBCTenancyContract indexPath:(NSIndexPath *)indexPath {
    
    [super refreshCellForEServicesDocumentChecklist:currentEServicesDocumentChecklist
                            activeBCTenancyContract:activeBCTenancyContract
                                          indexPath:indexPath];
    
    [self refreshCompanyDocumentRelatedServices:currentEServicesDocumentChecklist activeBCTenancyContract:activeBCTenancyContract];
}


- (void)refreshCompanyDocumentRelatedServices:(EServicesDocumentChecklist *)currentEServicesDocumentChecklist activeBCTenancyContract:(TenancyContract *)activeBCTenancyContract {
    self.relatedServicesScrollView.eServicesDocumentChecklistObject = currentEServicesDocumentChecklist;
    self.relatedServicesScrollView.activeBCTenancyContractObject = activeBCTenancyContract;
    
    servicesMask = 0;
    
    if (!activeBCTenancyContract && [currentEServicesDocumentChecklist.templateNameLink containsString:@"<tenId>"]) {
        currentEServicesDocumentChecklist.availableForPreview = NO;
    }
    
    if (currentEServicesDocumentChecklist.availableForPreview)
        servicesMask |= RelatedServiceTypeDocumentPreview;
    
    if (currentEServicesDocumentChecklist.originalCanBeRequested)
        servicesMask |= RelatedServiceTypeDocumentTrueCopy;
    
    [self renderServicesButtons];
}

- (void)renderServicesButtons {
    [self.relatedServicesScrollView displayRelatedServicesForMask:servicesMask parentViewController:self.parentViewController];
    [self.relatedServicesScrollView layoutIfNeeded];
}
@end
