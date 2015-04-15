//
//  HomePageViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *dashboardButton;
@property (weak, nonatomic) IBOutlet UIButton *employeesButton;
@property (weak, nonatomic) IBOutlet UIButton *myRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UIButton *companyDocumentsButton;
@property (weak, nonatomic) IBOutlet UIButton *needHelpButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *servicesButton;
@property (weak, nonatomic) IBOutlet UIButton *companyInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *quickAccessInfoButton;

@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseExpiryDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBalanceValueLabel;

- (IBAction)logoutButtonClicked:(id)sender;
- (IBAction)dashboardButtonClicked:(id)sender;

@end
