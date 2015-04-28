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
@class EmployeeTableViewCell;

@protocol EmployeeTableViewCellDelegate <NSObject>
- (void)employeeTableViewCell:(EmployeeTableViewCell *)employeeTableViewCell detailsButtonClickAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface EmployeeTableViewCell : UITableViewCell
{
    NSIndexPath *currentIndexPath;
}

@property (nonatomic) id<EmployeeTableViewCellDelegate> delegate;
@property (strong, nonatomic) UIViewController *parentViewController;

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowOneValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowTwoValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowThreeValueLabel;

- (void)refreshCellForVisa:(Visa *)currentVisa employeeType:(DWCEmployeeType)employeeType indexPath:(NSIndexPath *)indexPath;
- (void)refreshCellForCard:(CardManagement *)currentCard employeeType:(DWCEmployeeType)employeeType indexPath:(NSIndexPath *)indexPath;

-(IBAction)detailsButtonClicked:(id)sender;
@end
