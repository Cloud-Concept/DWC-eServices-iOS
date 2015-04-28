//
//  EmployeeExpandedTableViewCell.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "EmployeeExpandedTableViewCell.h"
#import "Visa.h"
#import "CardManagement.h"
#import "RelatedService.h"
#import "RelatedServicesBarScrollView.h"

@implementation EmployeeExpandedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellForVisa:(Visa *)currentVisa employeeType:(DWCEmployeeType)employeeType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForVisa:currentVisa employeeType:employeeType indexPath:indexPath];
    
    [self refreshRelatedServices:currentVisa employeeType:employeeType];
}

- (void)refreshCellForCard:(CardManagement *)currentCard employeeType:(DWCEmployeeType)employeeType indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForCard:currentCard employeeType:employeeType indexPath:indexPath];

    [self refreshRelatedServices:currentCard employeeType:employeeType];
}

- (void)refreshRelatedServices:(NSObject *)currentObject employeeType:(DWCEmployeeType)employeeType {
    switch (employeeType) {
        case PermanentEmployee:
            [self refreshPermanentEmployeeServices:(Visa *)currentObject];
            break;
        case VisitVisaEmployee:
            [self refreshVisitVisaServices:(Visa *)currentObject];
            break;
        case ContractorEmployee:
            [self refreshContractorServices:(CardManagement *)currentObject];
            break;
        default:
            break;
    }
    
    [self renderServicesButtons];
}

- (void)refreshPermanentEmployeeServices:(Visa *)visa {
    self.relatedServicesScrollView.visaObject = visa;
    
    servicesMask = 0;
    
    if ([visa.validityStatus isEqualToString:@"Issued"])
        servicesMask |= RelatedServiceTypeNewEmoloyeeNOC;
    
    /*
     if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"]) {
     servicesMask |= RelatedServiceTypeRenewVisa;
     servicesMask |= RelatedServiceTypeCancelVisa;
     }
     */
}

- (void)refreshVisitVisaServices:(Visa *)visa {
    self.relatedServicesScrollView.visaObject = visa;
    
    servicesMask = 0;
    
    /*
     if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"])
     servicesMask |= RelatedServiceTypeCancelVisa;
     */
}

- (void)refreshContractorServices:(CardManagement *)card {
    self.relatedServicesScrollView.cardManagementObject = card;
    
    servicesMask = 0;
    
    if ([card.status isEqualToString:@"Active"]) {
        servicesMask |= RelatedServiceTypeReplaceCard;
        servicesMask |= RelatedServiceTypeCancelCard;
    }
    
    NSTimeInterval daysToExpire = [card.cardExpiryDate timeIntervalSinceNow] / (3600 * 24);
    
    if (([card.status isEqualToString:@"Active"] && daysToExpire <= 7) || [card.status isEqualToString:@"Expired"]) {
        servicesMask |= RelatedServiceTypeRenewCard;
        
    }
}

- (void)renderServicesButtons {
    [self.relatedServicesScrollView displayRelatedServicesForMask:servicesMask parentViewController:self.parentViewController];
    [self.relatedServicesScrollView layoutIfNeeded];
}

@end
