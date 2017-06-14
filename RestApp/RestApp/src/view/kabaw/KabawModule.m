//
//  KabawModule.m
//  RestApp
//
//  Created by zxh on 14-5-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMustSelectGoodsViewController.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "MenuService.h"
#import "SystemUtil.h"
#import "MainModule.h"
#import "ShopEditView.h"
#import "NavigateTitle2.h"
#import "UIMenuAction.h"
#import "ActionConstants.h"
#import "XHAnimalUtil.h"
#import "SecondMenuView.h"
#import "SingleCheckView.h"
#import "MultiCheckView.h"
#import "BellEditView.h"
#import "GiftListView.h"
#import "GiftEditView.h"
#import "ShopCodeView.h"
#import "KindCardListView.h"
#import "CardCoverListView.h"
#import "SpecialTagEditView.h"
#import "QueuKindListView.h"
#import "SpecialTagListView.h"
#import "ShopSalesRankView.h"
#import "TakeOutSetEditView.h"
#import "MoneyRuleEditView.h"
#import "BaseSetingView.h"
#import "MapLocationView.h"
#import "TDFMediator+KabawModule.h"
#import "WXOfficialAccountController.h"
#import "AppDelegate.h"
#import "BackgroundHelper.h"
#import "TDFChainService.h"
@interface KabawModule ()

@property (strong, nonatomic) UIImageView *backgroundImageView;

@end

@implementation KabawModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)mainModuleP
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = mainModuleP;
        settingservice = [ServiceFactory Instance].settingService;
        menuService = [ServiceFactory Instance].menuService;
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
    
    [self initMenuView];
}

- (UIImageView *)backgroundImageView {
    
    if (!_backgroundImageView) {
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundImageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
        _backgroundImageView.alpha = 1.0;
        _backgroundImageView.opaque = YES;
    }
    return _backgroundImageView;
}

#pragma mark Menu 菜单部分.
- (void)initMenuView
{
    self.secondMenuView = [[SecondMenuView alloc] initWithNibName:@"SecondMenuView" bundle:nil delegate:self];
    self.secondMenuView.titleBox.lblTitle.text = NSLocalizedString(@"顾客端设置", nil);
    [self.view addSubview:self.secondMenuView.view];
    [self.secondMenuView.view insertSubview:self.backgroundImageView atIndex:0];
}

#pragma ui change
- (void)hideView
{
    for (UIView* view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

- (void)showView:(int) viewTag
{
    [self hideView];
    if (viewTag==SECOND_MENU_VIEW) {
        self.secondMenuView.view.hidden=NO;

    } else if (viewTag==MULTI_CHECK_VIEW) {
        [self loadMultiCheckView];
    } else if (viewTag==BELL_EDIT_VIEW) {
        [self loadBellEditView];
    } else if (viewTag==GIFT_LIST_VIEW) {
        [self loadGiftListView];
    } else if (viewTag==GIFT_EDIT_VIEW) {
        [self loadGiftEditView];
    } else if (viewTag==KINDCARD_LIST_VIEW) {
        [self loadKindCardListView];
    } else if (viewTag==KINDCARD_EDIT_VIEW) {
        [self loadKindCardEditView];
    } else if (viewTag==CARDCOVER_LIST_VIEW) {
        [self loadCardCoverListView];
        [self.cardCoverListView.mainGrid setContentOffset:CGPointMake(0,0)];
        return;
    } else if (viewTag==TAKEOUT_EDIT_VIEW) {
        [self loadTakeOutSetEditView];
    } else if (viewTag==SHOP_EDIT_VIEW) {
        [self loadShopEditView];
        self.shopEditView.backIndex = INDEX_PARENT_VIEW;
    } else if (viewTag==SHOP_CODE_VIEW) {

    } else if (viewTag==SHOP_BLACK_LIST_VIEW) {
//        [self loadShopBlackListView];
    } else if (viewTag==QUEU_KIND_LIST_VIEW) {
//        [self loadQueuKindListView];
    } else if (viewTag==SPECIAL_TAG_LIST_VIEW) {
        [self loadSpecialTagListView];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromTop];
        return;
    } else if (viewTag==SPECIAL_TAG_EDIT_VIEW) {
        [self loadSpecialTagEditView];
    } else if (viewTag == BASE_SETTING_VIEW) {
        [self loadBaseSetingView];
        return;
    }else if (viewTag == SHOP_SALES_RANK_VIEW){
        
    }
   [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromLeft];
}

- (void)showShopEditViewWithBackIndex:(NSInteger)backIndex {

    [self showView:SHOP_EDIT_VIEW];
//    self.shopEditView.backIndex = backIndex;
//    [self.shopEditView loadDatas];
//    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
}

- (void)showMenu
{
    [self showView:SECOND_MENU_VIEW];
    
    ///逻辑暂时这样处理，急着上线，没时间思考
    
    BOOL ishave = NO;
    for (UIMenuAction *action in self.secondMenuView.menuItems) {
        if ([action.code isEqualToString:PAD_TAKEOUT_SETTING]) {
            ishave = YES;
            break;
        }
    }
    if (self.isShow) {
        if (ishave) {
            return;
        }else{
            UIMenuAction *action=[[UIMenuAction alloc] init:NSLocalizedString(@"外卖设置", nil) detail:NSLocalizedString(@"开通外卖时需要的设置信息", nil) img:@"ico_nav_waimaishezhi" code:PAD_TAKEOUT_SETTING];
            [self.secondMenuView.menuItems insertObject:action atIndex:7];
        }
    }else
    {
        if (ishave) {
            for (UIMenuAction *action in self.secondMenuView.menuItems) {
                if ([action.code isEqualToString:PAD_TAKEOUT_SETTING]) {
                    [self.secondMenuView.menuItems removeObject:action];
                    break;
                }
            }
        }else
        {
            return;
        }
    }
    [self.secondMenuView.tableSeMenus reloadData];
}

- (void)onMenuSelectHandle:(UIMenuAction *)action
{
    [self showActionCode:action.code];
}

- (void)showActionCode:(NSString *)actCode
{
    if ([actCode isEqualToString:PAD_BASE_SETTING]) {
         [self loadBaseSetingView];
          return;
    } else if ([actCode isEqualToString:PAD_CARD_SHOPINFO]) {
        [self loadShopEditView];
        return;
    } else if ([actCode isEqualToString:PAD_SHOP_QRCODE]) {
        [self loadShopCodeView];
        return;
    } else if ([actCode isEqualToString:PAD_RESERVE_SETTING]/*预定设置*/)
    {
        [self loadReserveSetEditView];
        return;
    } else if ([actCode isEqualToString:PAD_TAKEOUT_SETTING])
    {
        [self loadTakeOutSetEditView];
        return;
    } else if ([actCode isEqualToString:PAD_KIND_CARD]) {
        [self showView:KINDCARD_LIST_VIEW];
        [self.kindCardListView loadDatas];
    } else if ([actCode isEqualToString:PAD_CHARGE_DISCOUNT]) {
//        [self showView:MONEYRULE_MENU_VIEW];
//        [self.moneyRuleMenuView loadDatas];
    } else if ([actCode isEqualToString:PAD_DEGREE_EXCHANGE]) {
        [self showView:GIFT_LIST_VIEW];
        [self.giftListView loadDatas];
    } else if ([actCode isEqualToString:PAD_CARD_SERVICE]) {
        [self showView:BELL_EDIT_VIEW];
        [self.bellEditView loadData];
    } else if ([actCode isEqualToString:PAD_QUEUE_SEAT]) {
        [self loadQueuKindListView];
        return;
    } else if ([actCode isEqualToString:PHONE_SELECT_MENU/*必选商品*/]){
        [self loadMustSelectView];
        return;
    } else if ([actCode isEqualToString:PAD_BLACK_LIST]) {
        [self loadShopBlackListView];
        return;
    } else if ([actCode isEqualToString:PHONE_SALES_RANKING]){
        [self loadShopSalesRankView];
        return;
    } else if ([actCode isEqualToString:PHONE_WEIXIN_CODE]) {
        WXOfficialAccountController *vc = [[WXOfficialAccountController alloc] init];
        [self.rootController pushViewController:vc animated:YES];
    } else if ([actCode isEqualToString:PHONE_SHOP_LOGO]){
        [self.rootController pushViewController:[[TDFMediator sharedInstance] TDFMediator_shopLogoViewController] animated:YES];

    }
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
}


- (void)backMenu
{
    if (self.navigationController) {
        [self.view removeFromSuperview];
    }
    [mainModule backMenuBySelf:self];
}

-(void)backNavigateMenuView
{
    [mainModule backMenuBySelf:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}
- (void)backToMain
{
    [mainModule backMenuBySelf:self];
}

//创建二级菜单
- (NSMutableArray *)createList
{
    
    NSMutableArray* menuItems=[NSMutableArray array];
    UIMenuAction *action=[[UIMenuAction alloc] init:NSLocalizedString(@"店家资料", nil) detail:NSLocalizedString(@"设置顾客端中的店铺信息展示", nil) img:@"ico_nav_dianjiaxinxi" code:PAD_CARD_SHOPINFO];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"基础设置", nil) detail:NSLocalizedString(@"顾客端点餐的基础设置", nil) img:@"ico_nav_xitongcanshu" code:PAD_BASE_SETTING];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"店铺二维码", nil) detail:NSLocalizedString(@"店铺二维码下载及顾客端主页分享", nil) img:@"shop_qrcode_logo" code:PAD_SHOP_QRCODE];
    [menuItems addObject:action];
    
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"店铺LOGO", nil) detail:NSLocalizedString(@"展示在“火小二”应用及微信扫码菜单中作为店标", nil) img:@"ico_shop_logo" code:PHONE_SHOP_LOGO];
    [menuItems addObject:action];
    
//    action = [[UIMenuAction alloc] init:NSLocalizedString(@"店家微信公众号设置", nil) detail:NSLocalizedString(@"上传店家公众号二维码的帮助说明", nil) img:@"wx_official_logo" code:PHONE_WEIXIN_CODE];
//    [menuItems addObject:action];
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"本店销量榜", nil) detail:NSLocalizedString(@"菜品销售情况的排行榜", nil) img:@"ico_sales_rank" code:PHONE_SALES_RANKING];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"预订设置", nil) detail:NSLocalizedString(@"开通预订时需要的设置信息", nil) img:@"ico_nav_yudingshezhi" code:PAD_RESERVE_SETTING];
    [menuItems addObject:action];
    
    if (self.isShow) {
        action=[[UIMenuAction alloc] init:NSLocalizedString(@"外卖设置", nil) detail:NSLocalizedString(@"开通外卖时需要的设置信息", nil) img:@"ico_nav_waimaishezhi" code:PAD_TAKEOUT_SETTING];
        [menuItems addObject:action];
    }

    //action=[[UIMenuAction alloc] init:NSLocalizedString(@"排队桌位类型", nil) detail:NSLocalizedString(@"排队桌位类型", nil) img:@"ico_nav_zhuoweileixing" code:PAD_QUEUE_SEAT];
    //[menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"必选商品", nil) detail:NSLocalizedString(@"锅底、餐具等商品自动加入购物车", nil) img:@"ico_nav_force_goods" code:PHONE_SELECT_MENU];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"黑名单", nil) detail:NSLocalizedString(@"添加顾客黑名单，杜绝恶意骚扰", nil) img:@"blackList.png" code:PAD_BLACK_LIST];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"个性化换肤", nil) detail:NSLocalizedString(@"您可以在这里定义您店铺独有的二维火小二皮肤", nil) img:@"icon_skin" code:PHONE_CHANGE_SKIN];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"商品页首与页尾", nil) detail:NSLocalizedString(@"顾客端菜肴详情页面可以添加页首页尾图片，用于宣传品牌历史、团队形象、材料原产地、活…", nil) img:@"商品页首页尾图片_icon" code:PHONE_MENU_PICTURE_PAGE];
    [menuItems addObject:action];
    
    return menuItems;
}

//店家资料
- (void)loadShopEditView
{
    UIViewController *shopEditView = [[TDFMediator sharedInstance]TDFMediator_shopEditViewController];
    [self.rootController pushViewController:shopEditView animated:YES];
}

- (void)loadBaseSetingView
{
    UIViewController *baseSetingView = [[TDFMediator sharedInstance] TDFMediator_baseSetingViewController];
    [self.rootController pushViewController:baseSetingView animated:YES];
}

- (void)loadMultiCheckView
{
    if (self.multiCheckView) {
        self.multiCheckView.view.hidden=NO;
    } else {
        self.multiCheckView=[[MultiCheckView alloc] init];
        [self.view addSubview:self.multiCheckView.view];
    }
}

- (void)loadBellEditView
{
    if (self.bellEditView) {
        self.bellEditView.view.hidden=NO;
    } else {
        self.bellEditView=[[BellEditView alloc] initWithNibName:@"BellEditView"bundle:nil parent:self];
        [self.view addSubview:self.bellEditView.view];
    }
}

- (void)loadGiftListView
{
    if (self.giftListView) {
        self.giftListView.view.hidden=NO;
    } else {
        self.giftListView=[[GiftListView alloc] init];
        [self.view addSubview:self.giftListView.view];
    }
}

- (void)loadGiftEditView
{
    if (self.giftEditView) {
        self.giftEditView.view.hidden=NO;
    } else {
        self.giftEditView=[[GiftEditView alloc] initWithNibName:@"GiftEditView"bundle:nil];
        [self.view addSubview:self.giftEditView.view];
    }
}

- (void)loadKindCardListView
{
    if (self.kindCardListView) {
        self.kindCardListView.view.hidden=NO;
    } else {
        self.kindCardListView=[[KindCardListView alloc] init];
        [self.view addSubview:self.kindCardListView.view];
    }
}

- (void)loadCardCoverListView
{
    if ( self.cardCoverListView) {
        self.cardCoverListView.view.hidden=NO;
    } else {
        self.cardCoverListView=[[CardCoverListView alloc] initWithNibName:@"CardCoverListView"bundle:nil];
        [self.view addSubview:self.cardCoverListView.view];
    }
}

- (void)loadKindCardEditView
{
//    if (self.kindCardEditView) {
//        self.kindCardEditView.view.hidden=NO;
//    } else {
//        self.kindCardEditView=[[KindCardEditView alloc] initWithNibName:@"KindCardEditView"bundle:nil];
//        [self.view addSubview:self.kindCardEditView.view];
//    }
}
//预定设置
- (void)loadReserveSetEditView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveSetEditViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

//本店销量榜
- (void)loadShopSalesRankView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopSalesRankViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

//外卖设置
- (void)loadTakeOutSetEditView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_takeOutSetEditViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadShopCodeView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopCodeViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadShopBlackListView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopBlackListViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadheaderfooterView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_headerFooterViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadExchangeSkinView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_exchangeSkinViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadSpecialTagListView
{
    if (self.specialTagListView) {
        self.specialTagListView.view.hidden=NO;
    } else {
        self.specialTagListView = [[SpecialTagListView alloc] initWithNibName:@"SpecialTagListView" bundle:nil parent:self moduleName:@"kabaw"];
        [self.view addSubview:self.specialTagListView.view];
    }
}

- (void)loadSpecialTagEditView
{
    if ( self.specialTagEditView) {
        self.specialTagEditView.view.hidden=NO;
    } else {
        self.specialTagEditView = [[SpecialTagEditView alloc] initWithNibName:@"SpecialTagEditView" bundle:nil parent:self  moduleName:@"kabaw"];
        [self.view addSubview:self.specialTagEditView.view];
    }
}

- (void)loadQueuKindListView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_QueuKindListViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadMustSelectView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_mustSelectGoodsViewController];
    [self.rootController pushViewController:viewController animated:YES];
}
@end
