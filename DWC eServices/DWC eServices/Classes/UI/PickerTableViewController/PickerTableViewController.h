//
//  PickerTableViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"


typedef enum {
    PickerTableViewControllerTypeSingleChoice,
    PickerTableViewControllerTypeMultiChoice,
} PickerTableViewControllerType;

@interface PickerTableViewController : UITableViewController <WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
}

@property (strong, nonatomic) NSArray *valuesArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSMutableArray *selectedMultiIndexPath;
@property (assign, nonatomic) PickerTableViewControllerType pickerType;

@property (nonatomic, copy) void (^valuePicked)(NSString *, NSIndexPath *, PickerTableViewController *);
@property (nonatomic, copy) void (^multipleValuesPicked)(NSArray *, NSArray *, PickerTableViewController *);
@property (nonatomic, copy) void (^valuePickCanceled)(PickerTableViewController *);

- (void)showPopoverFromView:(UIView*)sender;
-(void)dismissPopover:(BOOL)animated;

@end
