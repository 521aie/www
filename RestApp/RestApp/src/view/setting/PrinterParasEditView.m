//
//  PrinterParasEditView.m
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigVO.h"
#import "UIHelper.h"
#import "ItemBase.h"
#import "AlertBox.h"
#import "Platform.h"
#import "ItemTitle.h"
#import "ItemImage.h"
#import "HelpDialog.h"
#import "SystemUtil.h"
#import "JsonHelper.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "UIView+Sizes.h"
#import "ConfigRender.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "EditItemMemo.h"
#import "EditItemText.h"
#import "UIView+Sizes.h"
#import "MemoInputBox.h"
#import "MBProgressHUD.h"
#import "RestConstants.h"
#import "SystemService.h"
#import "EditItemImage.h"
#import "EditItemRadio.h"
#import "NavigateTitle.h"
#import "SettingService.h"
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "ConfigConstants.h"
#import "TDFSettingService.h"
#import "TDFOptionPickerController.h"
#import "ConfigItemOption.h"
#import "NSString+Estimate.h"
#import "SettingModuleEvent.h"
#import "KindConfigConstants.h"
#import "PrinterParasEditView.h"
#import "NameItemVO.h"
#import "TDFRootViewController+FooterButton.h"
#import "ImageUtils.h"
#import "UIViewController+HUD.h"

@interface PrinterParasEditView () <EditItemListDelegate>

@property (nonatomic, strong) ConfigVO* taxRateConfig;
@property (nonatomic, strong) ConfigVO* currencyConfig;

@end

@implementation PrinterParasEditView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    service = [ServiceFactory Instance].settingService;
    systemService = [ServiceFactory Instance].systemService;
    
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    imagePickerController.delegate = self;
    
    UIView *bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    
    self.changed=NO;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    
}

- (UIView *) titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleDiv.backgroundColor = [UIColor redColor];
    }
    return _titleDiv;
}

#pragma set--get
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _container.backgroundColor = [UIColor clearColor];
        [_container addSubview:self.baseTitle];
        [_container addSubview:self.lsPrinterSort];
        [_container addSubview:self.txtShopMemo];
        [_container addSubview:self.rdoIsPrintOrder];
        [_container addSubview:self.rdoAccountBill];
        [_container addSubview:self.rdoIsPrintQRCode];
        [_container addSubview:self.rdoFinanceCashDrawer];
        [_container addSubview:self.rdoAccountCashDrawer];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
        [_container addSubview:view];
        
        [_container addSubview:self.titleOtherSet];
        [_container addSubview:self.taxRateView];
        [_container addSubview:self.currencyUnitView];
        [_container addSubview:self.numsOfVip];
        [_container addSubview:self.rdoIsPrintBell];
        [_container addSubview:self.rdoIsPrintGift];
        [_container addSubview:self.rdoIsPrintBack];
        [_container addSubview:self.rdoIsPrintConsume];
        [_container addSubview:self.lsConsumePrintIp];
        [_container addSubview:self.lsConsumeWordCount];
        
        [_container addSubview:self.rdoIsPrintDraw];
        [_container addSubview:self.lsDrawPrintIp];
        [_container addSubview:self.lsDrawWordCount];
        [_container addSubview:self.imgLogo];
    }
    return _container;
}

- (EditItemImage *) imgLogo
{
    if (!_imgLogo) {
        _imgLogo = [[EditItemImage alloc] initWithFrame:CGRectMake(0, 176, SCREEN_WIDTH, 251)];
        [_imgLogo awakeFromNib];
    }
    return _imgLogo;
}

- (EditItemList *) lsDrawPrintIp
{
    if (!_lsDrawPrintIp) {
        _lsDrawPrintIp = [[EditItemList alloc] initWithFrame:CGRectMake(0, 528, SCREEN_WIDTH, 44)];
    }
    return _lsDrawPrintIp;
}

- (EditItemList *) lsDrawWordCount
{
    if (!_lsDrawWordCount) {
        _lsDrawWordCount = [[EditItemList alloc] initWithFrame:CGRectMake(0, 484 + 88, SCREEN_WIDTH, 44)];
    }
    return _lsDrawWordCount;
}

- (EditItemRadio *) rdoIsPrintDraw
{
    if (!_rdoIsPrintDraw) {
        _rdoIsPrintDraw = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 396 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoIsPrintDraw;
}

- (EditItemList *) lsConsumePrintIp
{
    if (!_lsConsumePrintIp) {
        _lsConsumePrintIp = [[EditItemList alloc] initWithFrame:CGRectMake(0, 308 + 88, SCREEN_WIDTH, 44)];
    }
    return _lsConsumePrintIp;
}

- (EditItemList *) lsConsumeWordCount
{
    if (!_lsConsumeWordCount) {
        _lsConsumeWordCount = [[EditItemList alloc] initWithFrame:CGRectMake(0, 352 + 88, SCREEN_WIDTH, 44)];
    }
    return _lsConsumeWordCount;
}

- (EditItemRadio *) rdoIsPrintBell
{
    if (!_rdoIsPrintBell) {
        _rdoIsPrintBell = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 230 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoIsPrintBell;
}

- (EditItemRadio *) rdoIsPrintGift
{
    if (!_rdoIsPrintGift) {
        _rdoIsPrintGift = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 660 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoIsPrintGift;
}

- (EditItemRadio *) rdoIsPrintBack
{
    if (!_rdoIsPrintBack) {
        _rdoIsPrintBack = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 792 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoIsPrintBack;
}

- (EditItemRadio *) rdoIsPrintConsume
{
    if (!_rdoIsPrintConsume) {
        _rdoIsPrintConsume = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 264 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoIsPrintConsume;
}

- (ItemTitle *) titleOtherSet
{
    if (!_titleOtherSet) {
        _titleOtherSet = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 60)];
        [_titleOtherSet awakeFromNib];
    }
    return _titleOtherSet;
}


- (EditItemList *)taxRateView {

    if (!_taxRateView) {
        
        _taxRateView = [[EditItemList alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 44)];
        _taxRateView.tdf_delegate = self;
    }
    
    return _taxRateView;
}


- (EditItemList *)currencyUnitView {
    
    if (!_currencyUnitView) {
        
        _currencyUnitView = [[EditItemList alloc] initWithFrame:CGRectMake(0, 274, SCREEN_WIDTH, 44)];
    }
    
    return _currencyUnitView;
}


- (EditItemList *) numsOfVip
{
    if (!_numsOfVip) {
        _numsOfVip = [[EditItemList alloc] initWithFrame:CGRectMake(0, 230 + 88, SCREEN_WIDTH, 44)];
    }
    return _numsOfVip;
}

- (ItemTitle *) baseTitle
{
    if (!_baseTitle) {
        _baseTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 222, SCREEN_WIDTH, 60)];
        [_baseTitle awakeFromNib];
    }
    return _baseTitle;
}

- (EditItemList *) lsPrinterSort
{
    if (!_lsPrinterSort) {
        _lsPrinterSort = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    }
    return _lsPrinterSort;
}

- (EditItemMemo *) txtShopMemo
{
    if (!_txtShopMemo) {
        _txtShopMemo = [[EditItemMemo alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 44)];
    }
    return _txtShopMemo;
}

- (EditItemRadio *) rdoIsPrintOrder
{
    if (!_rdoIsPrintOrder) {
        _rdoIsPrintOrder = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 704 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoIsPrintOrder;
}

- (EditItemRadio *) rdoAccountBill
{
    if (!_rdoAccountBill) {
        _rdoAccountBill = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 528 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoAccountBill;
}

- (EditItemRadio *) rdoIsPrintQRCode
{
    if (!_rdoIsPrintQRCode) {
        _rdoIsPrintQRCode = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 748 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoIsPrintQRCode;
}

- (EditItemRadio *) rdoFinanceCashDrawer
{
    if (!_rdoFinanceCashDrawer) {
        _rdoFinanceCashDrawer = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 572 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoFinanceCashDrawer;
}

- (EditItemRadio *) rdoAccountCashDrawer
{
    if (!_rdoAccountCashDrawer) {
        _rdoAccountCashDrawer = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 616 + 88, SCREEN_WIDTH, 44)];
    }
    return _rdoAccountCashDrawer;
}

#pragma navigateBar
-(void) initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"收银打印", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"收银打印", nil);
}

#pragma ui.
-(void) initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.lsPrinterSort initLabel:NSLocalizedString(@"单据上的商品排序方式", nil) withHit:nil delegate:self];
    [self.txtShopMemo initLabel:NSLocalizedString(@"客户联尾注", nil) isrequest:NO  delegate:self];
    self.txtShopMemo.lblVal.text=@"";
    [self.rdoIsPrintOrder initLabel:NSLocalizedString(@"点菜单打印", nil) withHit:NSLocalizedString(@"点单设备下单后自动打印点菜单", nil)];
    [self.rdoAccountBill initLabel:NSLocalizedString(@"财务联打印", nil) withHit:NSLocalizedString(@"结账完毕后自动打印财务联", nil)];
    [self.rdoIsPrintQRCode initLabel:NSLocalizedString(@"小票二维码打印", nil) withHit:NSLocalizedString(@"点菜单与客户联尾部打印客单二维码", nil)];
    [self.rdoFinanceCashDrawer initLabel:NSLocalizedString(@"打印财务联时自动打开钱箱", nil) withHit:nil];
    [self.rdoAccountCashDrawer initLabel:NSLocalizedString(@"打印客户联时自动打开钱箱", nil) withHit:nil];
    
    self.titleOtherSet.lblName.text=NSLocalizedString(@"其他设置", nil);
    //新增
 
    [self.numsOfVip initLabel:NSLocalizedString(@"使用会员卡支付时消费凭证的打印份数", nil) withHit:nil delegate:self];

    [self.rdoIsPrintBell initLabel:NSLocalizedString(@"打印单据时发出蜂鸣声", nil) withHit:nil];
    [self.rdoIsPrintGift initLabel:NSLocalizedString(@"赠送商品打印", nil) withHit:NSLocalizedString(@"点菜单,客户联和财务联打印赠送商品", nil)];
    [self.rdoIsPrintBack initLabel:NSLocalizedString(@"退菜明细打印", nil) withHit:NSLocalizedString(@"客户联和财务联上打印退菜明细", nil)];
    
    [self.rdoIsPrintConsume initLabel:NSLocalizedString(@"下单时打印消费底联", nil) withHit:nil delegate:self];
    [self.lsConsumePrintIp initLabel:NSLocalizedString(@"▪︎ 打印机IP地址", nil) withHit:nil delegate:self];
    [self.lsConsumeWordCount initLabel:NSLocalizedString(@"▪︎ 每行打印字符数", nil) withHit:nil delegate:self];
    
    [self.rdoIsPrintDraw initLabel:NSLocalizedString(@"下单时打印划菜联", nil) withHit:nil delegate:self];
    [self.lsDrawPrintIp initLabel:NSLocalizedString(@"▪︎ 打印机IP地址", nil) withHit:nil delegate:self];
    [self.lsDrawWordCount initLabel:NSLocalizedString(@"▪︎ 每行打印字符数", nil) withHit:nil delegate:self];
//    [self.txtAddPrefix initLabel:NSLocalizedString(@"打印时单号前加字符", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.imgLogo initLabel:NSLocalizedString(@"店家logo（400x300）", nil) withHit:nil delegate:self];
   [self.imgLogo initView:nil path:nil];
    
    [self.taxRateView initLabel:@"税率（百分比）" withHit:nil delegate:self];
    [self.currencyUnitView initLabel:@"货币单位" withHit:nil delegate:self];

    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsPrinterSort.tag=PRINTER_PARA_SORT;
    self.lsConsumeWordCount.tag=PRINTER_PARA_CONSUME_WORDCOUNT;
    self.lsDrawWordCount.tag=PRINTER_PARA_DRAW_WORDCOUNT;
    self.rdoIsPrintConsume.tag=PRINTER_PARA_IS_CONSUME;
    self.rdoIsPrintDraw.tag=PRINTER_PARA_IS_DRAW;
    self.rdoIsPrintGift.tag=PRINTER_PARA_IS_GIFT;
    self.rdoIsPrintBack.tag=PRINTER_PARA_IS_BACK;
    self.lsConsumePrintIp.tag=PRINTER_PARA_CONSUMEPRINTIP;
    self.lsDrawPrintIp.tag=PRINTER_PARA_DRAWPRINTIP;
    self.numsOfVip.tag = CARD_CONSUM_PRINT_NUMBER;
    
    [self.container setBackgroundColor:[UIColor clearColor]];
    
    [self.lsConsumePrintIp setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeIPAddress hasSymbol:NO];
    [self.lsDrawPrintIp setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeIPAddress hasSymbol:NO];
    [self.taxRateView setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_PrinterParasEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_PrinterParasEditView_Change object:nil];
    
}

- (void)leftNavigationButtonAction:(id)sender {
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender {
    [self save];
}

#pragma remote
-(void) loadData
{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
   // [service loadPrintPara:PRINT_CONFIG Target:self Callback:@selector(loadFinsh:)];
    [[TDFSettingService new] loadPrintPara:PRINT_CONFIG sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        NSDictionary *map= data [@"data"];
        NSArray *list = [map objectForKey:@"configs"];
        NSMutableArray *configVOList=[JsonHelper transList:list objName:@"ConfigVO"];
        
        NSDictionary *shopDic = [map objectForKey:@"shopDetailVo"];
        self.shopDetail=[JsonHelper dicTransObj:shopDic obj:[ShopDetail alloc]];
        
        NSString* filePath = [map objectForKey:@"filePath"];
        NSString* path = [map objectForKey:@"path"];
        if ([filePath isKindOfClass:[NSNull class]] || [NSString isBlank:filePath]) {
            [self.imgLogo initView:nil path:nil];
        } else {
            [self.imgLogo initView:filePath path:path];
            
        }
        self.imgLogo.lblTip.hidden=YES;
        [self fillModel:configVOList];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma ui-data-bind
-(void) fillModel:(NSMutableArray *)configVOList
{
    
    NSMutableDictionary* map=[ConfigRender transDic:configVOList];
    self.printerSortConfig=[map objectForKey:PRINT_ORDER];
    [self.lsPrinterSort initData:[ConfigRender getOptionName:self.printerSortConfig] withVal:self.printerSortConfig.val];
    self.isPrintbeepConfig=[ConfigRender fillConfig:IS_PRINT_BELL withControler:self.rdoIsPrintBell withMap:map];
    
    self.isPrintConsumeConfig=[ConfigRender fillConfig:IS_PRINT_CONSUME withControler:self.rdoIsPrintConsume withMap:map];
    self.numsOfVipConfig = [map objectForKey:NUMBERS_OF_VIP];
    
    //增加默认值为一份判断服务器端是否返回份数，有份数直接使用无份数使用默认值
    NSString *vipCountStr = self.numsOfVipConfig.val;
    if (vipCountStr) {
        [self.numsOfVip initData:[NSString stringWithFormat:NSLocalizedString(@"%@份", nil),vipCountStr] withVal:vipCountStr];
    }else {
        [self.numsOfVip initData:NSLocalizedString(@"1份", nil) withVal:@"1"];
    }
    
    self.taxRateConfig = [map objectForKey:DEFAULT_TAX_RATE];
    self.currencyConfig = [map objectForKey:DEFAULT_CURRENCY];
    
    [self.taxRateView initData:self.taxRateConfig.val withVal:self.taxRateConfig.val];
    [self.currencyUnitView initData:[ConfigRender getOptionName:self.currencyConfig] withVal:self.currencyConfig.val];
    
    [self.numsOfVip initData:[ConfigRender getOptionName:self.numsOfVipConfig] withVal:self.numsOfVipConfig.val];
    
    self.consumePrinterIpConfig=[map objectForKey:CONSUME_PRINTER_IP];
    NSString* consumePrintIp=self.consumePrinterIpConfig?self.consumePrinterIpConfig.val:nil;
    [self.lsConsumePrintIp initData:consumePrintIp withVal:consumePrintIp];
    self.consumePrinterCharNumConfig=[map objectForKey:CONSUME_PRINTER_CHAR_NUM];
    [self.lsConsumeWordCount initData:[ConfigRender getOptionName:self.consumePrinterCharNumConfig] withVal:self.consumePrinterCharNumConfig.val];
    
    [self.lsConsumeWordCount visibal:[self.rdoIsPrintConsume getVal]];
    [self.lsConsumePrintIp visibal:[self.rdoIsPrintConsume getVal]];
    
    self.isPrintDrawConfig=[ConfigRender fillConfig:IS_PRINT_DRAW withControler:self.rdoIsPrintDraw withMap:map];
    self.drawPrinterIpConfig=[map objectForKey:DRAW_PRINTER_IP];
    NSString* drawPrintIp=(self.drawPrinterIpConfig?self.drawPrinterIpConfig.val:nil);
    [self.lsDrawPrintIp initData:drawPrintIp withVal:drawPrintIp];
    self.drawPrinterCharNumConfig=[map objectForKey:DRAW_PRINTER_CHAR_NUM];
    [self.lsDrawWordCount initData:[ConfigRender getOptionName:self.drawPrinterCharNumConfig] withVal:self.drawPrinterCharNumConfig.val];
    
    [self.lsDrawWordCount visibal:[self.rdoIsPrintDraw getVal]];
    [self.lsDrawPrintIp visibal:[self.rdoIsPrintDraw getVal]];
    
    self.isAccountBillConfig=[ConfigRender fillConfig:ACCOUNT_BILL withControler:self.rdoAccountBill withMap:map];
    self.financeCashDrawerConfig=[ConfigRender fillConfig:FINANCE_CASH_DRAWER withControler:self.rdoFinanceCashDrawer withMap:map];
    self.isAccountCashDrawerConfig=[ConfigRender fillConfig:ACCOUNT_CASH_DRAWER withControler:self.rdoAccountCashDrawer withMap:map];
    self.isPrintGiftConfig=[ConfigRender fillConfig:IS_PRINT_GIFT withControler:self.rdoIsPrintGift withMap:map];
    self.isPrintOrderConfig=[ConfigRender fillConfig:IS_PRINT_ORDER withControler:self.rdoIsPrintOrder withMap:map];
    self.isPrintQRCodeConfig=[ConfigRender fillConfig:ONLINEPAY_ENABLE withControler:self.rdoIsPrintQRCode withMap:map];
    self.isPrintBackConfig=[ConfigRender fillConfig:IS_PRINT_BACK withControler:self.rdoIsPrintBack withMap:map];
    
    self.isAddPrefixConfig=[map objectForKey:IS_ADD_PREFIX];
//    [self.txtAddPrefix initData:self.isAddPrefixConfig?self.isAddPrefixConfig.val:nil];

    [self.txtShopMemo initData:self.shopDetail.memo];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsPrinterSort getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择单据上的商品排序方式", nil)];
        return NO;
    }
    if (![NSString isValidatIP:[self.lsDrawPrintIp getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印机IP地址无效!", nil)];
        return NO;
    }
    return YES;
}

-(NSMutableArray*) transMode
{
    NSMutableArray *idList = [NSMutableArray array];
    if (self.isAccountBillConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isAccountBillConfig._id,[self.rdoAccountBill getStrVal]]];
    }
    
    if (self.financeCashDrawerConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.financeCashDrawerConfig._id,[self.rdoFinanceCashDrawer getStrVal]]];
    }
    
    if (self.isAccountCashDrawerConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isAccountCashDrawerConfig._id,[self.rdoAccountCashDrawer getStrVal]]];
    }
    
    if (self.printerSortConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.printerSortConfig._id,[self.lsPrinterSort getStrVal]]];
    }
    
    if (self.isPrintbeepConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrintbeepConfig._id,[self.rdoIsPrintBell getStrVal]]];
    }
    
    if (self.isPrintConsumeConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrintConsumeConfig._id,[self.rdoIsPrintConsume getStrVal]]];
    }
    
    if (self.isPrintDrawConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrintDrawConfig._id,[self.rdoIsPrintDraw getStrVal]]];
    }
    
    if (self.isPrintOrderConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrintOrderConfig._id,[self.rdoIsPrintOrder getStrVal]]];
    }
    
    if (self.taxRateConfig) {
        
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.taxRateConfig._id,[self.taxRateView getStrVal]]];
    }
    
    if (self.currencyConfig) {
        
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.currencyConfig._id,[self.currencyUnitView getStrVal]]];
    }
    
    if (self.isPrintQRCodeConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrintQRCodeConfig._id,[self.rdoIsPrintQRCode getStrVal]]];
    }
    
    if (self.isAddPrefixConfig) {
//        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isAddPrefixConfig._id,[self.txtAddPrefix getStrVal]]];
    }
    
    if (self.isPrintBackConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrintBackConfig._id,[self.rdoIsPrintBack getStrVal]]];
    }
    BOOL isConsume=[self.rdoIsPrintConsume getVal];
    BOOL isDraw=[self.rdoIsPrintDraw getVal];
    if (isConsume && self.consumePrinterIpConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.consumePrinterIpConfig._id,[self.lsConsumePrintIp getStrVal]]];
        
    }
    if (isConsume && self.consumePrinterCharNumConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.consumePrinterCharNumConfig._id,[self.lsConsumeWordCount getStrVal]]];
    }
    
    if (isDraw && self.drawPrinterIpConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.drawPrinterIpConfig._id,[self.lsDrawPrintIp getStrVal]]];
        
    }
    if (isDraw && self.drawPrinterCharNumConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.drawPrinterCharNumConfig._id,[self.lsDrawWordCount getStrVal]]];
        
    }
    if (self.isPrintGiftConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPrintGiftConfig._id,[self.rdoIsPrintGift getStrVal]]];
    }
    if (self.numsOfVipConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@",self.numsOfVipConfig._id,[self.numsOfVip getStrVal]]];
    }
    
    return idList;
    
    
}

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
    [[TDFSettingService new] savePrintParaConfig:ids shopLogo:[self.imgLogo getImageFilePath] memo:[self.txtShopMemo getStrVal] sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  hide: YES];
        [UIHelper clearChange:self.container];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud  hide: YES];
        [AlertBox show:error.localizedDescription];
    }];
//     [service savePrintParaConfig:ids shopLogo:[self.imgLogo getImageFilePath] memo:[self.txtShopMemo getStrVal] Target:self Callback:@selector(remoteFinsh:)];

}

#pragma test event
-(void) onItemMemoListClick:(EditItemMemo*)obj
{
    [MemoInputBox show:1 delegate:self title:NSLocalizedString(@"客户联尾注", nil) val:[self.txtShopMemo getStrVal]];
}

-(void) finishInput:(NSInteger)event content:(NSString*)content
{
    [self.txtShopMemo changeData:content];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma editItemRadio click event
//Radio控件变换.
-(void) onItemRadioClick:(EditItemRadio*)obj
{
    if (obj.tag==PRINTER_PARA_IS_CONSUME) {
        [self.lsConsumeWordCount visibal:[obj getVal]];
        [self.lsConsumePrintIp visibal:[obj getVal]];
    } else if (obj.tag==PRINTER_PARA_IS_DRAW) {
        [self.lsDrawWordCount visibal:[obj getVal]];
        [self.lsDrawPrintIp visibal:[obj getVal]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - EditItemListDelegate

- (void)editItemListDidFinishEditing:(EditItemList *)editItem {
    
    if (self.taxRateView == editItem && [self.taxRateView.currentVal integerValue] > 100) {
        
        [self showErrorMessage:@"税率输入不可超过100."];
        [self.taxRateView changeData:@"100" withVal:@"100"];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}
- (BOOL)editItemListshouldInsertText:(EditItemList *)editItem WithSting:(NSString *)str {

    
    if (self.taxRateView == editItem) {
        
        if ([self.taxRateView.currentVal containsString:@"."]) {
         
            NSInteger len = [[[str componentsSeparatedByString:@"."] lastObject] length];
            return len < 2;
            }
        }
    
    return YES;
}

#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    if (obj == self.currencyUnitView) {
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.currencyConfig.options
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            id<INameItem> vo=(id<INameItem>)wself.currencyConfig.options[index];
            [wself.currencyUnitView changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
            [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==PRINTER_PARA_SORT) {
        //选择单据上的商品排序方式
//        [OptionPickerBox initData:self.printerSortConfig.options itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.printerSortConfig.options
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.printerSortConfig.options[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==PRINTER_PARA_CONSUME_WORDCOUNT) {
//        [OptionPickerBox initData:self.consumePrinterCharNumConfig.options itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.consumePrinterCharNumConfig.options
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.consumePrinterCharNumConfig.options[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];

    } else if (obj.tag==PRINTER_PARA_DRAW_WORDCOUNT) {
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.drawPrinterCharNumConfig.options
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.drawPrinterCharNumConfig.options[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }else if (obj.tag==CARD_CONSUM_PRINT_NUMBER){
    
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.numsOfVipConfig.options
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.numsOfVipConfig.options[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];

    }
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    id<INameItem> vo=(id<INameItem>)item;
    if (event==PRINTER_PARA_SORT) {
        [self.lsPrinterSort changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    } else if (event==PRINTER_PARA_CONSUME_WORDCOUNT) {
        [self.lsConsumeWordCount changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    } else if (event==PRINTER_PARA_DRAW_WORDCOUNT) {
        [self.lsDrawWordCount changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    } else if (event==CARD_CONSUM_PRINT_NUMBER) {
        [self.numsOfVip changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
    
    return YES;
}

- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==PRINTER_PARA_CONSUMEPRINTIP) {
        [self.lsConsumePrintIp changeData:val withVal:val];
    } else if (eventType==PRINTER_PARA_DRAWPRINTIP) {
        [self.lsDrawPrintIp changeData:val withVal:val];
    }
}

-(void) onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex==1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:NSLocalizedString(@"相机好像不能用哦!", nil)];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if(btnIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:NSLocalizedString(@"相册好像不能访问哦!", nil)];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    shopImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString* entityId = [[Platform Instance] getkey:ENTITY_ID];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/shopdetail/%@.png",entityId, [NSString getUniqueStrByUUID]];
    self.imgFilePathTemp = filePath;
    [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)];
    [systemService uploadImage:filePath image:shopImage width:1280 heigth:1280 Target:self Callback:@selector(uploadFinsh:)];
}

-(void) onDelImgClick
{
    [self.imgLogo changeImg:nil img:nil];
    [self updateImg];
    //    self.imgLogo.lblTip.hidden=NO;
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];;
}

/*
 !] Error installing MWPhotoBrowser
 [!] /usr/bin/git clone https://github.com/mwaterfall/MWPhotoBrowser.git /var/folders/x4/vlvkk7ln2fz5s819476t4m100000gn/T/d20160909-40284-zwxky7 --template= --single-branch --depth 1 --branch 1.2.1
 Cloning into '/var/folders/x4/vlvkk7ln2fz5s819476t4m100000gn/T/d20160909-40284-zwxky7'...
 error: RPC failed; curl 56 SSLRead() return error -9806
 fatal: The remote end hung up unexpectedly
 fatal: early EOF
 fatal: index-pack failed

 */
-(void) uploadFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
     [self.imgLogo changeImg:self.imgFilePathTemp img:shopImage];
     [self updateImg];
}

//上传到收银确保服务器删除图片
- (void)updateImg
{
    [[TDFSettingService new] saveShopImgFilePath:self.imgFilePathTemp sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox  show:error.localizedDescription];
    }];
}

-(void)remoteFinsh:(RemoteResult*)result
{
    [self.progressHud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [UIHelper clearChange:self.container];
    //    [parent backNavigateMenuView];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  回收处理.
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.titleBox=nil;
    
    self.container=nil;
    self.scrollView=nil;
    service=nil;
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"printerparas"];
}

//懒加载份数选择数组
- (NSMutableArray *)vipCountChoiceArr {
    
    if (!_vipCountChoiceArr) {
        _vipCountChoiceArr = [NSMutableArray array];
        for (int i = 1; i < 6; i ++) {
            NameItemVO *vo = [[NameItemVO alloc] initWithVal:[NSString stringWithFormat:NSLocalizedString(@"%d份", nil),i] andId:[NSString stringWithFormat:@"%d",i]];
            [_vipCountChoiceArr addObject:vo];
        }
        
    }
    return _vipCountChoiceArr;
}

@end
