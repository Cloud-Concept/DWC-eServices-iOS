//
//  CompanyInfoListBaseTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWCCompanyInfo.h"

@interface CompanyInfoListBaseTableViewCell : UITableViewCell
{
    NSIndexPath *currentIndexPath;
}

@property (strong, nonatomic) UIViewController *parentViewController;

- (void)refreshCellForObject:(NSObject *)currentObject companyInfo:(DWCCompanyInfo *)companyInfo indexPath:(NSIndexPath *)indexPath;

@end
