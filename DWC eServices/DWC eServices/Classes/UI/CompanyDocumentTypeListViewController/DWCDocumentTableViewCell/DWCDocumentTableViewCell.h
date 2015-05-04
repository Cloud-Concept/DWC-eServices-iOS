//
//  DWCDocumentTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EServicesDocumentChecklist;
@class TenancyContract;

@interface DWCDocumentTableViewCell : UITableViewCell
{
    NSIndexPath *currentIndexPath;
}

@property (strong, nonatomic) UIViewController *parentViewController;

@property (weak, nonatomic) IBOutlet UILabel *documentNameLabel;

- (void)refreshCellForEServicesDocumentChecklist:(EServicesDocumentChecklist *)currentEServicesDocumentChecklist activeBCTenancyContract:(TenancyContract *)activeBCTenancyContract indexPath:(NSIndexPath *)indexPath;

@end
