//
//  EmployeeMainViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/1/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RecordMainDetailsViewController.h"
#import "UIView+RoundCorner.h"
#import "UIImageView+SFAttachment.h"
#import "RecordDetailTableViewCell.h"
#import "TableViewSection.h"
#import "TableViewSectionField.h"
#import "RelatedServicesBarScrollView.h"

@interface RecordMainDetailsViewController ()

@end

@implementation RecordMainDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showSlidingMenu = NO;
    self.showBottomTabBar = !self.isBottomBarHidden;
    
    [super setNavigationBarTitle:self.NavBarTitle];
    
    self.employeeNameLabel.text = self.NameValue;
    
    [self.profilePictureImageView loadImageFromSFAttachment:self.PhotoId
                                           placeholderImage:[UIImage imageNamed:@"Default Person Image"]];
    [self.profilePictureImageView createRoundBorderedWithRadius:3.0 Shadows:NO ClipToBounds:YES];
    
    [self setupDetailsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self setupDetailsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDetailsView {
    if (self.RelatedServicesMask == 0)
        [self.relatedServicesScrollView removeFromSuperview];
    else
        [self renderServicesButtons];
}

- (void)renderServicesButtons {
    
    self.relatedServicesScrollView.visaObject = self.visaObject;
    self.relatedServicesScrollView.contractObject = self.contractObject;
    self.relatedServicesScrollView.licenseObject = self.licenseObject;
    self.relatedServicesScrollView.cardManagementObject = self.cardManagementObject;
    
    [self.relatedServicesScrollView displayRelatedServicesForMask:self.RelatedServicesMask parentViewController:self];
    [self.relatedServicesScrollView layoutIfNeeded];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.DetailsSectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ((TableViewSection*)[self.DetailsSectionsArray objectAtIndex:section]).FieldsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((TableViewSection*)[self.DetailsSectionsArray objectAtIndex:section]).Label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordDetailTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    TableViewSectionField *currentField = [((TableViewSection*)[self.DetailsSectionsArray objectAtIndex:indexPath.section]).FieldsArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = currentField.Label;
    cell.valueLabel.text = currentField.Value;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

@end
