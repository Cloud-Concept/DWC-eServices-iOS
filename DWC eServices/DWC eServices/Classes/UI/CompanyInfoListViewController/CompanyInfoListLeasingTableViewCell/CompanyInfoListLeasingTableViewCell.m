//
//  CompanyInfoListLeasingTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListLeasingTableViewCell.h"
#import "TenancyContract.h"
#import "UIImageView+MaskImage.h"
#import "UIImageView+SFAttachment.h"
#import "HelperClass.h"

@implementation CompanyInfoListLeasingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    
    [self refreshCellForTenancyContract:(TenancyContract *)currentObject indexPath:currentIndexPath];
}

- (void)refreshCellForTenancyContract:(TenancyContract *)tenancyContract indexPath:(NSIndexPath *)indexPath {
    currentIndexPath = indexPath;
    
    [self.profilePictureImageView loadImageFromSFAttachment:tenancyContract.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView maskImageToCircle];
    
    self.nameLabel.text = tenancyContract.name;
    //self.unitNameValueLabel.text = tenancyContract;
    self.contractTypeValueLabel.text = tenancyContract.contractType;
    self.statusValueLabel.text = tenancyContract.status;
    self.expiryDateValueLabel.text = [HelperClass formatDateToString:tenancyContract.contractExpiryDate];
    
}

@end
