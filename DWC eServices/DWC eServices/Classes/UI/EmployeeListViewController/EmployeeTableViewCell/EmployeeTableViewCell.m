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
#import "UIView+RoundCorner.h"
#import "HelperClass.h"

@implementation EmployeeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForVisa:(Visa *)currentVisa employeeType:(DWCEmployeeType)employeeType indexPath:(NSIndexPath *)indexPath {
    self.employeeNameLabel.text = currentVisa.applicantFullName;
    
    self.rowOneLabel.text = @"Status";
    self.rowOneValueLabel.text = currentVisa.validityStatus;
    
    [self.profilePictureImageView loadImageFromSFAttachment:currentVisa.personalPhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView createRoundBorderedWithRadius:3.0 Shadows:NO ClipToBounds:YES];
    
    if ([currentVisa.validityStatus isEqualToString:@"Issued"] || [currentVisa.validityStatus isEqualToString:@"Expired"]) {
        self.rowTwoValueLabel.text = [HelperClass formatDateToString:currentVisa.expiryDate];
        self.rowTwoValueLabel.hidden = NO;
        self.rowTwoLabel.text = @"Expiry";
        self.rowTwoLabel.hidden = NO;
    }
    else {
        self.rowTwoLabel.hidden = YES;
        self.rowTwoValueLabel.hidden = YES;
    }
    
    currentIndexPath = indexPath;
}

- (void)refreshCellForCard:(CardManagement *)currentCard employeeType:(DWCEmployeeType)employeeType indexPath:(NSIndexPath *)indexPath {
    self.employeeNameLabel.text = currentCard.fullName;
    self.rowOneLabel.text = @"Type";
    self.rowOneValueLabel.text = currentCard.cardType;
    
    [self.profilePictureImageView loadImageFromSFAttachment:currentCard.personalPhoto
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView createRoundBorderedWithRadius:3.0 Shadows:NO ClipToBounds:YES];
    
    if (currentCard.cardExpiryDate) {
        self.rowTwoLabel.hidden = NO;
        self.rowTwoLabel.text = @"Expiry";
        self.rowTwoValueLabel.hidden = NO;
        self.rowTwoValueLabel.text = [HelperClass formatDateToString:currentCard.cardExpiryDate];
    }
    else {
        self.rowTwoLabel.hidden = YES;
        self.rowTwoValueLabel.hidden = YES;
    }
    
    currentIndexPath = indexPath;
}

-(IBAction)detailsButtonClicked:(id)sender {
    if (self.delegate) {
        [self.delegate employeeTableViewCell:self detailsButtonClickAtIndexPath:currentIndexPath];
    }
}

@end
