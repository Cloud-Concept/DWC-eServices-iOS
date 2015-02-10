//
//  NewNOCViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NewNOCViewController.h"
#import "PickerTableViewController.h"
#import "EServiceAdministration.h"
#import "SFRestAPI+Blocks.h"

@interface NewNOCViewController ()

@end

@implementation NewNOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.showSlidingMenu = NO;
    
    //[getNOCTypes]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseNOCTypeButtonClicked:(id)sender {
    NSArray *stringArray = @[@"One", @"Two", @"Three"];
    UIButton *senderButton = sender;
    
    
    PickerTableViewController *viewCont = [PickerTableViewController new];
    viewCont.valuesArray = stringArray;
    
    [viewCont showPopoverFromView:senderButton];
}

- (void)getNOCTypes {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        NSLog(@"request:didLoadResponse: #records: %d", records.count);
        
        nocTypesArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in records) {
            NSArray *documentRecordsArray = [NSArray new];
            if(![[dict objectForKey:@"eServices_Document_Checklists__r"] isKindOfClass:[NSNull class]])
                documentRecordsArray = [[dict objectForKey:@"eServices_Document_Checklists__r"] objectForKey:@"records"];
            
            [nocTypesArray addObject:[[EServiceAdministration alloc] initEServiceAdministration:[dict objectForKey:@"Id"]
                                                                                           Name:[dict objectForKey:@"Name"]
                                                                              ServiceIdentifier:[dict objectForKey:@"Service_Identifier__c"]
                                                                                         Amount:[dict objectForKey:@"Amount__c"]
                                                                                RelatedToObject:[dict objectForKey:@"Related_to_Object__c"]
                                                                           VisualForceGenerator:[dict objectForKey:@"New_Edit_VF_Generator__c"]
                                                                          ServiceDocumentsArray:documentRecordsArray]];
        }
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        
    };
    
    NSString *selectQuery = @"SELECT ID, Name, Service_Identifier__c, Amount__c, Related_to_Object__c, New_Edit_VF_Generator__c, (SELECT ID, Name, Type__c, Language__c, Document_Type__c FROM eServices_Document_Checklists__r WHERE Document_Type__c = 'Upload') FROM Receipt_Template__c WHERE Related_to_Object__c INCLUDES ('NOC') AND Redirect_Page__c != null AND RecordType.DeveloperName = 'Auto_Generated_Invoice' AND Is_Active__c = true ORDER BY Service_Identifier__c";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

@end
