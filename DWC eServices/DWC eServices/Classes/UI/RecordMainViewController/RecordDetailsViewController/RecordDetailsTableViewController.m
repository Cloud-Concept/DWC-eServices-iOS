//
//  RecordDetailsTableViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RecordDetailsTableViewController.h"
#import "TableViewSection.h"
#import "TableViewSectionField.h"
#import "RecordDetailTableViewCell.h"

@interface RecordDetailsTableViewController ()

@end

@implementation RecordDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setAllowsSelection:NO];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.95f
                                                       green:0.95f
                                                        blue:0.95f
                                                       alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.SectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ((TableViewSection*)[self.SectionsArray objectAtIndex:section]).FieldsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((TableViewSection*)[self.SectionsArray objectAtIndex:section]).Label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordDetailTableViewCell"];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RecordDetailTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    // Configure the cell...
    TableViewSectionField *currentField = [((TableViewSection*)[self.SectionsArray objectAtIndex:indexPath.section]).FieldsArray objectAtIndex:indexPath.row];
    
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
