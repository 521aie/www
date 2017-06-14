//
//  TDFSwitchTool.m
//  RestApp
//
//  Created by 黄河 on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSwitchTool.h"
#import "Platform.h"
#import "ActionConstants.h"
#import "TDFMediator.h"
#import "TDFSSOService.h"
#import "MBProgressHUD.h"
#import "RestAppConstants.h"
#import "TDFMediator+ReportWeb.h"
#import "TDFMediator+BranchCompanyModule.h"
#import "TDFBranchCompanyListViewController.h"
#import "TDFMediator+BrandModule.h"
#import "TDFMediator+MemberModule.h"
#import "TDFMediator+PaymentModule.h"
#import "TDFMediator+SKBaseSetting.h"
#import "TDFMediator+ExchangeSkin.h"
#import "TDFPaymentModule.h"
#import "TDFPaymentTypeVo.h"
#import "TDFKBAuthListController.h"
#import "TDFMediator+AccountRechargeModule.h"
#import "TDFMediator+MemberLevelModule.h"
#import "ShopInfoVO.h"
#import "TDFMediator+SettingModule.h"
#import "TDFMediator+IssueCenter.h"

#import <UMMobClick/MobClick.h>
#import "SmartOrderSettingRNModel.h"
#import "RNNativeActionManager.h"

////////test////////////////
#import "TDFMediator+TransModule.h"
////////////////////////////

@interface TDFSwitchTool ()

//旧RN需要用通知跳转
@property(nonatomic, strong)SmartOrderSettingRNModel * RNSmartOrder;

@end

@implementation TDFSwitchTool
static TDFSwitchTool *switchTool;
+ (instancetype)switchTool {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        switchTool = [TDFSwitchTool new];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:switchTool selector:@selector(RNDidMount:) name:RNDidMountNotification object:nil];
    
    return switchTool;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter]removeObserver:switchTool];
}

- (void)pushViewControllerWithCode:(NSString *)actionCode
                         andObject:(NSArray *)codeArray
                         andObject:(NSArray *)childFunctionArr
                withViewController:(UIViewController *)currentViewController
{
    if (currentViewController.navigationController) {
        self.rootViewController = currentViewController.navigationController;
    }else
    {
        self.rootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    }

    NSDictionary *switchU = [Platform Instance].allFunctionSwitchDictionary[actionCode];
    if (switchU[@"mediatorMethod"]) {
        SEL action = NSSelectorFromString(switchU[@"mediatorMethod"]);
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"actionCodeArrs"] = codeArray;
        params[@"isOpenFunctionArrs"] = childFunctionArr;
        if ([[TDFMediator sharedInstance] respondsToSelector:action]) {
            UIViewController *viewController = [[TDFMediator sharedInstance] performSelector:action withObject:params withObject:nil];
            if ([viewController isKindOfClass:[UIViewController class]]) {
                [self.rootViewController pushViewController:viewController animated:YES];
            }
            return;
        }
    }
    
    if ([actionCode isEqualToString:PAD_WEIXIN] ||
        [actionCode isEqualToString:PHONE_BRAND_PROCEEDS_DETAL]/*电子收款明细*/) {
        [self loadPaymentModuleWithCodeArray:codeArray ];
    }else if ([actionCode isEqualToString:PHONE_KOUBEI_SHOP]/*开通口碑店*/) {
        [self koubei];
    }else if ([actionCode isEqualToString:TO_SUPPLY_MANAGE]/*供应链*/) {
        [self showSupolyManage];
    }else if ([actionCode isEqualToString:PHONE_BRAND_BRANCH] || [actionCode isEqualToString:PHONE_BRANCH_MANAGE]) /*分公司*/
    {
        [self switchToBranch];
    }else if ([actionCode isEqualToString:PHONE_BRANCH_PLATE] || [actionCode isEqualToString:PHONE_BRAND_PLATE]) /*品牌*/
    {
        [self switchToPlate];
    }else if ([actionCode isEqualToString:@"PHONE_KOUBEI_DISCOUNT"])
    {
        [self AliPayKouBei];
    }
    else if ([actionCode isEqualToString:@"MEMBER_REPORT"]
             || [actionCode isEqualToString:@"PHONE_MARKET"]/*智能运营中心*/
             || [actionCode isEqualToString:@"PHONE_ONEKEY_MARKET"]/*会员分析*/
             || [actionCode isEqualToString:@"PHONE_MARKET_ANALYSIS"]/*经营分析*/) {
        TDFSSOService *ssoService = [[TDFSSOService alloc] init];
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:currentViewController.view animated:YES];
        HUD.labelText = NSLocalizedString(@"正在加载...", nil);
        
//        @weakify(self);
        
        NSDictionary *params = @{
                                 @"device_id" : [Platform Instance].deviceId? : @"",
                                 @"app_key" : APP_BOSS_API_KEY,
                                 @"s_os" : @"iOS"
                                 };
        
        [ssoService grantPandoraTicketWithParams:params success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
//            @strongify(self);
            
            if ([responseObject[@"code"] integerValue] ==1) {
                
                NSString *token = responseObject[@"data"];
                
                if ([token isKindOfClass:[NSString class]] && token.length > 0) {
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    NSString *urlString;
                    if ([actionCode isEqualToString:@"MEMBER_REPORT"]) {
                         urlString = [NSString stringWithFormat:@"%@/rq/reports.html?appType=AT-SK-001&appVer=%@&deviceType=4&hideBar=1&st=%@", kTDFPandoraReportURLRoot,version ,token];
                    }else if ([actionCode isEqualToString:@"PHONE_MARKET"]) {
                        urlString = [NSString stringWithFormat:@"%@/ic/ic_index.html?appType=AT-SK-001&appVer=%@&deviceType=4&hideBar=1&st=%@", kTDFPandoraReportURLRoot, version,token];
                    }else if ([actionCode isEqualToString:@"PHONE_ONEKEY_MARKET"]) {
                        urlString = [NSString stringWithFormat:@"%@/ic/member.html?st=%@", kTDFPandoraReportURLRoot, token];
                    }else if ([actionCode isEqualToString:@"PHONE_MARKET_ANALYSIS"]) {
                        urlString = [NSString stringWithFormat:@"%@/ic/analyze.html?st=%@", kTDFPandoraReportURLRoot, token];
                    }
                    
                    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reportWebViewControllerWithURL:urlString];
                    
                    [self.rootViewController pushViewController:viewController animated:YES];
                    
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
        
    }else if ([actionCode isEqualToString:PAD_BRAND_KIND_PAY]) {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *brandKindPayContoller = [mediator TDFMediator_BrandKindPayListView];
        [self.rootViewController pushViewController:brandKindPayContoller animated:YES];
    } else if ([actionCode isEqualToString:@"PHONE_BRAND_CASH_SWITCH"] ||[actionCode isEqualToString:@"PHONE_CASH_SWITCH"])
    {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance]TDFMediator_nativeViewControllerForCashRegisterSwitchWithStoreType:[[Platform Instance] isChain]?0:1] animated:YES];
    }else if ([actionCode isEqualToString:@"PHONE_BRAND_CASH_RRINT"] ||[actionCode isEqualToString:@"PAD_CASH_OUTPUT"])
    {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance]TDFMediator_nativeViewControllerForCashierPrinterWithStoreType:[[Platform Instance] isChain]?0:1] animated:YES];
    }else if ([actionCode isEqualToString:PAD_MENU_TIME]) {  //促销商品
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_MenuTimeListView];
        [self.rootViewController pushViewController:viewController animated:YES];
    } else if ([actionCode isEqualToString:PHONE_BRAND_EXCHANGE_SET]) {
        
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance] TDFMediator_tdfGiftListViewControllerWithParams:nil] animated:YES];
        
    }else if ([actionCode isEqualToString:PHONE_BRAND_DISCOUNT_COUPON])//优惠券
    {
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_TDFMemChooseBrandControllerWithType:@"2"];
        [self.rootViewController pushViewController:vc animated:YES];
        return;
    }else if ([actionCode isEqualToString:PHONE_BRAND_SALES_PROMOTION])//促销活动
    {
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_TDFMemChooseBrandControllerWithType:@"3"];
        [self.rootViewController pushViewController:vc animated:YES];
        return;
    }else if ([actionCode isEqualToString:PHONE_BRAND_PRIVILEGE_SET])//优惠权限设置
    {
        
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_TDFMemChooseBrandControllerWithType:@"1"];
        [self.rootViewController pushViewController:vc animated:YES];
        return;
    }else if ([actionCode isEqualToString:PHONE_BRAND_SHOP_MANAGE]){
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *viewController = [mediator TDFMediator_MemberManagerViewController];
        [self.rootViewController  pushViewController:viewController animated:YES];
    }else if ([actionCode isEqualToString:PHONE_BRAND_NOTE_MARKETING])
    {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance] TDFMediator_smsListViewControllerWithParams:nil] animated:YES];
    }else if ([actionCode isEqualToString:@"PHONE_SMART_MENU_TEMPLATE"]) {
    
        [MBProgressHUD showHUDAddedTo:self.rootViewController.view animated:YES];
        self.RNSmartOrder = [[SmartOrderSettingRNModel alloc]init];
    } else if ([actionCode isEqualToString:PAD_DISCOUNT_PLAN]) {  //打折方案
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DiscountPlanListView];
        //            [mainModule.appController.navigationController pushViewController:viewController animated:YES];
        [self.rootViewController  pushViewController:viewController animated:YES];
    }else if([actionCode isEqualToString:PHONE_PRIVILEGE]) {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *viewController = [mediator TDFMediator_memberlevelViewController];
        [self.rootViewController pushViewController:viewController animated:YES];
        
        return;
    }else if ([actionCode isEqualToString:PHONE_BRAND_PRIVILEGE]) {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *viewController = [mediator TDFMediator_memberChainLevelViewController];
        [self.rootViewController pushViewController:viewController animated:YES];
    }else if ([actionCode isEqualToString:PAD_KIND_CARD] || [actionCode isEqualToString:PHONE_BRAND_KIND_CARD]) {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance] TDFMediator_kindCardListViewControllerWithParams:nil] animated:YES];
    }else if ([actionCode isEqualToString:PAD_CHARGE_DISCOUNT] || [actionCode isEqualToString:PHONE_BRAND_CHARGE_DISCOUNT]) {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance] TDFMediator_tdfRechargeViewControllerWithParams:nil] animated:YES];
    }else if ([actionCode isEqualToString:PHONE_BRAND_CHANGE_SKIN]) {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance] TDFMediator_exchangeSkinPlanList] animated:YES];
    }
    
    
}

//／旧RN逻辑需要优化
- (void)RNDidMount:(NSNotification*)notification {
    
    NSDictionary * notificationDic = (NSDictionary *)[notification object];
    
    if (notificationDic) {
        NSString * helpActionKey = notificationDic[@"mountComponent"];
        
        if (helpActionKey) {
            if ([helpActionKey isEqualToString:@"Did_Mount_TemplateHome"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.rootViewController.view animated:YES];
                    
                    UINavigationController * nav = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
                    
                    if (nav.topViewController == self.RNSmartOrder || !self.rootViewController.view.window) {
                        return ;
                    }
                    [self.rootViewController pushViewController:self.RNSmartOrder animated:YES];
                });
                
                return;
            }
        }
    }
    
}
///分公司（连锁）
- (void)switchToBranch {
    TDFMediator *mediator = [[TDFMediator alloc] init];
    UIViewController *branchListContoller = [mediator TDFMediator_branchCompanyListViewControllerWithType:ModuleType delegate:nil branchCompanyList:nil branchCompanyListArr:nil isFromBranchEditView:NO listCallBack:^(BOOL orFresh) {
        
    }];
    [self.rootViewController pushViewController:branchListContoller animated:YES];
    
}

//品牌（分公司／连锁）
- (void)switchToPlate
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    //    @weakify(self);
    UIViewController *brandListContoller = [mediator TDFMediator_brandManagerListViewControllerWithBrandCallBack:^(BOOL orFresh) {
        //        @strongify(self);
        
    }];
    [self.rootViewController pushViewController:brandListContoller animated:YES];
}

//支付宝随机立减
- (void)AliPayKouBei {
    
    UINavigationController *rootController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    
    UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_TDFMemAliPayKouBeiController];
    
    [rootController pushViewController:vc animated:YES];
    
}

///电子收款明细
- (void)loadPaymentModuleWithCodeArray:(NSArray *)codeArray
{
    NSArray *menus = [TDFPaymentModule menuActions:self.shopInfo];
    if (menus.count >1) {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance] TDFMediator_paymentTypeViewControllerWithShopInfo:nil menus:menus codeArray:codeArray ] animated:YES];
    }else{
        TDFPaymentTypeVo *action = menus.lastObject;
        if (action) {
            [self.rootViewController pushViewController:[[TDFMediator sharedInstance] TDFMediator_orderPayListViewControllerWithShopInfo:nil action:action isAccount:YES withCodeArray:codeArray] animated:YES];
        }
    }
}

///开通口碑
- (void)koubei
{
    //    NSURL *url = [NSURL URLWithString:@"alipaym://"];
    //
    //    if ([[UIApplication sharedApplication] canOpenURL:url]) {
    //        [[UIApplication sharedApplication] openURL:url];
    //    }else{
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"“口碑商家”应用是支付宝口碑为各位商家提供的移动端管理工具，轻松完成支付宝收款，创建和管理线上门店，发布运营活动，帮助线下商家更好地吸引新用户、留住老用户、提升品牌影响力。您希望下载“口碑商家”应用吗？", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"安装应用", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/kou-bei-shang-jia/id796778475?mt=8"];
    //
    //            [[UIApplication sharedApplication] openURL:url];
    //        }];
    //
    //        [alertController addAction:confirmAction];
    //
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    //
    //        [alertController addAction:cancelAction];
    //
    //        UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    //
    //        [viewController presentViewController:alertController animated:YES completion:nil];
    //    }
    TDFKBAuthListController *vc = [[TDFKBAuthListController alloc]init];
    
    [self.rootViewController pushViewController:vc animated:YES];
    
}

///供应链
- (void)showSupolyManage {
    NSURL *url = [NSURL URLWithString:@"TDFSupplyChainApp://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else{
        
        BOOL showRestApp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kTDFShowRestApp"] boolValue];
        
        if (!showRestApp) return;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请安装'二维火供应链'", nil)
                                                                                 message:NSLocalizedString(@"前往App Store下载二维火供应链", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = @"http://itunes.apple.com/us/app/id1124011735";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
        
        [alertController addAction:confirmAction];
        
        UIViewController *rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    return;
}


@end
