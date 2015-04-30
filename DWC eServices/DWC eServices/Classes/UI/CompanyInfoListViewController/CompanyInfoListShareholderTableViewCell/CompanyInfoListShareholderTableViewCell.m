//
//  CompanyInfoListShareholderTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListShareholderTableViewCell.h"
#import "ShareOwnership.h"
#import "Account.h"
#import "Passport.h"
#import "HelperClass.h"
#import "UIImageView+SFAttachment.h"
#import "UIImageView+MaskImage.h"

@implementation CompanyInfoListShareholderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath {
    [self refreshCellForShareholder:(ShareOwnership *)currentObject indexPath:currentIndexPath];
}

- (void)refreshCellForShareholder:(ShareOwnership *)shareholder indexPath:(NSIndexPath *)indexPath {
    currentIndexPath = indexPath;
    
    [self.profilePictureImageView loadImageFromSFAttachment:shareholder.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView maskImageToCircle];
    
    self.nameLabel.text = shareholder.shareholder.name;
    self.nationalityValueLabel.text = shareholder.shareholder.nationality;
    self.passportNumberValueLabel.text = shareholder.shareholder.currentPassport.passportNumber;
    self.ownershipPercentValueLabel.text = [NSString stringWithFormat:@"%@ %%",[HelperClass formatNumberToString:shareholder.ownershipOfShare FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]];
    
    self.numberOfShares.text = [HelperClass formatNumberToString:shareholder.noOfShares
                                                     FormatStyle:NSNumberFormatterDecimalStyle
                                           MaximumFractionDigits:2];
    
    self.startDateValueLabel.text = [HelperClass formatDateToString:shareholder.ownershipStartDate];
}

@end
