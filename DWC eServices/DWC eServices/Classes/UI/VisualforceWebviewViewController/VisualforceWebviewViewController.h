//
//  VisualforceWebviewViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface VisualforceWebviewViewController : BaseFrontRevealViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *returnURL;
@property (nonatomic, strong) NSString *navBarTitle;

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end
