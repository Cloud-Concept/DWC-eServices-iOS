/*
 Copyright (c) 2011-2014, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppDelegate.h"
#import "InitialViewController.h"
#import "SFPushNotificationManager.h"
#import "SFDefaultUserManagementViewController.h"
#import "SalesforceSDKManager.h"
#import "SFUserAccountManager.h"
#import "SFLogger.h"
#import "NetworkReachability.h"
#import "CustomIOS7AlertView.h"
#import "NoInternetPopoverViewController.h"
#import "AnimatedSplashViewController.h"

// Fill these in when creating a new Connected Application on Force.com

/*Production Env
static NSString * const RemoteAccessConsumerKey = @"3MVG9WtWSKUDG.x4vb34GvJQPxE1sN.eJ1GfuUpDHEMSeumJCoE1Qw_dXJ1sCRKXnNyxasiuCRrJjGHZJGXVt";
static NSString * const LoginHostUrl            = @"dwc.force.com/portal";
//*/

//*Testing Env
static NSString * const RemoteAccessConsumerKey = @"3MVG9sLbBxQYwWqsa8dlM02Kaxs1PH5oIbF_o2Y4FfeOoF.1__CEjo_6_fIBta82uOIvzvuJ9tVtR1iU9PbtA";
static NSString * const LoginHostUrl            = @"test-dwc.cs14.force.com/portal";
//*/

static NSString * const OAuthRedirectURI        = @"dwcmobile://auth/success";




@interface AppDelegate ()

/**
 * Convenience method for setting up the main UIViewController and setting self.window's rootViewController
 * property accordingly.
 */
- (void)setupRootViewController;

/**
 * (Re-)sets the view state when the app first loads (or post-logout).
 */
- (void)initializeAppViewState;

@end

@implementation AppDelegate

@synthesize window = _window;

- (CustomIOS7AlertView *) customAlertView{
    if(_customAlertView)
        return _customAlertView;
    
    _customAlertView = [[CustomIOS7AlertView alloc] init];
    
    NoInternetPopoverViewController *noInternetPopoverViewController = [[NoInternetPopoverViewController alloc] initNoInternetPopoverViewController];
    
    [_customAlertView setContainerView:noInternetPopoverViewController.view];
    [_customAlertView setButtonTitles:nil];
    
    [_customAlertView setUseMotionEffects:true];
    
    return _customAlertView;
}

- (id)init
{
    self = [super init];
    if (self) {
        [SFLogger setLogLevel:SFLogLevelDebug];

        [SalesforceSDKManager sharedManager].connectedAppId = RemoteAccessConsumerKey;
        [SalesforceSDKManager sharedManager].connectedAppCallbackUri = OAuthRedirectURI;
        [SalesforceSDKManager sharedManager].authScopes = @[ @"web", @"api" ];
        
        __weak AppDelegate *weakSelf = self;
        [SalesforceSDKManager sharedManager].postLaunchAction = ^(SFSDKLaunchAction launchActionList) {
            [weakSelf log:SFLogLevelInfo format:@"Post-launch: launch actions taken: %@", [SalesforceSDKManager launchActionsStringRepresentation:launchActionList]];
            [weakSelf setupRootViewController];    
        };
        [SalesforceSDKManager sharedManager].launchErrorAction = ^(NSError *error, SFSDKLaunchAction launchActionList) {
            [weakSelf log:SFLogLevelError format:@"Error during SDK launch: %@", [error localizedDescription]];
            [weakSelf initializeAppViewState];
            [[SalesforceSDKManager sharedManager] launch];
        };
        [SalesforceSDKManager sharedManager].postLogoutAction = ^{
            [weakSelf handleSdkManagerLogout];
        };
        [SalesforceSDKManager sharedManager].switchUserAction = ^(SFUserAccount *fromUser, SFUserAccount *toUser) {
            [weakSelf handleUserSwitch:fromUser toUser:toUser];
        };
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    UIImage *navBackgroundImage = [UIImage imageNamed:@"Home NavBar Background"];
//    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:146.0f/255.0f alpha:1.0]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"CorisandeRegular" size:0.0]}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kNetworkReachabilityChangedNotification object:nil];
    
    
    self.cachingBusinessActivity = [NSMutableDictionary new];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self initializeAppViewState];
    
    //
    // If you wish to register for push notifications, uncomment the line below.  Note that,
    // if you want to receive push notifications from Salesforce, you will also need to
    // implement the application:didRegisterForRemoteNotificationsWithDeviceToken: method (below).
    //
    [[SFPushNotificationManager sharedInstance] registerForRemoteNotifications];
    
    [[SalesforceSDKManager sharedManager] launch];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //
    // Uncomment the code below to register your device token with the push notification manager
    //
    [[SFPushNotificationManager sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    if ([SFUserAccountManager sharedInstance].currentUser.credentials.accessToken != nil) {
        [[SFPushNotificationManager sharedInstance] registerForSalesforceNotifications];
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // Respond to any push notification registration errors here.
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateActive ) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        localNotification.alertBody = message;
        
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark - Private methods

- (void)initializeAppViewState
{
    self.window.rootViewController = [[InitialViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
}

- (void)setupRootViewController
{
    //RootViewController *rootVC = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    //UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    //UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //UIViewController *vc =[storybord instantiateInitialViewController];
    
    AnimatedSplashViewController *vc = [[AnimatedSplashViewController alloc] initWithNibName:@"AnimatedSplashViewController" bundle:nil];
    
    self.window.rootViewController = vc;
}

- (void)resetViewState:(void (^)(void))postResetBlock
{
    if ([self.window.rootViewController presentedViewController]) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            postResetBlock();
        }];
    } else {
        postResetBlock();
    }
}

- (void)handleSdkManagerLogout
{
    [self log:SFLogLevelDebug msg:@"SFAuthenticationManager logged out.  Resetting app."];
    [self resetViewState:^{
        [self initializeAppViewState];
        
        // Multi-user pattern:
        // - If there are two or more existing accounts after logout, let the user choose the account
        //   to switch to.
        // - If there is one existing account, automatically switch to that account.
        // - If there are no further authenticated accounts, present the login screen.
        //
        // Alternatively, you could just go straight to re-initializing your app state, if you know
        // your app does not support multiple accounts.  The logic below will work either way.
        NSArray *allAccounts = [SFUserAccountManager sharedInstance].allUserAccounts;
        if ([allAccounts count] > 1) {
            SFDefaultUserManagementViewController *userSwitchVc = [[SFDefaultUserManagementViewController alloc] initWithCompletionBlock:^(SFUserManagementAction action) {
                [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
            }];
            [self.window.rootViewController presentViewController:userSwitchVc animated:YES completion:NULL];
        } else {
            if ([allAccounts count] == 1) {
                [SFUserAccountManager sharedInstance].currentUser = ([SFUserAccountManager sharedInstance].allUserAccounts)[0];
            }
            
            [[SalesforceSDKManager sharedManager] launch];
        }
    }];
}

- (void)handleUserSwitch:(SFUserAccount *)fromUser
                  toUser:(SFUserAccount *)toUser
{
    [self log:SFLogLevelDebug format:@"SFUserAccountManager changed from user %@ to %@.  Resetting app.",
     fromUser.userName, toUser.userName];
    [self resetViewState:^{
        [self initializeAppViewState];
        [[SalesforceSDKManager sharedManager] launch];
    }];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)notification
{
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])
        return;
    @try {
        NetworkReachability* curReach = [notification object];
//        NSParameterAssert([curReach isKindOfClass:[NetworkReachability class]]);
        
        if([curReach currentReachabilityStatus] == NotReachable) {
            self.isReachable = NO;
            if(![self.customAlertView isVisible]) {
                [self.customAlertView show];
            }
        }
        else {
            self.isReachable = YES;
            if([self.customAlertView isVisible]) {
                [self.customAlertView close];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

@end
