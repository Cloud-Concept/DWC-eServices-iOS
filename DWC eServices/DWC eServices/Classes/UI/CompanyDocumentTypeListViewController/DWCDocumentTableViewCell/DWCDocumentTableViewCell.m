//
//  DWCDocumentTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DWCDocumentTableViewCell.h"
#import "EServicesDocumentChecklist.h"

@implementation DWCDocumentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForEServicesDocumentChecklist:(EServicesDocumentChecklist *)currentEServicesDocumentChecklist activeBCTenancyContract:(TenancyContract *)activeBCTenancyContract indexPath:(NSIndexPath *)indexPath {
    
    currentIndexPath = indexPath;
    
    self.documentNameLabel.text = currentEServicesDocumentChecklist.name;
}
@end
