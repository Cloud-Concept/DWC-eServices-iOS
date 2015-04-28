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
                                                                                 Icon:@"New NOC Icon"
                                                                                 Mask:RelatedServiceTypeNewEmoloyeeNOC]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_NOC_Company"
                                                                                Label:@"New NOC"
                                                                                 Icon:@"New NOC Icon"
                                                                                 Mask:RelatedServiceTypeNewCompanyNOC]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_Card"
                                                                                Label:@"New Card"
                                                                                 Icon:@"Renew Visa Icon"
                                                                                 Mask:RelatedServiceTypeNewCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_Card"
                                                                                Label:@"Renew Card"
                                                                                 Icon:@"Renew Visa Icon"
                                                                                 Mask:RelatedServiceTypeRenewCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Cancel_Card"
                                                                                Label:@"Cancel Card"
                                                                                 Icon:@"Renew Visa Icon"
                                                                                 Mask:RelatedServiceTypeCancelCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Replace_Card"
                                                                                Label:@"Replace Card"
                                                                                 Icon:@"Renew Visa Icon"
                                                                                 Mask:RelatedServiceTypeReplaceCard]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_Visa"
                                                                                Label:@"New Visa"
                                                                                 Icon:@"Renew Visa Icon"
                                                                                 Mask:RelatedServiceTypeNewVisa]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_Visa"
                                                                                Label:@"Renew Visa"
                                                                                 Icon:@"Renew Visa Icon"
                                                                                 Mask:RelatedServiceTypeRenewVisa]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Cancel_Visa"
                                                                                Label:@"Cancel Visa"
                                                                                 Icon:@"Cancel Visa Icon"
                                                                                 Mask:RelatedServiceTypeCancelVisa]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_Contract"
                                                                                Label:@"Renew Contract"
                                                                                 Icon:@"Cancel Visa Icon"
                                                                                 Mask:RelatedServiceTypeContractRenewal]];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"Renew_License"
                                                                                Label:@"Renew License"
                                                                                 Icon:@"Cancel Visa Icon"
                                                                                 Mask:RelatedServiceTypeLicenseRenewal]];
    
    relatedServicesArray = relatedServicesMutableArray;
}

- (void)displayRelatedServicesForMask:(NSUInteger)relatedServicesMask {
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
    
    NSDictionary *metrics = @{@"buttonHeight": @64,
                              @"buttonWidth": @64,
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

@end
