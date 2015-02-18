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
    self.preferredContentSize = CGSizeMake(320, self.valuesArray.count * 44);
    
    [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

- (void)dismissPopover:(BOOL)animated {
    [popoverController dismissPopoverAnimated:animated];
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
    
    if (self.selectedIndexPath)
        cell.accessoryType = self.selectedIndexPath.row == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self.tableView reloadData];
    
    if (!self.valuePicked)
        return;
    
    NSString *selectedValue = [self.valuesArray objectAtIndex:indexPath.row];
    self.valuePicked(selectedValue, indexPath, self);
}


#pragma mark - WYPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController {
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
