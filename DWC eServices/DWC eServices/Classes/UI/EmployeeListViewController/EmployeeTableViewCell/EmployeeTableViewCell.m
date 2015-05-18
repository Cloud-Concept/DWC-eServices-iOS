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
    
    self.rowTwoValueLabel.text = currentVisa.passportNumber;
    
    if ([currentVisa.validityStatus isEqualToString:@"Issued"] || [currentVisa.validityStatus isEqualToString:@"Expired"]) {
        self.rowThreeValueLabel.text = [HelperClass formatDateToString:currentVisa.expiryDate];
        self.rowThreeValueLabel.hidden = NO;
        self.rowThreeLabel.text = @"Visa Expiry:";
        self.rowThreeLabel.hidden = NO;
    }
    else {
        self.rowThreeLabel.hidden = YES;
        self.rowThreeValueLabel.hidden = YES;
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
    
    self.rowTwoValueLabel.text = currentCard.passportNumber;
    
    self.rowThreeLabel.text = @"Status:";
    self.rowThreeValueLabel.text = currentCard.status;
    
    if (currentCard.cardExpiryDate) {
        self.rowFourLabel.hidden = NO;
        self.rowFourLabel.text = @"Card Expiry:";
        self.rowFourValueLabel.hidden = NO;
        self.rowFourValueLabel.text = [HelperClass formatDateToString:currentCard.cardExpiryDate];
    }
    else {
        self.rowFourLabel.hidden = YES;
        self.rowFourValueLabel.hidden = YES;
    }
    
    
    
    currentIndexPath = indexPath;
}

@end
