//
//  ContractorTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "EmployeeTableViewCell.h"
#import "Visa.h"
#import "CardManagement.h"
#import "UIImageView+SFAttachment.h"
//#import "UIView+RoundCorner.h"
#import "UIImageView+Additions.h"
#import "HelperClass.h"

@implementation EmployeeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForVisa:(Visa *)currentVisa dwcEmployee:(DWCEmployee *)dwcEmployee indexPath:(NSIndexPath *)indexPath {
    self.employeeNameLabel.text = currentVisa.applicantFullName;
    
    self.rowOneLabel.text = @"Status:";
    self.rowOneValueLabel.text = currentVisa.validityStatus;
    
    [self.profilePictureImageView loadImageFromSFAttachment:currentVisa.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView maskImageToCircle];
    
    self.rowThreeValueLabel.text = currentVisa.passportNumber;
    
    if ([currentVisa.validityStatus isEqualToString:@"Issued"] || [currentVisa.validityStatus isEqualToString:@"Expired"]) {
        self.rowTwoValueLabel.text = [HelperClass formatDateToString:currentVisa.expiryDate];
        self.rowTwoValueLabel.hidden = NO;
        self.rowTwoLabel.text = @"Visa Expiry:";
        self.rowTwoLabel.hidden = NO;
    }
    else {
        self.rowTwoLabel.hidden = YES;
        self.rowTwoValueLabel.hidden = YES;
    }
    
    [self.rowFourLabel removeFromSuperview];
    [self.rowFourValueLabel removeFromSuperview];
    
    currentIndexPath = indexPath;
}

- (void)refreshCellForCard:(CardManagement *)currentCard dwcEmployee:(DWCEmployee *)dwcEmployee indexPath:(NSIndexPath *)indexPath {
    self.employeeNameLabel.text = currentCard.fullName;
    self.rowOneLabel.text = @"Type:";
    self.rowOneValueLabel.text = currentCard.cardType;
    
    [self.profilePictureImageView loadImageFromSFAttachment:currentCard.personalPhoto
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView maskImageToCircle];
    
    self.rowThreeValueLabel.text = currentCard.passportNumber;
    
    if (currentCard.cardExpiryDate) {
        self.rowTwoLabel.hidden = NO;
        self.rowTwoLabel.text = @"Card Expiry:";
        self.rowTwoValueLabel.hidden = NO;
        self.rowTwoValueLabel.text = [HelperClass formatDateToString:currentCard.cardExpiryDate];
    }
    else {
        self.rowTwoLabel.hidden = YES;
        self.rowTwoValueLabel.hidden = YES;
    }
    
    self.rowFourLabel.text = @"Status:";
    self.rowFourValueLabel.text = currentCard.status;
    
    currentIndexPath = indexPath;
}

@end
