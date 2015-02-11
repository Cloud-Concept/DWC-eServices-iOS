//
//  PickerTableViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
@class PickerTableViewController;

@protocol PickerTableViewControllerDelegate <NSObject>

- (void)valuePickCanceled:(PickerTableViewController *)picklist;
- (void)valuePicked:(NSString *)value AtIndex:(NSIndexPath *)indexPath pickList:(PickerTableViewController *)picklist;

@end

@interface PickerTableViewController : UITableViewController <WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
}

@property (strong, nonatomic) NSArray *valuesArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) id<PickerTableViewControllerDelegate> delegate;

- (void)showPopoverFromView:(UIView*)sender;
-(void)dismissPopover:(BOOL)animated;

@end
