//
//  MainModule.m
//  RestApp
//
//  Created by zxh on 14-3-31.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "User.h"
#import "EntryView.h"
#import "MainModule.h"
#import "SettingModule.h"
#import "SeatModule.h"
#import "MenuModule.h"
#import "KabawModule.h"
#import "SuitMenuModule.h"
#import "UIView+Sizes.h"
#import "BackgroundHelper.h"
#import "RemoteEvent.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIMenuAction.h"
#import "ActionConstants.h"
#import "MenuSelectHandle.h"
#import "AppController.h"
#import "AlertBox.h"
#import "BackgroundHelper.h"
#import "XHAnimalUtil.h"
#import "AboutView.h"
#import "BackgroundView.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "EntryUnit.h"
#import "ShopCodeView.h"
#import "MarketModule.h"
#import "SystemService.h"
#import "UIView+Sizes.h"
#import "Platform.h"
#import "MBProgressHUD.h"
#import "PaymentModule.h"
#import "AliPayResultUtil.h"
#import "RemoteResult.h"
#import "RestConstants.h"
#import "ReportModule.h"
#import "EventConstants.h"
#import "ServiceFactory.h"
#import "SmartOrderModel.h"
#import <AVFoundation/AVFoundation.h>
#import "BillModifyModule.h"
#import "TDFMediator+ChainEmployeeModule.h"
#import "TDFMediator+EmployeeModule.h"
#import "TDFMediator+ChainModule.h"
#import "TDFMediator+BrandModule.h"
#import "TDFMediator+StoresModule.h"
#import "TDFMediator+BranchCompanyModule.h"
#import "TDFMediator+BillModifyModule.h"
#import "TDFSSOService.h"
#import "TDFPaymentModule.h"
#import "TDFMediator+MemberModule.h"
#import "TDFMediator+PaymentModule.h"
#import "TDFMediator+SignBillModule.h"
#import "TDFLoginService.h"
#import "AppDelegate.h"

#import "TDFChainService.h"
#import "TDFChainMenuViewController.h"
#import "TDFMediator+ChainMenuModule.h"
#import "TDFMediator+ReportWeb.h"


static MainModule *instance;

@implementation MainModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        instance = self;
        service = [ServiceFactory Instance].systemService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (UINavigationController *)rootController
{
    if (!_rootController) {
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            _rootController = (UINavigationController *)viewController;
        }else if ([viewController isKindOfClass:[UIViewController class]])
        {
            _rootController = viewController.navigationController;
        }
    }
    return _rootController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainModule];
    [self initNotification];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSesstion:) name:Notification_Logout_Session object:nil];
}

- (void)initMainModule
{
    self.homeModule = [[HomeModule alloc] initWithNibName:@"HomeModule"bundle:nil parent:self];
    
    [self.mainContainer addSubview:self.homeModule.view];
}

+ (MainModule *)sharedInstance
{
    return instance;
}

- (void)showEntryView
{
    [self hideView];
    self.homeModule.view.hidden = NO;
    [self.homeModule showEntryView];
    [self.homeModule initEntryDataView];
}

- (void)showMainView
{
    [self hideView];
    self.homeModule.view.hidden = NO;
    [self.homeModule showHomeView];
    [self.homeModule initHomeDataView];
}

//新增方法，替代backMenu
- (void)backMenuBySelf:(UIViewController *)module
{
    [self hideView];
    //[self recycleModule:module];
  //  [appController showNavigateBtn:NO];
    self.homeModule.view.hidden = NO;
    [AccountCenter setUserChangeShopType:@"1"];
    self.homeModule.homeView.warningViewBox.hidden = YES;
    [self.homeModule.homeView loadBusiness];
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromLeft];

}

-(void)backMenu:(UIViewController *)viewController{

    [self hideView];
    self.homeModule.view.hidden = NO;
    [AccountCenter setUserChangeShopType:@"1"];
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromLeft];
}
- (void)recycleModule:(UIViewController *)module
{    
    [module.view removeFromSuperview];
    if (self.settingModule == module) {
        self.settingModule = nil;
    } else if (self.menuModule == module) {
        self.menuModule = nil;
    } else if (self.kabawModule == module) {
        self.kabawModule = nil;
    } else if (self.billModifyModule == module) {
        self.billModifyModule = nil;
    }else if (self.paymentModule == module) {
        self.paymentModule = nil;
    } else if (self.suitMenuModule == module) {
        self.suitMenuModule = nil;
    } else if (self.marketModule == module) {
        self.marketModule = nil;
    } else if (self.reportModule == module) {
        self.reportModule = nil;
    } else if (self.seatModule == module) {
        self.seatModule = nil;
    }
    else if (self.smartOrdermodel == module)
    {
        self.smartOrdermodel =nil;
    }
}

-(void)showLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_OTHER_HIDDEN_NOTIFICATION object:nil];
}

- (void)onMenuSelectHandle:(UIMenuAction *)action
{
    if ([action.code isEqualToString:PAD_SET]) {                 //设置.
        [self hideView];
        [self loadSettingModule];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    }
//    else if ([action.code isEqualToString:PAD_MENU]) {         //商品.
////        [self hideView];
////        [self loadMenuModule];
////        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
//        
//        
//    }
    else if ([action.code isEqualToString:PAD_KABAW]) {        //卡包.
        
        [self loadKabawModule];
    } else if ([action.code isEqualToString:PAD_SUIT_MENU]) {    //套餐.
        [self hideView];
        [self loadSuitMenuModule];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_EMPLOYEE]) {     //员工.
        
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *employeeListContoller = [mediator TDFMediator_employeeListViewController];
        [self.rootController pushViewController:employeeListContoller animated:NO];
        
    } else if ([action.code isEqualToString:PAD_SEAT]) {         //座位.
        [self hideView];
        [self loadSeatModule];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
//    } else if ([action.code isEqualToString:PAD_PAYMENT] ||[action.code isEqualToString:PAD_BRAND_PAYMENT] ) {      //微信支付.
//        [self loadPaymentModule];
    } else if ([action.code isEqualToString:PAD_EVALUATE]) {     //顾客评价.
//        [self hideView];
//        [self loadEvaluateModule];
//       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_ACCOUNT_OPERATION]) { //账单优化
        [self hideView];
        [self loadBillModifyModule];
        
//        TDFMediator *mediator = [[TDFMediator alloc] init];
//        UIViewController *billModify = [mediator TDFMediator_billModifyViewController];
//        [self.rootController.navigationController pushViewController:billModify animated:NO];
   
    } else if ([action.code isEqualToString:PAD_MENU_TIME]) {    //商品促销.
        [self forwardToModule:PAD_MENU_TIME];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_MARKET]) {       //营销.
        [self hideView];
        [self loadMarketModule];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_ISSUE_INFO]) {   //生活圈.
        [self forwardToModule:PAD_ISSUE_INFO];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_SMS_MARKET]) {   //短信营销.
        [self forwardToModule:PAD_SMS_MARKET];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_SHOP_QRCODE]) {  //微店营销
        [self forwardToModule:PAD_SHOP_QRCODE];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_RED_PACKETS]) {  //营销.
        [self forwardToModule:PAD_RED_PACKETS];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_RAW]) {          //原料
        [self hideView];
        [self loadRawModule];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_LOGISTIC]) {     //物流
        [self hideView];
        [self loadLogisticModule];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_STOCK]) {        //库存
        [self hideView];
        [self loadStock];
        
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:PAD_SIGN_BILL]) {    //挂账处理
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_signBillViewController];
        [self.rootController pushViewController:viewController animated:YES];
    } else if ([action.code isEqualToString:PAD_REPORT]) {       //报表
        
        [self loadReportModule];

    }else if ([action.code isEqualToString:PAD_MEMBER] || [action.code isEqualToString:PAD_BRAND_MEMBER]) {       //会员
        
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_tdfMemberViewControllerWithData:nil];
        [self.rootController pushViewController:vc animated:YES];
    }
    else if ([action.code isEqualToString:PHONE_BRAND_GROUP])    //总部信息
    {
        [self loadChainBusinessModel];
    }
    else if ([action.code isEqualToString:PHONE_BRAND_SHOP] || [action.code isEqualToString:PHONE_BRANCH_SHOP])//门店
    {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *viewController = [mediator TDFMediator_storesListViewController];
        [self.rootController pushViewController:viewController animated:YES];
    }
    else if ([action.code isEqualToString:PHONE_BRAND_PLATE] || [action.code isEqualToString:PHONE_BRANCH_PLATE])//品牌
    {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *brandListContoller = [mediator TDFMediator_brandManagerListViewControllerWithBrandCallBack:^(BOOL orFresh) {
            
        }];
        [self.rootController pushViewController:brandListContoller animated:YES];
    }
    else if ([action.code isEqualToString:PHONE_BRAND_USER] || [action.code isEqualToString:PHONE_BRANCH_USER])
    {
       TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *chainEmployeeListContoller = [mediator TDFMediator_chainEmployeeListViewController];
        [self.rootController pushViewController:chainEmployeeListContoller animated:YES];
    }
    else if ([action.code isEqualToString:PHONE_SMART_MENU])
    {
        [self hideView];
        [self loadSmartOrderModel];
       [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];

    }
    else if ([action.code isEqualToString:PHONE_BRAND_BRANCH] ||[action.code isEqualToString:PHONE_BRANCH_MANAGE]  ) //分公司
    {
        TDFMediator *mediator = [[TDFMediator alloc] init];         
         UIViewController *branchListContoller = [mediator TDFMediator_branchCompanyListViewControllerWithType:ModuleType delegate:nil branchCompanyList:nil branchCompanyListArr:nil isFromBranchEditView:NO listCallBack:^(BOOL orFresh) {
             
         }];
        [self.rootController pushViewController:branchListContoller animated:YES];
    }
    else if ([action.code isEqualToString:PHONE_BRAND_MENU] || [action.code isEqualToString:PAD_MENU]) //连锁商品
    {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *chainMenuViewController = [mediator TDFMediator_TDFChainMenuViewController];
        [self.rootController.navigationController pushViewController:chainMenuViewController animated:YES];
    }
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        
    }
}

- (void)forwardToModule:(NSString *)code
{
    if ([code isEqualToString:PAD_MENU]) {
        [self hideView];
        [self loadMenuModule];
        [self.menuModule loadMenus];
    }
    else if ([code isEqualToString:PAD_SUIT_MENU]) {    //套餐.
        [self hideView];
        [self loadSuitMenuModule];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    }else if ([code isEqualToString:PAD_CARD_SHOPINFO]) {
//        [self hideView];
        [self loadKabawModule];
        [self.kabawModule showActionCode:PAD_CARD_SHOPINFO];
    } else if ([code isEqualToString:PAD_SMS_MARKET]) {
        [self hideView];
        [self loadMarketModule];
        [self.marketModule showActionCode:PAD_SMS_MARKET];
    } else if ([code isEqualToString:PAD_MENU_TIME]) {
        [self hideView];
        [self loadMarketModule];
        [self.marketModule showActionCode:PAD_MENU_TIME];
    } else if ([code isEqualToString:PAD_ISSUE_INFO]) {
        [self hideView];
        [self loadMarketModule];
        [self.marketModule showActionCode:PAD_ISSUE_INFO];
    } else if ([code isEqualToString:PAD_RED_PACKETS]) {
        [self hideView];
        [self loadMarketModule];
        [self.marketModule showActionCode:PAD_RED_PACKETS];
    } else if ([code isEqualToString:PAD_PAYMENT]) {
        [self loadPaymentModule];
        return;
    } else if ([code isEqualToString:PAD_SHOP_QRCODE]) {
//        [self hideView];
        [self loadKabawModule];
        [self.kabawModule showActionCode:PAD_SHOP_QRCODE];
//        self.kabawModule.shopCodeView.backIndex = INDEX_MAIN_VIEW;
    } else if ([code isEqualToString:PAD_BLACK_LIST]) {
//        [self hideView];
        [self loadKabawModule];
        [self.kabawModule showActionCode:PAD_BLACK_LIST];
    }else if ([code isEqualToString:PHONE_MENU_PICTURE_PAGE]) {   // 页首页尾
        [self loadKabawModule];
        [self.kabawModule showActionCode:PHONE_MENU_PICTURE_PAGE];
    } else if ([code isEqualToString:PHONE_CHANGE_SKIN]) {        // 个性化换肤
        [self loadKabawModule];
        [self.kabawModule showActionCode:PHONE_CHANGE_SKIN];
    } else if ([code isEqualToString:PAD_REPORT]) {
        [self hideView];
        [self loadReportModule];
    } else if ([code isEqualToString:PHONE_BRAND_GROUP])//连锁营业
    {
        [self hideView];
        [self loadChainBusinessModel];
        
    }
    else if([code isEqualToString:PAD_CHAINEMPLOYEE])
    {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *chainEmployeeListContoller = [mediator TDFMediator_chainEmployeeListViewController];
        [self.rootController pushViewController:chainEmployeeListContoller animated:NO];
    }
    else if ([code isEqualToString:PHONE_SMART_MENU])
    {
       [self hideView];
        [self  loadSmartOrderModel];
    }
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
}

- (void)hideView
{
    for (UIView *view in [self.mainContainer subviews]) {
        [view setHidden:YES];
    }
}

- (void)logoutSesstion:(NSNotification *)notification
{
    !self.reSetRootVCFromeMainModuleCallBack?:self.reSetRootVCFromeMainModuleCallBack();
}

//加载营业模块.
- (void)loadSettingModule
{
    if (self.settingModule) {
        self.settingModule.view.hidden=NO;
    } else {
        self.settingModule = [[SettingModule alloc] initWithNibName:@"SettingModule"bundle:nil parent:self];
        [self.mainContainer addSubview:self.settingModule.view];
    }
    [self.settingModule showMenu];
} 

//加载商品模块.
- (void)loadMenuModule
{
    if (self.menuModule) {
        self.menuModule.view.hidden=NO;
    } else {
        self.menuModule = [[MenuModule alloc] initWithNibName:@"MenuModule"bundle:nil parent:self];
        [self.mainContainer addSubview:self.menuModule.view];
        
    }
    [self.menuModule loadMenus];
}

//加载火小二模块.
- (void)loadKabawModule
{
   
    [[[TDFLoginService alloc] init]cashierVersionWithParams:@{@"cashier_version_key":@"cashVersion4Takeout" }
     
                                                     sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                         [self hideView];
                                                         if (self.kabawModule) {
                                                             self.kabawModule.view.hidden=NO;
                                                         } else {
                                                             self.kabawModule = [[KabawModule alloc] initWithNibName:@"KabawModule"bundle:nil parent:self];
                                                             [self.mainContainer addSubview:self.kabawModule.view];
                                                         }

                                                        if ([data objectForKey:@"data"]) {
                                                             self.kabawModule.isShow = [[data objectForKey:@"data"] boolValue];
                                                         }
                                                         [self.kabawModule showMenu];
                                                         [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
                                                     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                         [AlertBox show:error.localizedDescription];
                                                     }];
    
}

//加载座位模块.
- (void)loadSeatModule
{
    if (self.seatModule) {
        self.seatModule.view.hidden=NO;
    } else {
        self.seatModule = [[SeatModule alloc] initWithNibName:@"SeatModule"bundle:nil parent:self];
        [self.mainContainer addSubview:self.seatModule.view];
    }
    [self.seatModule loadSeatData];
}

//加载营销模块.
- (void)loadMarketModule
{
    if (self.marketModule) {
        self.marketModule.view.hidden=NO;
    } else {
        self.marketModule = [[MarketModule alloc] initWithNibName:@"MarketModule"bundle:nil parent:self];
        [self.mainContainer addSubview:self.marketModule.view];
    }
}

//加载电子支付模块
- (void)loadPaymentModule
{
    NSArray *menus = [TDFPaymentModule menuActions:self.homeModule.homeView.shopInfo];
    if (menus.count >1) {
//        [self.rootController pushViewController:[[TDFMediator sharedInstance] TDFMediator_paymentTypeViewControllerWithShopInfo:nil menus:menus] animated:YES];
    }else{
        TDFPaymentTypeVo *action = menus.lastObject;
        if (action) {
//            [self.rootController pushViewController:[[TDFMediator sharedInstance] TDFMediator_orderPayListViewControllerWithShopInfo:nil action:action isAccount:YES] animated:YES];
        }
    }
}
//加载账单优化模块.
- (void)loadBillModifyModule
{
    if (self.billModifyModule) {
       self.billModifyModule.view.hidden = NO;
    }else {
        self.billModifyModule = [[BillModifyModule alloc] init];
        [self.mainContainer addSubview:self.billModifyModule.view];
    }
//    [self.billModifyModule loadDatas];
//    UIViewController *billModifyView = [[TDFMediator sharedInstance]TDFMediator_billModifyViewController];
//    [self.billModifyModule.navigationController pushViewController:billModifyView animated:YES];
}
//加载套餐模块.
- (void)loadSuitMenuModule
{
    if (self.suitMenuModule) {
        self.suitMenuModule.view.hidden=NO;
    } else {
        self.suitMenuModule = [[SuitMenuModule alloc] initWithNibName:@"SuitMenuModule"bundle:nil parent:self];
        [self.mainContainer addSubview:self.suitMenuModule.view];
    }
    [self.suitMenuModule loadMenus];
}

//加载挂账处理模块.


//加载会员模块.
//- (void)loadMemberModule
//{
//    if (self.memberModule) {
//        self.memberModule.view.hidden=NO;
//    } else {
//        self.memberModule = [[MemberModule alloc] initWithNibName:@"MemberModule"bundle:nil parent:self];
//        [self.mainContainer addSubview:self.memberModule.view];
//    }
//    [self.memberModule initMainView];
//}

//加载报表模块
- (void)loadReportModule
{
    TDFSSOService *ssoService = [[TDFSSOService alloc] init];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.rootController.view animated:YES];
    hud.labelText = NSLocalizedString(@"正在加载...", nil);
    
    @weakify(self);
    
    NSDictionary *params = @{
                             @"device_id" : [Platform Instance].deviceId? : @"",
                             @"app_key" : APP_BOSS_API_KEY,
                             @"s_os" : @"iOS"
    };
    
    [ssoService grantPandoraTicketWithParams:params success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        @strongify(self);
        
        if ([responseObject[@"code"] integerValue] ==1) {
            
            NSString *token = responseObject[@"data"];
            
            if ([token isKindOfClass:[NSString class]] && token.length > 0) {
                
                NSString *urlString = [NSString stringWithFormat:@"%@/rq/reports.html?appType=RestApp&appVer=5.5.54&deviceType=4&hideBar=1&st=%@", kTDFPandoraReportURLRoot, token];
                
                UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reportWebViewControllerWithURL:urlString];
                
                [self.rootController pushViewController:viewController animated:YES];
                
                [HUD hide:YES];
            }else {
                HUD.labelText = NSLocalizedString(@"加载失败，请重试", nil);
                
                [HUD hide:YES afterDelay:1.2f];
            }
            
            
            
        }else {
            HUD.labelText = NSLocalizedString(@"加载失败，请重试", nil);
            
            [HUD hide:YES afterDelay:1.2f];
        }
       
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        HUD.labelText = NSLocalizedString(@"加载失败，请重试", nil);
        
        [HUD hide:YES afterDelay:1.2f];
    }];
    
    
}

//加载连锁营业模块
- (void)loadChainBusinessModel
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_chainBusinessViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

//加载智能点餐模块
-(void)loadSmartOrderModel
{
    if (self.smartOrdermodel) {
        self.smartOrdermodel.view.hidden =NO;
    }
    else
    {
        self.smartOrdermodel =[[SmartOrderModel alloc]initWithNibName:@"SmartOrderModel"bundle:nil parent:self];
        [self.mainContainer addSubview:self.smartOrdermodel.view];
    }
    [self.smartOrdermodel loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
