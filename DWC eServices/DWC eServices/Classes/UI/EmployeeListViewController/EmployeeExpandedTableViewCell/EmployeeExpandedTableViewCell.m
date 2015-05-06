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

- (void)refreshCellForVisa:(Visa *)currentVisa dwcEmployee:(DWCEmployee *)dwcEmployee indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForVisa:currentVisa dwcEmployee:dwcEmployee indexPath:indexPath];
    
    [self refreshRelatedServices:currentVisa dwcEmployee:dwcEmployee];
}

- (void)refreshCellForCard:(CardManagement *)currentCard dwcEmployee:(DWCEmployee *)dwcEmployee indexPath:(NSIndexPath *)indexPath {
    [super refreshCellForCard:currentCard dwcEmployee:dwcEmployee indexPath:indexPath];

    [self refreshRelatedServices:currentCard dwcEmployee:dwcEmployee];
}

- (void)refreshRelatedServices:(NSObject *)currentObject dwcEmployee:(DWCEmployee *)dwcEmployee {
    switch (dwcEmployee.Type) {
        case PermanentEmployee:
            [self refreshPermanentEmployeeServices:(Visa *)currentObject dwcEmployee:dwcEmployee];
            break;
        case VisitVisaEmployee:
            [self refreshVisitVisaServices:(Visa *)currentObject dwcEmployee:dwcEmployee];
            break;
        case ContractorEmployee:
            [self refreshContractorServices:(CardManagement *)currentObject dwcEmployee:dwcEmployee];
            break;
        default:
            break;
    }
    
    servicesMask |= RelatedServiceTypeOpenDetials;
    
    [self renderServicesButtons];
}

- (void)refreshPermanentEmployeeServices:(Visa *)visa dwcEmployee:(DWCEmployee *)dwcEmployee {
    self.relatedServicesScrollView.visaObject = visa;
    self.relatedServicesScrollView.currentDWCEmployee = dwcEmployee;
    
    servicesMask = 0;
    
    if ([visa.validityStatus isEqualToString:@"Issued"])
        servicesMask |= RelatedServiceTypeNewEmployeeNOC;
    
    /*
     if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"]) {
     servicesMask |= RelatedServiceTypeRenewVisa;
     servicesMask |= RelatedServiceTypeCancelVisa;
     }
     */
}

- (void)refreshVisitVisaServices:(Visa *)visa dwcEmployee:(DWCEmployee *)dwcEmployee {
    self.relatedServicesScrollView.visaObject = visa;
    self.relatedServicesScrollView.currentDWCEmployee = dwcEmployee;
    
    servicesMask = 0;
    
    /*
     if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"])
     servicesMask |= RelatedServiceTypeCancelVisa;
     */
}

- (void)refreshContractorServices:(CardManagement *)card dwcEmployee:(DWCEmployee *)dwcEmployee {
    self.relatedServicesScrollView.cardManagementObject = card;
    self.relatedServicesScrollView.currentDWCEmployee = dwcEmployee;
    
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
