//
//  CompanyInfoListBaseTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListBaseTableViewCell.h"

@implementation CompanyInfoListBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)detailsButtonClicked:(id)sender {
    if (self.delegate) {
        [self.delegate companyTableViewCell:self detailsButtonClickAtIndexPath:currentIndexPath];
    }
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    
}

@end
