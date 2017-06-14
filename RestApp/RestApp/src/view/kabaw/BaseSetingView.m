//
//  BaseSetingView.m
//  RestApp
//
//  Created by 果汁 on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "ConfigVO.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "RemoteEvent.h"
#import "KabawModule.h"
#import "XHAnimalUtil.h"
#import "GlobalRender.h"
#import "ConfigRender.h"
#import "RemoteResult.h"
#import "NavigateTitle.h"
#import "MBProgressHUD.h"
#import "EditItemRadio.h"
#import "NavigateTitle2.h"
#import "SettingService.h"
#import "FooterListView.h"
#import "ServiceFactory.h"
#import "UIViewController+Picker.h"
#import "ConfigConstants.h"
#import "NSString+Estimate.h"
#import "KindConfigConstants.h"
#import "BaseSetingView.h"
#import "TDFmemberCoupon.h"
#import "ActionConstants.h"
#import "TDFResponseModel.h"
#import "TDFSettingService.h"
#import <libextobjc/EXTScope.h>
#import "TDFMemCouEditData.h"
#import "UIView+Sizes.h"
#import "TDFShopConfVoList.h"
#import "YYModel.h"
#import "TDFMediator+MemberModule.h"
#import "TDFBaseSettingService.h"
#import "TDFRootViewController+AlertMessage.h"
#import "YYModel.h"
#define SHOP_MENUTYPE_SETTING 1
#define RS_PRE_PAY 2
#define RS_ORDER_TXT 3
#define RS_COUPON 4
#define LIST_COUPON 5

#define  RS_S_COUPON 6
#define LIST_S_COUPON 7
#define MENU_QR_CD @"MENU_QR_CD"

@interface BaseSetingView ()
@property (strong, nonatomic) EditItemRadio *invoiceRadio;
@property (nonatomic, strong) EditItemRadio *elecInvoiceRadio;

@property (nonatomic, strong) EditItemRadio *orderNumRadio;
@property (nonatomic, strong) EditItemRadio *discountPopRadio;
@property (nonatomic, strong) EditItemRadio *discountRechargePopRadio;
@property (nonatomic, strong) EditItemRadio *clearRadio;
@property (nonatomic, strong) EditItemRadio *customCommentRadio;
@property (nonatomic, strong) EditItemRadio  *customerOrderAccountVerificationPopup;
/**
 皮肤间距开关
 */
@property (nonatomic, strong) EditItemRadio *skinSpaceRadio;

@property (nonatomic, strong) NSMutableArray *shopConfigListArray;
@end

@implementation BaseSetingView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    service=[ServiceFactory Instance].settingService;
    self.shopConfigListArray = [NSMutableArray array];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    [self.view addSubview:self.titleDiv];
    [self addview];
    [self.lsCoupon visibal:NO];
    [self.lsSendCoupon visibal:NO];
    self.scrollView.hidden = YES;
    [self initNavigate];
    [self initNotifaction];
    [self addview];
}

-(void) addview
{
    [self clearDo];
    [self.view addSubview:self.scrollView];
    [self initMainView];
    [self loadData];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}

- (UIView *) container
{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _container.backgroundColor = [UIColor clearColor];
        
        [_container addSubview:self.lsTypesetting];
        [_container addSubview:self.rdoShowPrice];
        [_container addSubview:self.rdoOrderTxt];
        [_container addSubview:self.rdoWaitMenu];
        [_container addSubview:self.rdoServerStyle];
        [_container addSubview:self.rdoPackMenu];
        [_container addSubview:self.rdoPerPay];
        [_container addSubview:self.rdoShopPay];
        [_container addSubview:self.rdoPrintMenu];
        [_container addSubview:self.rdoMenuCode];
        [_container addSubview:self.invoiceRadio];
        [_container addSubview:self.elecInvoiceRadio];
        [_container addSubview:self.rdoCoupon];
        [_container addSubview:self.lsCoupon];
        [_container addSubview:self.rdoSendCoupon];
        [_container addSubview:self.lsSendCoupon];
        [_container addSubview:self.skinSpaceRadio];
        [_container insertSubview:self.orderNumRadio aboveSubview:self.rdoShowPrice];
        [_container insertSubview:self.clearRadio aboveSubview:self.orderNumRadio];
        [_container insertSubview:self.goodsTop aboveSubview:self.clearRadio];
        [_container insertSubview:self.customCommentRadio aboveSubview:self.goodsTop];
        [_container insertSubview:self.discountRechargePopRadio aboveSubview:self.customCommentRadio];
        [_container insertSubview:self.discountPopRadio aboveSubview:self.discountRechargePopRadio];
        [_container insertSubview:self.customerOrderAccountVerificationPopup aboveSubview:self.discountPopRadio];
        [_container addSubview:self.rdoPositionJudgeSwitch];
    }
    return _container;
}

- (EditItemList *) lsTypesetting
{
    if (!_lsTypesetting) {
        _lsTypesetting = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    }
    return _lsTypesetting;
}

- (EditItemRadio *) rdoShowPrice
{
    if (!_rdoShowPrice) {
        _rdoShowPrice = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 85)];
    }
    return _rdoShowPrice;
}

- (EditItemRadio *) rdoOrderTxt
{
    if (!_rdoOrderTxt) {
        _rdoOrderTxt = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, 85)];
    }
    return _rdoOrderTxt;
}

- (EditItemRadio *) rdoWaitMenu
{
    if (!_rdoWaitMenu) {
        _rdoWaitMenu = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 85)];
    }
    return _rdoWaitMenu;
}

- (EditItemRadio *) rdoServerStyle
{
    if (!_rdoServerStyle) {
        _rdoServerStyle = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 305, SCREEN_WIDTH, 85)];
    }
    return _rdoServerStyle;
}

- (EditItemRadio *) rdoPackMenu
{
    if (!_rdoPackMenu) {
        _rdoPackMenu = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 390, SCREEN_WIDTH, 85)];
    }
    return _rdoPackMenu;
}

- (EditItemRadio *) rdoPerPay
{
    if (!_rdoPerPay) {
        _rdoPerPay = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 475, SCREEN_WIDTH, 85)];
    }
    return _rdoPerPay;
}

- (EditItemRadio *) rdoShopPay
{
    if (!_rdoShopPay) {
        _rdoShopPay = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 560, SCREEN_WIDTH, 85)];
    }
    return _rdoShopPay;
}

- (EditItemRadio *) rdoPrintMenu
{
    if (!_rdoPrintMenu) {
        _rdoPrintMenu = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 645, SCREEN_WIDTH, 85)];
    }
    return _rdoPrintMenu;
}

- (EditItemRadio *) rdoMenuCode
{
    if (!_rdoMenuCode) {
        _rdoMenuCode = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 730, SCREEN_WIDTH, 85)];
    }
    return _rdoMenuCode;
}

- (EditItemRadio *)rdoPositionJudgeSwitch
{
    if (!_rdoPositionJudgeSwitch) {
        _rdoPositionJudgeSwitch = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 730+85, SCREEN_WIDTH, 85)];
    }
    return _rdoPositionJudgeSwitch;
}

- (EditItemRadio *)customerOrderAccountVerificationPopup
{
    if (!_customerOrderAccountVerificationPopup) {
        _customerOrderAccountVerificationPopup  = [[EditItemRadio  alloc] initWithFrame:CGRectMake(0, 730, SCREEN_WIDTH, 85)];
    }
    return _customerOrderAccountVerificationPopup;
}

- (UIView *) titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleDiv.backgroundColor = [UIColor redColor];
    }
    return _titleDiv;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BOOL islsCouponOpen = [self.rdoCoupon getVal];
    BOOL islsSendCouponOpen = [self.rdoSendCoupon getVal];
    [self.lsCoupon visibal:islsCouponOpen];
    [self.lsSendCoupon visibal:islsSendCouponOpen];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma navigateBar
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"基础设置", nil);
}

- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    [self save];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

#pragma ui.
-(void) initMainView
{
    [self.lsTypesetting initLabel:NSLocalizedString(@"微店菜单默认排版方式", nil) withHit:NSLocalizedString(@"注:在此处设置顾客端店页打开时菜单的默认排版方式，顾客也可以自己更改其他方式。", nil) isrequest:YES delegate:self];
    [self.lsTypesetting initData:NSLocalizedString(@"图文菜单", nil) withVal:@"0"];
    
    [self.rdoShowPrice initLabel:NSLocalizedString(@"顾客点餐时显示已点菜的合计价格", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客手机进行点餐时，购物车页面显示已点菜的合计价格。反之则不显示。", nil) delegate:nil];
    
    [self.orderNumRadio initLabel:NSLocalizedString(@"顾客点餐时需要选择用餐人数", nil) withHit:NSLocalizedString(@"注:关闭此项后，顾客扫桌码点餐时，用餐人数默认为1人，用户无需手动选择，但人数仍可编辑。", nil) delegate:nil];
    
    [self.clearRadio initLabel:NSLocalizedString(@"菜单中显示沽清的商品", nil) withHit:nil delegate:nil];
    
    [self.goodsTop initLabel:@"商品置顶后在商品原分类可见" withHit:@"注：开启此项后，“店家推荐” 分组中的商品，同时显示在该商品原来的分类中。" delegate:nil];
    
    [self.customCommentRadio initLabel:NSLocalizedString(@"店首页显示顾客评价", nil) withHit:NSLocalizedString(@"注:若希望屏蔽部分评价，可在“顾客评价-综合评价”中操作。", nil) delegate:nil];

    [self.discountRechargePopRadio initLabel:NSLocalizedString(@"顾客点餐展示充值优惠弹窗", nil) withHit:NSLocalizedString(@"注:此弹窗显示在顾客扫桌码进入菜单页时，具体的充值优惠内容可在“会员优惠”中设置。", nil) delegate:nil];
    
    [self.discountPopRadio initLabel:NSLocalizedString(@"顾客点餐展示优惠券弹窗", nil) withHit:NSLocalizedString(@"注:此弹窗显示在顾客扫桌码进入菜单页时，具体的优惠券内容可在“会员优惠”中设置。", nil) delegate:nil];
    
    [self.rdoOrderTxt initLabel:NSLocalizedString(@"顾客点餐时可以添加整单备注", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客用手机点餐下单时可以添加整单备注。关闭此项，则不可以添加整单备注。", nil) delegate:self];
    [self.rdoWaitMenu initLabel:NSLocalizedString(@"▪︎ 顾客可以选择“暂不上菜”", nil) withHit:nil delegate:nil];
    [self.rdoServerStyle initLabel:NSLocalizedString(@"▪︎ 顾客可以选择“冷上热待”", nil) withHit:nil delegate:nil];
    [self.rdoPackMenu initLabel:NSLocalizedString(@"▪︎ 顾客可以选择“打包带走”", nil) withHit:nil delegate:self];
    [self.rdoPerPay initLabel:NSLocalizedString(@"顾客扫桌码下单时需要先付款", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客扫桌码点菜时，需要先付款才能继续下单。有付款的订单将自动审核通过，直接入厨。顾客付款时的账单金额为所有菜价的合计，可能与收银上的价格有出入。所以，收银员在收银机上进行“结账完毕”操作的时候，需要认真核对价格，多退少补。", nil) delegate:nil];
    [self.rdoShopPay initLabel:NSLocalizedString(@"顾客扫店码下单时需要先付款", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客扫店码点菜时，需要先付款才能继续下单。有付款的订单将自动审核通过，直接入厨。顾客付款时的账单金额为所有菜价的合计，可能与收银上的价格有出入。所以，收银员在收银机上进行“结账完毕”操作的时候，需要认真核对价格，多退少补。", nil) delegate:nil];
    [self.rdoPrintMenu initLabel:NSLocalizedString(@"顾客手机下单后，厨房打印机上每份商品打印一张配菜联", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客手机下单时，如果一种商品一共点了3份，那么厨房会打印3张配菜联，每张配菜联上是1份商品；若关闭此项，则厨房打印一张配菜联，配菜联上是3份商品。", nil) delegate:nil];
    
    [self.rdoMenuCode initLabel:NSLocalizedString(@"顾客端显示扫菜码点菜按钮", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客点菜时菜单页会出现“扫菜码”按钮，扫菜肴二维码后可直接点菜。菜肴二维码可以在商品模块下载。此方式多适用于明档点菜。", nil) delegate:nil];

    [self.invoiceRadio initLabel:NSLocalizedString(@"顾客付款后可以申请开纸质发票", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客在手机上付款完成后，可以申请开发票，输入发票抬头。使用指定的发票打印机时，在收银   结账完毕后会自动打印发票，反之则不显示。", nil) delegate:nil];
    [self.elecInvoiceRadio initLabel:NSLocalizedString(@"顾客付款后可以申请开电子发票", nil) withHit:NSLocalizedString(@"注:开启此项后，顾客在手机上付款完成后，可以申请开电子发票，输入发票抬头。电子发票会通过短信方式发送给顾客。", nil) delegate:nil];
    
    [self.rdoCoupon initLabel:NSLocalizedString(@"有顾客赠送本店吃饭直播活动道具时发券", nil) withHit:NSLocalizedString(@"注:开启此项后，当有用户给本店用餐的顾客送二维火道具时，可以获得一张优惠券；", nil) delegate:self];
    [self.skinSpaceRadio initLabel:NSLocalizedString(@"菜肴详情商品展示图片排版留空", nil) withHit:NSLocalizedString(@"注：开启此项后，顾客手机进行点餐时，菜肴详情页面中菜肴图片之间将存在间距", nil) delegate:nil];
    [self.lsCoupon initLabel:NSLocalizedString(@"▪︎ 选择赠送的优惠券", nil) withHit:nil delegate:self];
    [self.lsCoupon initData:@"" withVal:@""];
    self.lsCoupon.lblVal.text = @"";
    [self.lsCoupon.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.rdoSendCoupon initLabel:NSLocalizedString(@"有顾客分享本店吃饭直播活动时发券", nil) withHit:NSLocalizedString(@"注:开启此项后，当顾客发起和分享他在本店就餐的吃饭直播活动时，可以获得一张优惠券；", nil) delegate:self];
    [self.lsSendCoupon initLabel:NSLocalizedString(@"▪︎ 选择赠送的优惠券", nil) withHit:nil delegate:self];
    [self.lsSendCoupon initData:@"" withVal:@""];
    self.lsSendCoupon.lblVal.text = @"";
    [self.lsSendCoupon.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];

    [self.rdoPositionJudgeSwitch initLabel:NSLocalizedString(@"顾客扫桌码下单时需要判定地理位置信息", nil) withHit:NSLocalizedString(@"注:此功能开启后，系统会根据顾客位置信息判定顾客能否正常下单(距离店家2km内能正常下单)，防止部分顾客远程恶意下单，减少商家损失。未授权位置信息的顾客将无法正常扫码点餐，授权后方可正常使用", nil) delegate:nil];
    //新增
    [self.customerOrderAccountVerificationPopup  initLabel:NSLocalizedString(@"顾客下单时账号验证弹窗", nil)  withHit:@"注:打开此项后，顾客在购物车下单是会弹出账号验证弹窗。"];
    [self.customerOrderAccountVerificationPopup initData:@"0"];
    
    [self.footView initDelegate:self btnArrs:nil];
    self.rdoPerPay.tag = RS_PRE_PAY;
    self.rdoOrderTxt.tag = RS_ORDER_TXT;
    self.lsTypesetting.tag = SHOP_MENUTYPE_SETTING;
    self.rdoCoupon.tag = RS_COUPON;
    self.lsCoupon.tag = LIST_COUPON;
    
    self.rdoSendCoupon.tag =RS_S_COUPON;
    self.lsSendCoupon.tag = LIST_S_COUPON;
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}



#pragma remote
-(void) loadData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [service listSystemConfig:@"USE_MENU_QR_CODE" callback:^(TDFResponseModel *responseModel) {
        @strongify(self);
        if (responseModel.error) {
            [AlertBox show:responseModel.error.localizedDescription];
            return ;
        }
        NSDictionary *dict = responseModel.responseObject;
        if (![[dict objectForKey:@"code"] integerValue]) {
            [AlertBox show:[dict objectForKey:@"message"]];
            return;
        }
        NSMutableDictionary *dic = dict[@"data"];
        [self.rdoMenuCode initData:[NSString stringWithFormat:@"%@",dic[@"USE_MENU_QR_CODE"]]];

    }];
    
    /**获取所有基础设置信息*/
    [TDFBaseSettingService fetchBaseSettingListWithKindConfigCode:@"SYS_CONFIG" completeBlock:^(TDFResponseModel * response) {
        @strongify(self);
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                self.scrollView.hidden = NO;
                NSDictionary *dict = response.responseObject;
                NSArray *configVOList = [NSArray yy_modelArrayWithClass:[ConfigVO class] json:dict[@"data"]];
                [self fillModel:[NSMutableArray arrayWithArray:configVOList]];
            }
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }

    }];

    /**map*/
    [service getPacketShopConfigWithCallBack:^(TDFResponseModel *responseModel) {
        NSDictionary *map = responseModel.responseObject;
        NSArray *data = [map objectForKey:@"data"];
        for (NSDictionary *dic in data) {
                TDFShopConfVoList *vo  = [TDFShopConfVoList yy_modelWithDictionary:dic];
            if (vo) {
                [self.shopConfigListArray addObject:vo];
            }else{
                return;
            }

            if (vo.type == 1 && vo.autoSend == 1) {
                [self.rdoCoupon initShortData:vo.autoSend];
                [self.lsCoupon visibal:vo.autoSend];
                self.lsCoupon.lblName.text = NSLocalizedString(@"▪︎ 已选择", nil);
                [self.lsCoupon initData:vo.couponName withVal:[NSString stringWithFormat:@"%@",vo.couponId]];
                if ([NSString isBlank:vo.couponName]) {
                    self.lsCoupon.lblVal.text = @"";
                }
            }
            if (vo.type == 2&& vo.autoSend == 1) {
                [self.rdoSendCoupon initShortData:vo.autoSend];
                [self.lsSendCoupon visibal:vo.autoSend];
                self.lsSendCoupon.lblName.text = NSLocalizedString(@"▪︎ 已选择", nil);
                [self.lsSendCoupon initData:vo.couponName withVal:[NSString stringWithFormat:@"%@",vo.couponId]];
                if ([NSString isBlank:vo.couponName]) {
                    self.lsSendCoupon.lblVal.text = @"";
                }
            }

        }
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }];
}

#pragma ui-data-bind
-(void)fillModel:(NSMutableArray *)configVOList
{
    NSMutableDictionary* map=[ConfigRender transDic:configVOList];
    self.isShowPrice=[ConfigRender fillConfig:IS_DISPLAY_COUNT withControler:self.rdoShowPrice withMap:map];
    self.isTopGoods = [ConfigRender fillConfig:SHOW_TOP_MENU withControler:self.goodsTop withMap:map];
    self.isShowOrderNum=[ConfigRender fillConfig:@"NEED_PEOPLE_COUNT" withControler:self.orderNumRadio withMap:map];
    
    self.isShowClearFood=[ConfigRender fillConfig:@"SHOW_SOLDOUT_MENU" withControler:self.clearRadio withMap:map];
    self.isShowCustomerComment=[ConfigRender fillConfig:@"SHOW_CUSTOMER_COMMENTS" withControler:self.customCommentRadio withMap:map];
    self.isShowDiscountRechargePop=[ConfigRender fillConfig:@"SHOW_RECHANGE" withControler:self.discountRechargePopRadio withMap:map];
    self.isShowDiscountPop=[ConfigRender fillConfig:@"SHOW_COUPON" withControler:self.discountPopRadio withMap:map];
    self.isShowCustomerOrderPop  = [ConfigRender fillConfig:IS_ACCOUNT_VERIFY withControler:self.customerOrderAccountVerificationPopup withMap:map];


    
    self.isShowOrderMark=[ConfigRender fillConfig:IS_DISPLAY_NOTE withControler:self.rdoOrderTxt withMap:map];
    
    self.isPerpay=[ConfigRender fillConfig:IS_PRE_PAY withControler:self.rdoPerPay withMap:map];
    
    self.isPerShopPay = [ConfigRender fillConfig:IS_PRE_PAY_SHOP withControler:self.rdoShopPay withMap:map];
    self.invoiceConfig = [ConfigRender fillConfig:IS_CUSTOMER_INVOICE withControler:self.invoiceRadio withMap:map];
    self.isSkinSpace = [ConfigRender fillConfig:IS_MENU_SHOW_BLANK withControler:self.skinSpaceRadio withMap:map];
    
    [self subVisibal];
    if ([self.rdoOrderTxt getVal]) {
        self.isWait = [ConfigRender fillConfig:IS_WAIT_MENU withControler:self.rdoWaitMenu withMap:map];
        self.isPack = [ConfigRender fillConfig:IS_PACK_MENU withControler:self.rdoPackMenu withMap:map];
        self.isServing = [ConfigRender fillConfig:IS_PART_WAIT withControler:self.rdoServerStyle withMap:map];
        //        self.isPack = [ConfigRender fillConfig:IS_PACK_MENU withControler:self.rdoPackMenu withMap:map];
        
    }
    self.isMenuType = [map objectForKey:MENU_STYLE];
    [self.lsTypesetting initData:[[GlobalRender getItem:[GlobalRender listMenuTypes] withId:self.isMenuType.val] obtainItemName] withVal:self.isMenuType.val];
    self.isPrint = [ConfigRender fillConfig:IS_EACH_MENU_PRINT withControler:self.rdoPrintMenu withMap:map];
    self.elecInvoiceConfig = [ConfigRender fillConfig:IS_CUSTOMER_E_INVOICE withControler:self.elecInvoiceRadio withMap:map];
//@"IS_OPEN_GPS_JUDGE"
    self.isOpenPositionJudge = [ConfigRender fillConfig:@"IS_CONTROL_POSITION" withControler:self.rdoPositionJudgeSwitch withMap:map];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void)clearDo{
    [self.rdoCoupon initData:@"0"];
    [self.orderNumRadio initData:@"0"];
    [self.clearRadio initData:@"0"];
    [self.goodsTop initData:@"0"];
    [self.customCommentRadio initData:@"0"];
    [self.discountRechargePopRadio initData:@"0"];
    [self.discountPopRadio initData:@"0"];
    [self.rdoShowPrice initData:@"0"];
    [self.rdoSendCoupon initData:@"0"];
    [self.rdoOrderTxt initData:@"0"];
    [self.rdoPerPay initData:@"0"];
    [self.rdoPrintMenu initData:@"0"];
    [self.rdoWaitMenu initData:@"0"];
    [self.rdoServerStyle initData:@"0"];
    [self.rdoPackMenu initData:@"0"];
    [self.rdoShopPay initData:@"0"];
    [self.rdoMenuCode initData:@"0"];
    [self.rdoCoupon initData:@"0"];
    [self.invoiceRadio initData:@"0"];
    [self.elecInvoiceRadio initData:@"0"];
    [self.skinSpaceRadio initData:@"0"];
    [self.customerOrderAccountVerificationPopup  initData:@"0"];
    [self.lsCoupon visibal:NO];
    [self.lsCoupon initData:nil withVal:nil];
    self.lsCoupon.lblName.text = NSLocalizedString(@"▪︎ 选择赠送的优惠券", nil);
    self.lsCoupon.lblVal.text = @"";
    
    [self.lsSendCoupon visibal:NO];
    [self.lsSendCoupon initData:nil withVal:nil];
    self.lsSendCoupon.lblName.text = NSLocalizedString(@"▪︎ 选择赠送的优惠券", nil);
    self.lsSendCoupon.lblVal.text = @"";

    [self.rdoPositionJudgeSwitch initData:@"0"];


    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}

#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList *)obj{
    
    if (obj.tag == SHOP_MENUTYPE_SETTING){
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[GlobalRender listMenuTypes]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[GlobalRender listMenuTypes][index] event:obj.tag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }else if (obj.tag == LIST_COUPON){
        
        if([[Platform Instance] lockAct:PHONE_COUPON]){
            [AlertBox show:NSLocalizedString(@"您没有优惠券的权限", nil)];
            return;
        }
        __weak typeof (self) weakSelf = self;
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_tdfMemberCouponViewControllerWithParams:@{@"type":@1} callback:^(id obj) {
            TDFMemCouEditData *coupon = (TDFMemCouEditData *)obj;
            if ([ObjectUtil isEmpty:coupon]) {
                return;
            }    
            weakSelf.lsCoupon.lblName.text = NSLocalizedString(@"▪︎ 已选择", nil);
            NSString *data;
            if (coupon.couponType == 0) {
                data = [NSString stringWithFormat:NSLocalizedString(@"%.0f元现金券", nil),coupon.amount];
            } else{
                NSLog(@"%ld",coupon.discountRate%10);
                data =  (coupon.discountRate%10)?[NSString stringWithFormat:NSLocalizedString(@"%ld.%ld折打折券", nil),coupon.discountRate/10,coupon.discountRate%10]:[NSString stringWithFormat:NSLocalizedString(@"%ld折打折券", nil),coupon.discountRate/10];
            }
            [weakSelf.lsCoupon changeData:data withVal:[NSString stringWithFormat:@"%@",coupon.id]];
        }];
                              
        [self.navigationController pushViewController:vc animated:YES];

    }else if (obj.tag == LIST_S_COUPON){
        
        if([[Platform Instance] lockAct:PHONE_COUPON]){
            [AlertBox show:NSLocalizedString(@"您没有优惠券的权限", nil)];
            return;
        }
        __weak typeof (self) weakSelf = self;
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_tdfMemberCouponViewControllerWithParams:@{@"type":@1} callback:^(id obj) {
            TDFMemCouEditData *coupon = (TDFMemCouEditData *)obj;
            if ([ObjectUtil isEmpty:coupon]) {
                return;
            }
            weakSelf.lsSendCoupon.lblName.text = NSLocalizedString(@"▪︎ 已选择", nil);
            NSString *adata;
            if (coupon.couponType == 0) {
                adata = [NSString stringWithFormat:NSLocalizedString(@"%.0f元现金券", nil),coupon.amount];
            } else{
                NSLog(@"%ld",coupon.discountRate%10);
                adata =  (coupon.discountRate%10)?[NSString stringWithFormat:NSLocalizedString(@"%ld.%ld折打折券", nil),coupon.discountRate/10,coupon.discountRate%10]:[NSString stringWithFormat:NSLocalizedString(@"%ld折打折券", nil),coupon.discountRate/10];
            }
            [weakSelf.lsSendCoupon changeData:adata withVal:[NSString stringWithFormat:@"%@",coupon.id]];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == SHOP_MENUTYPE_SETTING) {
        [self.lsTypesetting changeData:[item obtainItemName] withVal:[item  obtainItemId]];
    }
    return YES;
}


- (void)onItemRadioClick:(EditItemRadio*)obj {
    if(obj.tag == RS_ORDER_TXT){
        [self subVisibal];
    }else if (obj.tag == RS_COUPON){
        BOOL isOpen = [self.rdoCoupon getVal];
        [self.lsCoupon visibal:isOpen];
    }else if (obj.tag == RS_S_COUPON){
        BOOL isOpen = [self.rdoSendCoupon getVal];
        [self.lsSendCoupon visibal:isOpen];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}


-(void) subVisibal
{
    BOOL isOpen=[self.rdoOrderTxt getVal];
    [self.rdoWaitMenu visibal:isOpen];
    [self.rdoPackMenu visibal:isOpen];
    [self.rdoServerStyle visibal:isOpen];
}
#pragma save-data
-(BOOL)isValid
{
    
    if ([self.rdoCoupon getVal]&& [NSString isBlank:[self.lsCoupon getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"优惠券不能为空!", nil)];
        return NO;
    }
    if ([self.rdoSendCoupon getVal]&& [NSString isBlank:[self.lsSendCoupon getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"优惠券不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(NSMutableArray*) transMode
{
    NSMutableArray *idList = [NSMutableArray array];
    if (self.isShowPrice) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isShowPrice._id,[self.rdoShowPrice getStrVal]]];
    }
    if (self.isTopGoods) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@",self.isTopGoods._id,[self.goodsTop getStrVal]]];
    }
    
    if (self.isShowOrderNum) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isShowOrderNum._id,[self.orderNumRadio getStrVal]]];
    }
    
    if (self.isShowClearFood) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isShowClearFood._id,[self.clearRadio getStrVal]]];
    }
    
    if (self.isShowCustomerComment) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isShowCustomerComment._id,[self.customCommentRadio getStrVal]]];
    }
    
    if (self.isShowDiscountRechargePop) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isShowDiscountRechargePop._id,[self.discountRechargePopRadio getStrVal]]];
    }
    
    if (self.isShowDiscountPop) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isShowDiscountPop._id,[self.discountPopRadio getStrVal]]];
    }
    
    if (self.isShowOrderMark) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isShowOrderMark._id,[self.rdoOrderTxt getStrVal]]];
    }
    
    if (self.isWait) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isWait._id,[self.rdoOrderTxt getVal]?[self.rdoWaitMenu getStrVal]:@"0"]];
    }
    if (self.isServing) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isServing._id,[self.rdoOrderTxt getVal]?[self.rdoServerStyle getStrVal]:@"0"]];
    }
    if (self.isPack) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPack._id,[self.rdoOrderTxt getVal]?[self.rdoPackMenu getStrVal]:@"0"]];
    }
    
    if (self.isPerpay) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPerpay._id,[self.rdoPerPay getStrVal]]];
    }
    
    if (self.isPerShopPay) {
        
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPerShopPay._id,[self.rdoShopPay getStrVal]]];
    }
    
    if (self.isMenuType) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isMenuType._id,[self.lsTypesetting getStrVal]]];
    }
    if (self.isPrint) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrint._id,[self.rdoPrintMenu getStrVal]]];
    }
    
    if (self.invoiceConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.invoiceConfig._id, [self.invoiceRadio getStrVal]]];
    }
    
    if (self.elecInvoiceConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.elecInvoiceConfig._id, [self.elecInvoiceRadio getStrVal]]];
    }
    if (self.isOpenPositionJudge) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isOpenPositionJudge._id,[self.rdoPositionJudgeSwitch getStrVal]]];
    }
    if (self.isSkinSpace) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isSkinSpace._id, [self.skinSpaceRadio getStrVal]]];
    }
    if (self.customerOrderAccountVerificationPopup) {
        [idList  addObject:[NSString stringWithFormat:@"%@|%@",self.isShowCustomerOrderPop._id,[self.customerOrderAccountVerificationPopup getStrVal]]];
    }
    return idList;
}

-(NSDictionary *)transConfig{
    return @{
             USE_MENU_QR_CODE :[self.rdoMenuCode getStrVal]
             };
}


#pragma test event
#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SETTINGEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SETTINGEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

#pragma mark 保存
-(void)save
{
    if (![self isValid]) {
        return;
    }
    NSMutableArray* ids=[self transMode];
    if ([ids count]==0) {
        [UIHelper ToastNotification:NSLocalizedString(@"没有配置项可以设置", nil) andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
//    [service saveConfig:ids Target:self Callback:@selector(remoteFinsh:)];
    @weakify(self);
    [TDFBaseSettingService saveBaseSettingListWithIdString:[ids yy_modelToJSONString] completeBlock:^(TDFResponseModel * response) {
        @strongify(self);
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            [self saveOtherConfig];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}

- (void)saveOtherConfig
{
    @weakify(self);
    [service saveSystemConfig:[self transConfig] callBack:^(TDFResponseModel *responseModel){
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
        if (responseModel.error) {
            [AlertBox show:responseModel.error.localizedDescription];
            return ;
        }
        NSDictionary *dict = responseModel.responseObject;
        if (![[dict objectForKey:@"code"] integerValue]) {
            [AlertBox show:[dict objectForKey:@"message"]];
            return;
        }
        if (self.shopConfigListArray.count <=0) {
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        for (TDFShopConfVoList *voList in self.shopConfigListArray) {
            switch (voList.type) {
                case 1:
                {
                    voList.couponId = [self.lsCoupon getStrVal];
                    voList.autoSend = [self.rdoCoupon getVal];
                    params[@"id_autoSend_promotionType_couponId"] = [voList yy_modelToJSONString];
                }
                    break;
                case 2:
                {
                    voList.couponId = [self.lsSendCoupon getStrVal];
                    voList.autoSend = [self.rdoSendCoupon getVal];
                    params[@"id_autoSend_shareType_couponId"] = [voList yy_modelToJSONString];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        if (params.count == 0) {
            return;
        }
        @weakify(self);
        [[TDFSettingService new]  savePacketWithParam:params sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (EditItemRadio *)invoiceRadio {
    
    if (!_invoiceRadio) {
        
        CGRect frame = self.rdoMenuCode.frame;
        _invoiceRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_invoiceRadio awakeFromNib];
    }
    return _invoiceRadio;
}

- (EditItemRadio *)elecInvoiceRadio{
    if (!_elecInvoiceRadio) {
        
        CGRect frame = self.invoiceRadio.frame;
        _elecInvoiceRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_elecInvoiceRadio awakeFromNib];
    }
    
    return _elecInvoiceRadio;
    
}
-(EditItemRadio *)rdoCoupon{
    
    if (!_rdoCoupon) {
        CGRect frame = self.elecInvoiceRadio.frame;
        _rdoCoupon = [[EditItemRadio alloc] initWithFrame:frame];
        [_rdoCoupon awakeFromNib];
        
    }
    return _rdoCoupon;
}
-(EditItemList *)lsCoupon{
    if (!_lsCoupon) {
        CGRect frame = self.rdoCoupon.frame;
        _lsCoupon = [[EditItemList alloc] initWithFrame:frame];
        [_lsCoupon awakeFromNib];
        
    }
    return _lsCoupon;
}


-(EditItemRadio *)rdoSendCoupon{
    
    if (!_rdoSendCoupon) {
        CGRect frame = self.lsCoupon.frame;
        _rdoSendCoupon = [[EditItemRadio alloc] initWithFrame:frame];
        [_rdoSendCoupon awakeFromNib];
        
    }
    return _rdoSendCoupon;
}

-(EditItemList *)lsSendCoupon{
    if (!_lsSendCoupon) {
        CGRect frame = self.rdoSendCoupon.frame;
        _lsSendCoupon = [[EditItemList alloc] initWithFrame:frame];
        [_lsSendCoupon awakeFromNib];
        
    }
    return _lsSendCoupon;
}
- (EditItemRadio *)skinSpaceRadio {
    if (!_skinSpaceRadio) {
        CGRect frame = self.lsSendCoupon.frame;
        _skinSpaceRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_skinSpaceRadio awakeFromNib];
    }
    
    return _skinSpaceRadio;
}


-(EditItemRadio *)orderNumRadio
{
    if (!_orderNumRadio) {
        CGRect frame = self.rdoShowPrice.frame;
        _orderNumRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_orderNumRadio awakeFromNib];
        _orderNumRadio.frame = _orderNumRadio.view.frame;
    }
    
    return _orderNumRadio;
}

-(EditItemRadio *)discountPopRadio
{
    if (!_discountPopRadio) {
        CGRect frame = self.orderNumRadio.frame;
        _discountPopRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_discountPopRadio awakeFromNib];
        _discountPopRadio.frame = _discountPopRadio.view.frame;
    }
    
    return _discountPopRadio;
}

-(EditItemRadio *)discountRechargePopRadio
{
    if (!_discountRechargePopRadio) {
        CGRect frame = self.orderNumRadio.frame;
        _discountRechargePopRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_discountRechargePopRadio awakeFromNib];
    }
    
    return _discountRechargePopRadio;
}

-(EditItemRadio *)clearRadio
{
    if (!_clearRadio) {
        CGRect frame = self.orderNumRadio.frame;
        _clearRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_clearRadio awakeFromNib];
    }
    
    return _clearRadio;
}

-(EditItemRadio *)customCommentRadio
{
    if (!_customCommentRadio) {
        CGRect frame = self.orderNumRadio.frame;
        _customCommentRadio = [[EditItemRadio alloc] initWithFrame:frame];
        [_customCommentRadio awakeFromNib];
    }
    
    return _customCommentRadio;
}


- (EditItemRadio *)goodsTop {
    if (!_goodsTop) {
        _goodsTop = [[EditItemRadio alloc] initWithFrame:self.orderNumRadio.frame];
        [_goodsTop awakeFromNib];
    }
    return _goodsTop;
}

@end

