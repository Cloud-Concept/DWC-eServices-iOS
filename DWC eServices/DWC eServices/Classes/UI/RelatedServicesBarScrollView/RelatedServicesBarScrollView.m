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

@end
