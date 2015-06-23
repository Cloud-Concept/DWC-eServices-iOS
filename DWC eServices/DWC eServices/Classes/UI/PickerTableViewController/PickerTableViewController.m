//
//  PickerTableViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "PickerTableViewController.h"

@interface PickerTableViewController ()

@end

@implementation PickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPopoverFromView:(UIView*)sender {
    self.preferredContentSize = self.view.frame.size;
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:self];
    popoverController.delegate = self;
    CGFloat height = self.valuesArray.count > 0 ? self.valuesArray.count * 44: 44;
    self.preferredContentSize = CGSizeMake(320, height);
    
    [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

- (void)dismissPopover:(BOOL)animated {
    [popoverController dismissPopoverAnimated:animated];
}

- (void)setCellCheckmark:(UITableViewCell *)cell currentIndexPath:(NSIndexPath *)indexPath {
    if (self.pickerType == PickerTableViewControllerTypeSingleChoice) {
        if (self.selectedIndexPath)
            cell.accessoryType = self.selectedIndexPath.row == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else if (self.pickerType == PickerTableViewControllerTypeMultiChoice) {
        BOOL isSelected = NO;
        
        for (NSIndexPath *newIndexPath in self.selectedMultiIndexPath) {
            if (newIndexPath.row == indexPath.row) {
                isSelected = YES;
                break;
            }
        }
        
       cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

- (void)singleChoiceDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self.tableView reloadData];
    
    if (!self.valuePicked)
        return;
    
    NSString *selectedValue = [self.valuesArray objectAtIndex:indexPath.row];
    self.valuePicked(selectedValue, indexPath, self);
}

- (void)multipleChoiceDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isFound = NO;
    
    for (NSIndexPath *newIndexPath in self.selectedMultiIndexPath) {
        if (newIndexPath.row == indexPath.row) {
            isFound = YES;
            [self.selectedMultiIndexPath removeObject:newIndexPath];
            break;
        }
    }
    
    if (!isFound) {
        if (!self.selectedMultiIndexPath)
            self.selectedMultiIndexPath = [NSMutableArray new];
        
        [self.selectedMultiIndexPath addObject:indexPath];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.valuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.valuesArray objectAtIndex:indexPath.row];
    
    [self setCellCheckmark:cell currentIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.pickerType) {
        case PickerTableViewControllerTypeSingleChoice:
            [self singleChoiceDidSelectRowAtIndexPath:indexPath];
            break;
        case PickerTableViewControllerTypeMultiChoice:
            [self multipleChoiceDidSelectRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
}


#pragma mark - WYPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController {
    if (self.pickerType == PickerTableViewControllerTypeMultiChoice) {
        
        if (!self.multipleValuesPicked) {
            
            NSMutableArray *selectedValues = [NSMutableArray new];
            for (NSIndexPath *indexPath in self.selectedMultiIndexPath) {
                [selectedValues addObject:[self.valuesArray objectAtIndex:indexPath.row]];
            }
            self.multipleValuesPicked(selectedValues, self.selectedMultiIndexPath, self);
        }
        
        return;
    }
    
    if (!self.valuePickCanceled)
        return;
    
    self.valuePickCanceled(self);
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
