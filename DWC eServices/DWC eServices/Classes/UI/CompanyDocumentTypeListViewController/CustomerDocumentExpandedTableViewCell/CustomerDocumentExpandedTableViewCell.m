//
//  CustomerDocumentExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CustomerDocumentExpandedTableViewCell.h"
#import "CompanyDocument.h"
#import "RelatedService.h"
#import "RelatedServicesBarScrollView.h"

@implementation CustomerDocumentExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForCompanyDocument:(CompanyDocument *)currentCompanyDocument indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForCompanyDocument:currentCompanyDocument indexPath:indexPath];
    
    [self refreshCompanyDocumentRelatedServices:currentCompanyDocument];
}

- (void)refreshCompanyDocumentRelatedServices:(CompanyDocument *)currentCompanyDocument {
    self.relatedServicesScrollView.companyDocumentObject = currentCompanyDocument;
    
    servicesMask = 0;
    
    servicesMask |= RelatedServiceTypeDocumentEdit;
    
    if (![currentCompanyDocument.attachmentId isEqualToString:@""])
        servicesMask |= RelatedServiceTypeDocumentPreview;
    
    /*
    if (currentCompanyDocument.customerDocument)
        servicesMask |= RelatedServiceTypeDocumentDelete;
    */
    
    [self renderServicesButtons];
}

- (void)renderServicesButtons {
    [self.relatedServicesScrollView displayRelatedServicesForMask:servicesMask parentViewController:self.parentViewController];
    [self.relatedServicesScrollView layoutIfNeeded];
}



@end
