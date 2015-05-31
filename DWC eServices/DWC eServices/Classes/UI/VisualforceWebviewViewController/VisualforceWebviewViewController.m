//
//  VisualforceWebviewViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "VisualforceWebviewViewController.h"
#import "SFUserAccountManager.h"
#import "FVCustomAlertView.h"
#import "HelperClass.h"

@interface VisualforceWebviewViewController ()

@end

@implementation VisualforceWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.showSlidingMenu = self.VFshowSlidingMenu;
    [super setNavigationBarTitle:self.navBarTitle];
    
    [self loadVisualforcePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadVisualforcePage {
    SFOAuthCredentials *creds = [SFUserAccountManager sharedInstance].currentUser.credentials;
    NSString *frontDoorUrl = [NSString stringWithFormat:@"%@/secur/frontdoor.jsp?sid=%@&retURL=%@&display=touch",
                              [creds.instanceUrl absoluteString], creds.accessToken, self.returnURL];
    
    self.webview.delegate = self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:frontDoorUrl]]];
    self.webview.scalesPageToFit = YES;
}

#pragma mark - UIWebviewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                     Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
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
