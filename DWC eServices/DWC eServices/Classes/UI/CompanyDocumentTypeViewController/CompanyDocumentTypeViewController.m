//
//  CompanyDocumentTypeViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyDocumentTypeViewController.h"
#import "DWCCompanyDocument.h"
#import "SOQLQueries.h"
#import "CompanyDocumentTypeListViewController.h"

@interface CompanyDocumentTypeViewController ()

@end

@implementation CompanyDocumentTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setNavigationBarTitle:NSLocalizedString(@"navBarCompanyDocumentsTitle", @"")];
    
    companyDocumentsTypesArray = [NSMutableArray new];
    
    [companyDocumentsTypesArray addObject:[[DWCCompanyDocument alloc]
                                           initDWCCompanyDocument:NSLocalizedString(@"DWCCompanyDocumentTypeDWCDocument", @"")
                                           NavBarTitle:NSLocalizedString(@"navBarDWCCompanyDocumentTypeDWCDocumentTitle", @"")
                                           DWCCompanyDocumentType:DWCCompanyDocumentTypeDWCDocument
                                           Query:[SOQLQueries dwcDocumentsQuery]]];
    
    [companyDocumentsTypesArray addObject:[[DWCCompanyDocument alloc]
                                           initDWCCompanyDocument:NSLocalizedString(@"DWCCompanyDocumentTypeCustomerDocument", @"")
                                           NavBarTitle:NSLocalizedString(@"navBarDWCCompanyDocumentTypeCustomerDocumentTitle", @"")
                                           DWCCompanyDocumentType:DWCCompanyDocumentTypeCustomerDocument
                                           Query:[SOQLQueries customerDocumentsQuery]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[CompanyDocumentTypeListViewController class]]) {
        CompanyDocumentTypeListViewController *destinationVC = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        destinationVC.currentDocumentType = [companyDocumentsTypesArray objectAtIndex:selectedIndexPath.row];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return companyDocumentsTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Document Type Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    DWCCompanyDocument *companyDocumentType = [companyDocumentsTypesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = companyDocumentType.Label;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

@end
