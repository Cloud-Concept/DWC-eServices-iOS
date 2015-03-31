//
//  RecordRelatedViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RecordRelatedViewController.h"
#import "RelatedService.h"
#import "HelperClass.h"
#import "UIView+RoundCorner.h"

@interface RecordRelatedViewController ()

@end

@implementation RecordRelatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initRelatedServices];
    [self displayRelatedServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.view layoutIfNeeded];
}

- (void)initRelatedServices {
    NSMutableArray *relatedServicesMutableArray = [NSMutableArray new];
    
    [relatedServicesMutableArray addObject:[[RelatedService alloc] initRelatedService:@"New_NOC"
                                                                                Label:@"New NOC"
                                                                                 Icon:@"New NOC Icon"
                                                                                 Mask:RelatedServiceTypeNewNOC]];
    
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

- (void)displayRelatedServices {
    [self initRelatedServicesContentView];
    
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    NSMutableArray *displayedServiesArray = [NSMutableArray new];
    
    for (RelatedService *service in relatedServicesArray) {
        
        if ((self.RelatedServicesMask & service.Mask) != 0) {
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
        [button.titleLabel setFont:[UIFont fontWithName:@"CorisandeLight" size:12.0f]];
        [button setBackgroundColor:[UIColor colorWithRed:0.87
                                                   green:0.88
                                                    blue:0.89
                                                   alpha:1]];
        [button addTarget:self action:@selector(serviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [HelperClass setupButtonWithImageAlignedToLeft:button];
        
        [button createRoundBorderedWithRadius:10
                                      Shadows:NO
                                 ClipToBounds:NO];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [servicesContentView addSubview:button];
    }
    
    NSDictionary *metrics = @{@"buttonHeight": @54,
                              @"buttonWidth": @150,
                              @"leftMargin": @50,
                              @"rightMargin": @50,
                              @"topMargin": @20,
                              @"bottomMargin": @20
                              };
    
    for (NSInteger index = 0; index < displayedServiesArray.count; index++) {
        RelatedService *currentRelatedService = [displayedServiesArray objectAtIndex:index];
        RelatedService *previousRelatedService = nil;
        
        NSString *heightRule = [NSString stringWithFormat:@"V:[%@(buttonHeight)]", currentRelatedService.Name];
        NSArray *field_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:heightRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        /*
        NSString *widthtRule = [NSString stringWithFormat:@"H:[%@(==buttonWidth)]", currentRelatedService.Name];
        NSArray *field_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:widthtRule
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        */
        
        [servicesContentView addConstraints:field_constraint_V];
        //[self.servicesScrollView addConstraints:field_constraint_H];
        
        if(index != 0)
            previousRelatedService = [displayedServiesArray objectAtIndex:index - 1];
        
        NSString *horizontalRule = [NSString stringWithFormat:@"H:|-leftMargin-[%@]-rightMargin-|", currentRelatedService.Name];
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        NSMutableString *verticalRule = [NSMutableString stringWithString:@"V:"];
        
        if (previousRelatedService == nil)
        {
            [verticalRule appendFormat:@"|-topMargin-"];
        }
        else
        {
            [verticalRule appendFormat:@"[%@]-", previousRelatedService.Name];
        }
        
        [verticalRule appendFormat:@"[%@]", currentRelatedService.Name];
        
        if (index == displayedServiesArray.count - 1) {
            [verticalRule appendString:@"-bottomMargin-|"];
        }
        
        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalRule
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:viewsDictionary];
        
        [servicesContentView addConstraints:constraint_POS_H];
        [servicesContentView addConstraints:constraint_POS_V];
    }
}

- (void)initRelatedServicesContentView {
    self.servicesScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    servicesContentView = [UIView new];
    servicesContentView.backgroundColor = [UIColor clearColor];
    servicesContentView.frame = self.servicesScrollView.frame;
    
    servicesContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.servicesScrollView addSubview:servicesContentView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(servicesContentView);
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [self.servicesScrollView addConstraint:[NSLayoutConstraint
                                            constraintWithItem:servicesContentView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.servicesScrollView
                                            attribute:NSLayoutAttributeWidth
                                            multiplier:1
                                            constant:0.0]];
    
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    [self.servicesScrollView addConstraints:constraint_POS_H];
    [self.servicesScrollView addConstraints:constraint_POS_V];
}

- (void)serviceButtonClicked:(UIButton*)sender {
    
    if (!self.delegate)
        return;
    
    switch (sender.tag) {
        case RelatedServiceTypeNewNOC:
            [self.delegate relatedServiceNewNOCButtonClicked];
            break;
        case RelatedServiceTypeNewCard:
            [self.delegate relatedServiceNewCardButtonClicked];
            break;
        case RelatedServiceTypeRenewCard:
            [self.delegate relatedServiceRenewCardButtonClicked];
            break;
        case RelatedServiceTypeCancelCard:
            [self.delegate relatedServiceCancelCardButtonClicked];
            break;
        case RelatedServiceTypeReplaceCard:
            [self.delegate relatedServiceReplaceCardButtonClicked];
            break;
        case RelatedServiceTypeNewVisa:
            [self.delegate relatedServiceNewVisaButtonClicked];
            break;
        case RelatedServiceTypeRenewVisa:
            [self.delegate relatedServiceRenewVisaButtonClicked];
            break;
        case RelatedServiceTypeCancelVisa:
            [self.delegate relatedServiceCancelVisaButtonClicked];
            break;
        case RelatedServiceTypeContractRenewal:
            [self.delegate relatedServiceContractRenewalButtonClicked];
        case RelatedServiceTypeLicenseRenewal:
            [self.delegate relatedServiceLicenseRenewalButtonClicked];
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
