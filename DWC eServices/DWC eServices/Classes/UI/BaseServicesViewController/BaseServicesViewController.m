//
//  BaseServicesViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "BaseServicesViewController.h"
#import "FVCustomAlertView.h"
#import "EServiceAdministration.h"

@interface BaseServicesViewController ()

@end

@implementation BaseServicesViewController

@synthesize currentServiceAdministration;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.showSlidingMenu = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelServiceButtonClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ConfirmAlertTitle", @"")
                                                                   message:NSLocalizedString(@"CancelServiceAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          NSLog(@"Yes action");
                                                          [self popServicesViewController];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          NSLog(@"No action");
                                                      }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)popServicesViewController {
    [self.navigationController popToViewController:self.cancelViewController animated:YES];
}

- (void)initializeButtonsWithNextAction:(SEL)nextAction {
    cancelButton = [UIButton new];
    [cancelButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"Black Button Background"] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
    [cancelButton addTarget:self action:@selector(cancelServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton = [UIButton new];
    [nextButton setTitle:NSLocalizedString(@"next", @"") forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Blue Button Background"] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont fontWithName:@"CorisandeRegular" size:14.0f]];
    [nextButton addTarget:self action:nextAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:@"Loading..." withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
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
