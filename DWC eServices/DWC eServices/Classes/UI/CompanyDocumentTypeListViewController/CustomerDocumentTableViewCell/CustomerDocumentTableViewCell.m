//
//  CompanyDocumentTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CustomerDocumentTableViewCell.h"
#import "CompanyDocument.h"
#import "HelperClass.h"

@implementation CustomerDocumentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForCompanyDocument:(CompanyDocument *)currentCompanyDocument indexPath:(NSIndexPath *)indexPath {
    currentIndexPath = indexPath;
    
    self.documentNameLabel.text = currentCompanyDocument.name;
    if (![currentCompanyDocument.version isKindOfClass:[NSNull class]])
        self.documentVersionLabel.text = [NSString stringWithFormat:@"V%@", currentCompanyDocument.version];
    else
        self.documentVersionLabel.text = @"V0";
    
    self.documentDateLabel.text = [HelperClass formatDateToString:currentCompanyDocument.createdDate];
}

@end
