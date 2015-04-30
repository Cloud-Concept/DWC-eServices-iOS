//
//  RelatedServicesTabBar.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RelatedServicesBarScrollView.h"
#import "RelatedService.h"
#import "HelperClass.h"
#import "BaseServicesViewController.h"
#import "RecordMainDetailsViewController.h"
#import "TableViewSection.h"
#import "TableViewSectionField.h"
#import "Visa.h"
#import "CardManagement.h"
#import "Country.h"
#import "DWCCompanyInfo.h"
#import "DWCEmployee.h"
#import "ShareOwnership.h"
#import "Account.h"
#import "Passport.h"
#import "ManagementMember.h"
#import "LegalRepresentative.h"
#import "Directorship.h"
#import "TenancyContract.h"
#import "ContractLineItem.h"
#import "TenancyContractPayment.h"
#import "InventoryUnit.h"

@implementation RelatedServicesBarScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initRelatedServices {
    NSMutableArray *relatedServicesMutableArray = [NSMutableArray new];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_NOC"
                                                                                Label:@"New NOC"
                                                                                 Icon:@"Related Service Employee NOC Icon"
                                                                                 Mask:RelatedServiceTypeNewEmoloyeeNOC]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_NOC_Company"
                                                                                Label:@"New NOC"
                                                                                 Icon:@"Related Service Company NOC Icon"
                                                                                 Mask:RelatedServiceTypeNewCompanyNOC]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_Card"
                                                                                Label:@"New Card"
                                                                                 Icon:@"Related Service New Card Icon"
                                                                                 Mask:RelatedServiceTypeNewCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_Card"
                                                                                Label:@"Renew Card"
                                                                                 Icon:@"Related Service Renew Card Icon"
                                                                                 Mask:RelatedServiceTypeRenewCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Cancel_Card"
                                                                                Label:@"Cancel Card"
                                                                                 Icon:@"Related Service Cancel Card Icon"
                                                                                 Mask:RelatedServiceTypeCancelCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Replace_Card"
                                                                                Label:@"Replace Card"
                                                                                 Icon:@"Related Service Replace Card Icon Icon"
                                                                                 Mask:RelatedServiceTypeReplaceCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_Visa"
                                                                                Label:@"New Visa"
                                                                                 Icon:@"Related Service New Visa Icon"
                                                                                 Mask:RelatedServiceTypeNewVisa]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_Visa"
                                                                                Label:@"Renew Visa"
                                                                                 Icon:@"Related Service Renew Visa Icon"
                                                                                 Mask:RelatedServiceTypeRenewVisa]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Cancel_Visa"
                                                                                Label:@"Cancel Visa"
                                                                                 Icon:@"Related Service Cancel Visa Icon"
                                                                                 Mask:RelatedServiceTypeCancelVisa]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_Contract"
                                                                                Label:@"Renew Contract"
                                                                                 Icon:@"Related Service More Icon"
                                                                                 Mask:RelatedServiceTypeContractRenewal]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_License"
                                                                                Label:@"Renew License"
                                                                                 Icon:@"Related Service More Icon"
                                                                                 Mask:RelatedServiceTypeLicenseRenewal]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Show_Details"
                                                                                Label:@"Show Details"
                                                                                 Icon:@"Related Service More Icon"
                                                                                 Mask:RelatedServiceTypeOpenDetials]];
    
    relatedServicesArray = relatedServicesMutableArray;
}

- (void)removeAllSubviews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)displayRelatedServicesForMask:(NSUInteger)relatedServicesMask parentViewController:(UIViewController *)viewController {
    parentViewController = viewController;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self removeAllSubviews];
    [self initRelatedServices];
    
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    NSMutableArray *displayedServiesArray = [NSMutableArray new];
    
    for (RelatedService *service in relatedServicesArray) {
        
        if ((relatedServicesMask & service.Mask) != 0) {
            [displayedServiesArray addObject:service];
        }
        else {
            continue;
        }
        
        UIButton *button = [UIButton new];
        [viewsDictionary setObject:button forKey:service.Name];
        
        [button setTag:service.Mask];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:service.Label forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:service.IconName] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"CorisandeLight" size:10.0f]];
        [button setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        
        [button addTarget:self action:@selector(serviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [HelperClass setupButtonWithTextUnderImage:button];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:button];
    }
    
    NSDictionary *metrics = @{@"buttonHeight": @kRelatedServicesScrollViewHeight,
                              @"buttonWidth": @75,
                              @"leftMargin": @8,
                              @"rightMargin": @8,
                              @"topMargin": @0,
                              @"bottomMargin": @0
                              };
    
    for (NSInteger index = 0; index < displayedServiesArray.count; index++) {
        RelatedService *currentRelatedService = [displayedServiesArray objectAtIndex:index];
        RelatedService *previousRelatedService = nil;
        
        
        NSString *heightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", currentRelatedService.Name];
        NSArray *field_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:heightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        
        
        NSString *widthtRule = [NSString stringWithFormat:@"H:[%@(buttonWidth)]", currentRelatedService.Name];
        NSArray *field_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:widthtRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
         
        
        [self addConstraints:field_constraint_V];
        [self addConstraints:field_constraint_H];
        
        if(index != 0)
            previousRelatedService = [displayedServiesArray objectAtIndex:index - 1];
        
        NSString *verticalRule = [NSString stringWithFormat:@"V:|-topMargin-[%@]-bottomMargin-|", currentRelatedService.Name];
        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        NSMutableString *horizontalRule = [NSMutableString stringWithString:@"H:"];
        
        if (previousRelatedService == nil)
        {
            [horizontalRule appendFormat:@"|-leftMargin-"];
        }
        else
        {
            [horizontalRule appendFormat:@"[%@]-", previousRelatedService.Name];
        }
        
        [horizontalRule appendFormat:@"[%@]", currentRelatedService.Name];
        
        if (index == displayedServiesArray.count - 1) {
            [horizontalRule appendString:@"-rightMargin-|"];
        }
        
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        [self addConstraints:constraint_POS_H];
        [self addConstraints:constraint_POS_V];
    }
}

- (void)serviceButtonClicked:(UIButton*)sender {
    
    switch (sender.tag) {
        case RelatedServiceTypeNewEmoloyeeNOC:
            [self relatedServiceNewEmployeeNOCButtonClicked];
            break;
        case RelatedServiceTypeNewCompanyNOC:
            [self relatedServiceNewCompanyNOCButtonClicked];
            break;
        case RelatedServiceTypeNewCard:
            [self relatedServiceNewCardButtonClicked];
            break;
        case RelatedServiceTypeRenewCard:
            [self relatedServiceRenewCardButtonClicked];
            break;
        case RelatedServiceTypeCancelCard:
            [self relatedServiceCancelCardButtonClicked];
            break;
        case RelatedServiceTypeReplaceCard:
            [self relatedServiceReplaceCardButtonClicked];
            break;
        case RelatedServiceTypeNewVisa:
            [self relatedServiceNewVisaButtonClicked];
            break;
        case RelatedServiceTypeRenewVisa:
            [self relatedServiceRenewVisaButtonClicked];
            break;
        case RelatedServiceTypeCancelVisa:
            [self relatedServiceCancelVisaButtonClicked];
            break;
        case RelatedServiceTypeContractRenewal:
            [self relatedServiceContractRenewalButtonClicked];
            break;
        case RelatedServiceTypeLicenseRenewal:
            [self relatedServiceLicenseRenewalButtonClicked];
            break;
        case RelatedServiceTypeOpenDetials:
            [self relatedServiceOpenDetialsButtonClicked];
            break;
        default:
            break;
    }
}

- (void)openNewNOCFlow:(RelatedServiceType)serviceType {
    if (!parentViewController)
        return;
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = serviceType;
    baseServicesVC.currentVisaObject = self.visaObject;
    baseServicesVC.createServiceRecord = YES;
    [parentViewController.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)openCardManagementFlow:(RelatedServiceType)serviceType CreateServiceRecord:(BOOL)CreateServiceRecord {
    if (!parentViewController)
        return;
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = serviceType;
    baseServicesVC.currentCardManagement = self.cardManagementObject;
    baseServicesVC.createServiceRecord = CreateServiceRecord;
    [parentViewController.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)openContractRenewalFlow {
    if (!parentViewController)
        return;
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeContractRenewal;
    baseServicesVC.currentContract = self.contractObject;
    baseServicesVC.createServiceRecord = NO;
    [parentViewController.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)openLicenseRenewalFlow {
    if (!parentViewController)
        return;
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeLicenseRenewal;
    baseServicesVC.currentLicense = self.licenseObject;
    baseServicesVC.createServiceRecord = NO;
    [parentViewController.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)relatedServiceNewEmployeeNOCButtonClicked {
    [self openNewNOCFlow:RelatedServiceTypeNewEmoloyeeNOC];
}

- (void)relatedServiceNewCompanyNOCButtonClicked {
    [self openNewNOCFlow:RelatedServiceTypeNewCompanyNOC];
}

- (void)relatedServiceNewCardButtonClicked {
    
}

- (void)relatedServiceRenewCardButtonClicked {
    [self openCardManagementFlow:RelatedServiceTypeRenewCard CreateServiceRecord:YES];
}

- (void)relatedServiceCancelCardButtonClicked {
    [self openCardManagementFlow:RelatedServiceTypeCancelCard CreateServiceRecord:NO];
}

- (void)relatedServiceReplaceCardButtonClicked {
    [self openCardManagementFlow:RelatedServiceTypeReplaceCard CreateServiceRecord:YES];
}

- (void)relatedServiceNewVisaButtonClicked {
    
}

- (void)relatedServiceRenewVisaButtonClicked {
    
}

- (void)relatedServiceCancelVisaButtonClicked {
    
}

- (void)relatedServiceContractRenewalButtonClicked {
    [self openContractRenewalFlow];
}

- (void)relatedServiceLicenseRenewalButtonClicked {
    [self openLicenseRenewalFlow];
}

- (void)relatedServiceOpenDetialsButtonClicked {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RecordMainDetailsViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    
    if (self.currentDWCEmployee) {
        recordMainVC.NavBarTitle = self.currentDWCEmployee.NavBarTitle;
        
        switch (self.currentDWCEmployee.Type) {
            case PermanentEmployee:
                [self configureRecordMainViewController:recordMainVC ForPermanentEmployee:self.visaObject];
                break;
            case VisitVisaEmployee:
                [self configureRecordMainViewController:recordMainVC ForVisitVisa:self.visaObject];
                break;
            case ContractorEmployee:
                [self configureRecordMainViewController:recordMainVC ForContractor:self.cardManagementObject];
                break;
            default:
                break;
        }
    }
    
    if (self.currentDWCCompanyInfo) {
        recordMainVC.NavBarTitle = self.currentDWCCompanyInfo.NavBarTitle;
        
        switch (self.currentDWCCompanyInfo.Type) {
            case DWCCompanyInfoShareholders:
                [self configureRecordMainViewController:recordMainVC ForShareholder:self.shareholderObject];
                break;
            case DWCCompanyInfoGeneralManagers:
                [self configureRecordMainViewController:recordMainVC ForManager:self.managerObject];
                break;
            case DWCCompanyInfoDirectors:
                [self configureRecordMainViewController:recordMainVC ForDirector:self.directorObject];
                break;
            case DWCCompanyInfoLegalRepresentative:
                [self configureRecordMainViewController:recordMainVC ForLegalRepresentative:self.legalRepresentativeObject];
                break;
            case DWCCompanyInfoLeasingInfo:
                [self configureRecordMainViewController:recordMainVC ForLeasingInfo:self.contractObject];
                break;
            default:
                break;
        }
    }
    
    [parentViewController.navigationController pushViewController:recordMainVC animated:YES];
}



- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForPermanentEmployee:(Visa*)visa {
    recordVC.visaObject = visa;
    recordVC.NameValue = visa.applicantFullName;
    recordVC.PhotoId = visa.personalPhotoId;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Employee ID"
                                                                         FieldValue:visa.employeeID]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Gender"
                                                                         FieldValue:visa.applicantGender]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Birth Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.dateOfBirth]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Mobile"
                                                                         FieldValue:visa.applicantMobileNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Email"
                                                                         FieldValue:visa.applicantEmail]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Employee Information" Fields:fieldsArray]];
    
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Visa Number"
                                                                         FieldValue:visa.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Status"
                                                                         FieldValue:visa.validityStatus]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expiry"
                                                                         FieldValue:[HelperClass formatDateToString:visa.expiryDate]]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Visa Information" Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Passport"
                                                                         FieldValue:visa.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expriry Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.passportExpiry]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Issue Country"
                                                                         FieldValue:visa.passportCountry]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Passport Information" Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    if ([visa.validityStatus isEqualToString:@"Issued"])
        servicesMask |= RelatedServiceTypeNewEmoloyeeNOC;
    
    /*
     if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"]) {
     servicesMask |= RelatedServiceTypeRenewVisa;
     servicesMask |= RelatedServiceTypeCancelVisa;
     }
     */
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForVisitVisa:(Visa*)visa {
    recordVC.NameValue = visa.applicantFullName;
    recordVC.PhotoId = visa.personalPhotoId;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Gender"
                                                                         FieldValue:visa.applicantGender]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Birth Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.dateOfBirth]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Mobile"
                                                                         FieldValue:visa.applicantMobileNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Email"
                                                                         FieldValue:visa.applicantEmail]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Employee Information" Fields:fieldsArray]];
    
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Visa Number"
                                                                         FieldValue:visa.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Status"
                                                                         FieldValue:visa.validityStatus]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expiry"
                                                                         FieldValue:[HelperClass formatDateToString:visa.expiryDate]]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Visa Information" Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Passport"
                                                                         FieldValue:visa.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expriry Date"
                                                                         FieldValue:[HelperClass formatDateToString:visa.passportExpiry]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Issue Country"
                                                                         FieldValue:visa.passportCountry]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Passport Information" Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    /*
     if ([visa.validityStatus isEqualToString:@"Issued"] || [visa.validityStatus isEqualToString:@"Expired"])
     servicesMask |= RelatedServiceTypeCancelVisa;
     */
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForContractor:(CardManagement*)card {
    recordVC.NameValue = card.fullName;
    recordVC.PhotoId = card.personalPhoto;
    recordVC.cardManagementObject = card;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Card Number"
                                                                         FieldValue:card.cardNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Type"
                                                                         FieldValue:card.cardType]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Expiry Date"
                                                                         FieldValue:[HelperClass formatDateToString:card.cardExpiryDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Status"
                                                                         FieldValue:card.status]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Card Details" Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Passport Number"
                                                                         FieldValue:card.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Nationality"
                                                                         FieldValue:card.nationality.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Designation"
                                                                         FieldValue:card.designation]];
    [fieldsArray addObject:[[TableViewSectionField alloc] initTableViewSectionField:@"Sponsor Company"
                                                                         FieldValue:card.sponsor]];
    [sectionsArray addObject:[[TableViewSection alloc] initTableViewSection:@"Person Details" Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    if ([card.status isEqualToString:@"Active"]) {
        servicesMask |= RelatedServiceTypeReplaceCard;
        servicesMask |= RelatedServiceTypeCancelCard;
    }
    
    NSTimeInterval daysToExpire = [card.cardExpiryDate timeIntervalSinceNow] / (3600 * 24);
    
    if (([card.status isEqualToString:@"Active"] && daysToExpire <= 7) || [card.status isEqualToString:@"Expired"]) {
        servicesMask |= RelatedServiceTypeRenewCard;
        
    }
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForShareholder:(ShareOwnership *)shareOwnership {
    recordVC.NameValue = shareOwnership.shareholder.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderName", @"")
                            FieldValue:shareOwnership.shareholder.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderNationality", @"")
                            FieldValue:shareOwnership.shareholder.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderPassportNumber", @"")
                            FieldValue:shareOwnership.shareholder.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.shareholder.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ShareholderPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    
    NSString *ownershipPercent = [NSString stringWithFormat:@"%@ %%",[HelperClass formatNumberToString:shareOwnership.ownershipOfShare FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderOwnership", @"")
                            FieldValue:ownershipPercent]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderNoOfShare", @"")
                            FieldValue:[HelperClass formatNumberToString:shareOwnership.noOfShares
                                                             FormatStyle:NSNumberFormatterDecimalStyle
                                                   MaximumFractionDigits:2]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.ownershipStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.ownershipEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ShareholderInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForManager:(ManagementMember *)managementMember {
    
    recordVC.NameValue = managementMember.manager.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerName", @"")
                            FieldValue:managementMember.manager.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerNationality", @"")
                            FieldValue:managementMember.manager.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerPassportNumber", @"")
                            FieldValue:managementMember.manager.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.manager.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ManagerPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerRole", @"")
                            FieldValue:managementMember.role]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.managerStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.managerEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ManagerInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForDirector:(Directorship *)directorship {
    
    recordVC.NameValue = directorship.director.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorName", @"")
                            FieldValue:directorship.director.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorNationality", @"")
                            FieldValue:directorship.director.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorPassportNumber", @"")
                            FieldValue:directorship.director.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:directorship.director.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"DirectorPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorRole", @"")
                            FieldValue:directorship.roles]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:directorship.directorshipStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"DirectorEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:directorship.directorshipEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"DirectorInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForLegalRepresentative:(LegalRepresentative *)legalRepresentative {
    
    recordVC.NameValue = legalRepresentative.legalRepresentative.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeName", @"")
                            FieldValue:legalRepresentative.legalRepresentative.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeNationality", @"")
                            FieldValue:legalRepresentative.legalRepresentative.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativePassportNumber", @"")
                            FieldValue:legalRepresentative.legalRepresentative.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativePassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:legalRepresentative.legalRepresentative.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"LegalRepresentativePersonalInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeRole", @"")
                            FieldValue:legalRepresentative.role]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:legalRepresentative.legalRepresentativeStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"LegalRepresentativeEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:legalRepresentative.legalRepresentativeEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"LegalRepresentativeInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainDetailsViewController*)recordVC ForLeasingInfo:(TenancyContract *)tenancyContract {
    
    recordVC.NameValue = tenancyContract.name;
    
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractName", @"")
                            FieldValue:tenancyContract.contractNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractType", @"")
                            FieldValue:tenancyContract.contractType]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.contractStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractExpireDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.contractExpiryDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractRentStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.rentStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractActivatedDate", @"")
                            FieldValue:[HelperClass formatDateToString:tenancyContract.activatedDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractDurationYear", @"")
                            FieldValue:[HelperClass formatNumberToString:tenancyContract.contractDurationYear
                                                             FormatStyle:NSNumberFormatterNoStyle
                                                   MaximumFractionDigits:0]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractDurationMonth", @"")
                            FieldValue:tenancyContract.contractDurationMonth]];
    
    NSString *priceString = [HelperClass formatNumberToString:tenancyContract.totalRentPrice
                                                  FormatStyle:NSNumberFormatterDecimalStyle
                                        MaximumFractionDigits:2];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"TenancyContractRentPrice", @"")
                            FieldValue:[NSString stringWithFormat:@"AED %@", priceString]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"TenancyContractInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    for (ContractLineItem *contractLineItem in tenancyContract.contractLineItems) {
        [fieldsArray addObject:[[TableViewSectionField alloc]
                                initTableViewSectionField:NSLocalizedString(@"TenancyContractLineItemUnitName", @"")
                                FieldValue:contractLineItem.inventoryUnit.name]];
    }
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"TenancyContractLeasingUnitDetails", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    for (TenancyContractPayment *tenancyContractPayment in tenancyContract.tenancyContractPayments) {
        NSString *paymentAmountString = [HelperClass formatNumberToString:tenancyContractPayment.paymentAmount
                                                              FormatStyle:NSNumberFormatterDecimalStyle
                                                    MaximumFractionDigits:2];
        NSString *dateString = [HelperClass formatDateToString:tenancyContractPayment.dueDate];
        [fieldsArray addObject:[[TableViewSectionField alloc]
                                initTableViewSectionField:tenancyContractPayment.descriptionPayment
                                FieldValue:[NSString stringWithFormat:@"AED %@ is due on %@", paymentAmountString, dateString]]];
    }
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"TenancyContractUpcomingPayments", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    NSTimeInterval daysToExpire = [tenancyContract.contractExpiryDate timeIntervalSinceNow] / (3600 * 24);
    if (tenancyContract.isBCContract && daysToExpire <= 60)
        servicesMask |= RelatedServiceTypeContractRenewal;
    
    recordVC.RelatedServicesMask = servicesMask;
    
    recordVC.contractObject = tenancyContract;
}
@end
