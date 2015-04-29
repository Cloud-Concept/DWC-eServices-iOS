//
//  CompanyInfoListTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListTableViewCell.h"
#import "Directorship.h"
#import "ManagementMember.h"
#import "LegalRepresentative.h"
#import "Account.h"
#import "Passport.h"
#import "HelperClass.h"
#import "UIImageView+MaskImage.h"
#import "UIImageView+SFAttachment.h"

@implementation CompanyInfoListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForObject:(NSObject *)currentObject companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath {
    
    switch (companyInfoType) {
        case DWCCompanyInfoDirectors:
            [self refreshCellForDirector:(Directorship *)currentObject indexPath:currentIndexPath];
            break;
        case DWCCompanyInfoGeneralManagers:
            [self refreshCellForManager:(ManagementMember *)currentObject indexPath:currentIndexPath];
            break;
        case DWCCompanyInfoLegalRepresentative:
            [self refreshCellForLegalRepresentative:(LegalRepresentative *)currentObject indexPath:currentIndexPath];
            break;
        default:
            break;
    }
}

- (void)refreshCellForDirector:(Directorship *)director indexPath:(NSIndexPath *)indexPath {
    currentIndexPath = indexPath;
    
    [self.profilePictureImageView loadImageFromSFAttachment:director.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView maskImageToCircle];
    
    self.nameLabel.text = director.director.name;
    self.nationalityValueLabel.text = director.director.nationality;
    self.passportNumberValueLabel.text =  director.director.currentPassport.passportNumber;
    self.roleValueLabel.text = director.roles;
    self.startDateValueLabel.text = [HelperClass formatDateToString:director.directorshipStartDate];
}

- (void)refreshCellForManager:(ManagementMember *)manager indexPath:(NSIndexPath *)indexPath {
    currentIndexPath = indexPath;
    
    [self.profilePictureImageView loadImageFromSFAttachment:manager.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView maskImageToCircle];
    
    self.nameLabel.text = manager.manager.name;
    self.nationalityValueLabel.text = manager.manager.nationality;
    self.passportNumberValueLabel.text =  manager.manager.currentPassport.passportNumber;
    self.roleValueLabel.text = manager.role;
    self.startDateValueLabel.text = [HelperClass formatDateToString:manager.managerStartDate];
}

- (void)refreshCellForLegalRepresentative:(LegalRepresentative *)legalRepresentative indexPath:(NSIndexPath *)indexPath {
    currentIndexPath = indexPath;
    
    [self.profilePictureImageView loadImageFromSFAttachment:legalRepresentative.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView maskImageToCircle];
    
    self.nameLabel.text = legalRepresentative.legalRepresentative.name;
    self.nationalityValueLabel.text = legalRepresentative.legalRepresentative.nationality;
    self.passportNumberValueLabel.text =  legalRepresentative.legalRepresentative.currentPassport.passportNumber;
    self.roleValueLabel.text = legalRepresentative.role;
    self.startDateValueLabel.text = [HelperClass formatDateToString:legalRepresentative.legalRepresentativeStartDate];
}

@end
