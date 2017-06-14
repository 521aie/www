
//
//  MainUnit.m
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainUnit.h"
#import "TDFOtherMenuViewController.h"
#import "MainModule.h"
#import "SystemUtil.h"
#import "NavigateMenu.h"
#import "AppController.h"
#import "BackgroundHelper.h"
#import "XHMenuController.h"
#import "TDFNavigateMenuViewController.h"
#import "TDFHomePageViewController.h"
#import "Platform.h"
#import "TDFRightMenuController.h"
#import "TDFRightMenuController.h"

static MainUnit *instance;


@implementation MainUnit

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopWorkStatusChange:) name:Notification_ShopWorkStatus_Change object:nil];
    
    [self initMainModule];
    [self initNotification];
    
    if(self.showType == TDFMainShowTypeEntryView) {
        [self showEntryView];
        [self.otherMenu resetShopInfo];
    }else {
        [self showMainView];
    }
}

- (void)shopWorkStatusChange:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    
    if([object[@"hasWorkShop"] integerValue] == 1) {
        self.showType = TDFMainShowTypeHomeView;
        [self showMainView];
    }else {
        self.showType = TDFMainShowTypeEntryView;
        [self showEntryView];
        [self.otherMenu resetShopInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.latestHomeViewController viewWillAppearByHand];
    [self.navigateMenu viewWillAppearByHand];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initMainModule
{
    self.menuController = [[XHMenuController alloc] initWithRootViewController:self.latestHomeViewController];

    self.navigateMenu = [[TDFNavigateMenuViewController alloc] init];
    self.menuController.leftController = self.navigateMenu;
    
    self.otherMenu = [[TDFRightMenuController alloc] init];
    self.menuController.rightController = self.otherMenu;
    [self.view addSubview:self.menuController.view];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainShow:) name:UI_MAIN_SHOW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherShow:) name:UI_OTHER_SHOW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherHidden:) name:UI_OTHER_HIDDEN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateShow:) name:UI_NAVIGATE_SHOW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateHidden:) name:UI_NAVIGATE_HIDDEN_NOTIFICATION object:nil];
}

- (void)mainShow:(NSNotification *) notification
{
    [self.menuController showRootController];
}

- (void)otherHidden:(NSNotification *) notification
{
    [self.menuController showRootController];
}

- (void)otherShow:(NSNotification *) notification
{
    [self.menuController showRightController];
}

- (void)navigateHidden:(NSNotification *) notification
{
    [self.menuController showRootController];
}

- (void)navigateShow:(NSNotification *) notification
{
    [self.menuController showLeftController];
}

- (void)showEntryView
{
    [self.latestHomeViewController showEntryView];
}

- (void)showMainView
{
    [self.latestHomeViewController showHomeView];
}

- (TDFHomePageViewController *)latestHomeViewController
{
    if (!_latestHomeViewController) {
        _latestHomeViewController = [[TDFHomePageViewController alloc] init];
        @weakify(self);
        [_latestHomeViewController setReSetRootVCFromeMainModuleCallBack:^{
            @strongify(self);
            !self.reSetRootVCFromeMainUnitCallBack?:self.reSetRootVCFromeMainUnitCallBack();
        }];
    }
    
    return _latestHomeViewController;
}

@end
