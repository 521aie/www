//
//  TagLibraryRNModel.m
//  RestApp
//
//  Created by 忘忧 on 16/9/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TagLibraryRNModel.h"
#import "SmartOrderRNManager.h"
#import "RNNativeActionManager.h"
#import "RNRootURL.h"

#import "RCTRootView.h"
#import "RCTBundleURLProvider.h"
#import "RCTLinkingManager.h"

#import "MBProgressHUD.h"
#import "HelpDialog.h"

@implementation TagLibraryRNModel

- (id)init
{
    self = [super init];
    if (self) {
//        NSURL *jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
        NSURL *jsCodeLocation = [RNRootURL shareInstance].indexUrl;
        RCTRootView *rootView =
        [[RCTRootView alloc] initWithBundleURL : jsCodeLocation
                             moduleName        : @"Project"
                             initialProperties : @{@"initID" : @"tagLibrary",
                                                   @"language" : @"zh_CN"}
                              launchOptions    : nil];
        self.view = rootView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHub) name:RNShowHubNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHub) name:RNHideHubNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVC:) name:RNPopVCNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helpAction:) name:RNHelpActionNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)popVC:(NSNotification*) notification
{
    if (!self.view.window) { return; }
    //pop时需要在主线程完成
    dispatch_async(dispatch_get_main_queue(), ^{
        [TDF_ROOT_NAVIGATION_CONTROLLER popViewControllerAnimated:YES];
        BOOL isChange = [[notification object] boolValue];
        if (self.callBack) {
            self.callBack(isChange);
        }
    });
    
}

- (void)helpAction:(NSNotification*)notification {
    
    NSDictionary * notificationDic = (NSDictionary *)[notification object];
    
    if (notificationDic) {
        NSString * helpActionKey = notificationDic[@"helpAction"];
        
        if (helpActionKey) {
            if ([helpActionKey isEqualToString:@"HelpAction_TagLibrary"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"RNMaterialLibrary"];
                });
                return;
            }
        }
    }
    
}

#pragma mark - MBProgressHUD
- (void)showHub {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)hideHub {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}


@end
