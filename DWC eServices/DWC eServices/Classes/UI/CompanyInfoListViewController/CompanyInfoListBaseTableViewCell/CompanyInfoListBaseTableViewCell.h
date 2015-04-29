//
//  CompanyInfoListBaseTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWCCompanyInfo.h"

@class CompanyInfoListBaseTableViewCell;

@protocol CompanyInfoListBaseTableViewCellDelegate <NSObject>
- (void)companyTableViewCell:(CompanyInfoListBaseTableViewCell *)companyTableViewCell detailsButtonClickAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CompanyInfoListBaseTableViewCell : UITableViewCell
{
    NSIndexPath *currentIndexPath;
}

@property (nonatomic) id <CompanyInfoListBaseTableViewCellDelegate> delegate;
@property (strong, nonatomic) UIViewController *parentViewController;

- (IBAction)detailsButtonClicked:(id)sender;
- (void)refreshCellForObject:(NSObject *)currentObject companyInfoType:(DWCCompanyInfoType)companyInfoType indexPath:(NSIndexPath *)indexPath;

@end
