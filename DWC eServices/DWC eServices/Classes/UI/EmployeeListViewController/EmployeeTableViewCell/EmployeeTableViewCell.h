//
//  ContractorTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWCEmployee.h"

@class Visa;
@class CardManagement;

@interface EmployeeTableViewCell : UITableViewCell
{
    NSIndexPath *currentIndexPath;
}

@property (strong, nonatomic) UIViewController *parentViewController;

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowOneValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowTwoValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowThreeValueLabel;

- (void)refreshCellForVisa:(Visa *)currentVisa dwcEmployee:(DWCEmployee *)dwcEmployee indexPath:(NSIndexPath *)indexPath;
- (void)refreshCellForCard:(CardManagement *)currentCard dwcEmployee:(DWCEmployee *)dwcEmployee indexPath:(NSIndexPath *)indexPath;

@end
