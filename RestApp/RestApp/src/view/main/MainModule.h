//
//  MainModule.h
//  RestApp
//
//  Created by zxh on 14-3-31.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "XHButton.h"
#import <UIKit/UIKit.h>
#import "MenuSelectHandle.h"
#import "TDFBranchCompanyListViewController.h"

@class AppController,SystemService,MBProgressHUD,PaymentModule,HomeModule;
@class AboutView,BackgroundView,MarketModule,MemberModule;
@class SettingModule,SeatModule,MenuModule,KabawModule;
@class RawModule,LogisticModule,StockModule, ReportModule,SuitMenuModule,XHButton,BrandModule, BillModifyModule,TDFBranchCompanyViewController;
@class SmartOrderModel;

@interface MainModule : UIViewController
{
    SystemService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UINavigationController *rootController;
@property (nonatomic, strong) IBOutlet UIView *mainContainer;
@property (nonatomic, strong) IBOutlet XHButton *navigateBtn;
@property (nonatomic, strong) HomeModule *homeModule;
@property (nonatomic, strong) SeatModule *seatModule;
@property (nonatomic, strong) SettingModule *settingModule;
@property (nonatomic, strong) MenuModule *menuModule;
@property (nonatomic, strong) KabawModule *kabawModule;
@property (nonatomic, strong) PaymentModule *paymentModule;
@property (nonatomic, strong) SuitMenuModule *suitMenuModule;
@property (nonatomic, strong) MarketModule *marketModule;
@property (nonatomic, strong) ReportModule *reportModule;
@property (nonatomic, strong) RawModule *rawModule;
@property (nonatomic, strong) LogisticModule *logisticModule;
@property (nonatomic, strong) StockModule *stockModule;
@property (nonatomic, strong) BillModifyModule *billModifyModule;
@property (nonatomic, strong) SmartOrderModel *smartOrdermodel;
@property (nonatomic, strong) TDFBranchCompanyViewController *branchCompanyViewController;

@property (nonatomic,copy) void (^reSetRootVCFromeMainModuleCallBack)(void);


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)onMenuSelectHandle:(UIMenuAction *)action;

- (void)backMenuBySelf:(UIViewController *)viewController;

-(void)backMenu:(UIViewController *)viewController;

- (void)forwardToModule:(NSString *)code;

+ (MainModule *)sharedInstance;

- (void)showEntryView;

- (void)showMainView;

- (void)hideView;

- (void)showLogin;

//加载商品模块.
- (void)loadMenuModule;

//加载桌位模块.
- (void)loadSeatModule;

//加载营业模块.
- (void)loadSettingModule;

//加载火小二模块.
- (void)loadKabawModule;

//加载微信支付模块.
- (void)loadPaymentModule;

//加载传菜模块.
//- (void)loadTransModule;

//加载账单优化模块
- (void)loadBillModifyModule;

//加载营销模块.
- (void)loadMarketModule;

//加载套餐模块.
- (void)loadSuitMenuModule;

//加载挂账处理模块.


//加载报表模块.
- (void)loadReportModule;

//加载物流
- (void)loadRawModule;

//加载物流模块
- (void)loadLogisticModule;

//加载库存模块
- (void)loadStock;

//加载智能点餐模块
-(void)loadSmartOrderModel;

@end
