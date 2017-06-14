//
//  TakeOutSetView.m
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHelper.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "SystemUtil.h"
#import "FormatUtil.h"
#import "HelpDialog.h"
#import "KabawModule.h"
#import "RemoteEvent.h"
#import "UIView+Sizes.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "KabawService.h"
#import "GlobalRender.h"
#import "EditMultiList.h"
#import "EditItemRadio.h"
#import "MBProgressHUD.h"
#import "NavigateTitle.h"
#import "ReserveRender.h"
#import "FooterListView.h"
#import "RatioPickerBox.h"
#import "ServiceFactory.h"
#import "SenderListView.h"
#import "NavigateTitle2.h"
#import "KabawModuleEvent.h"
#import "NSString+Estimate.h"
#import "TakeOutSetEditView.h"
#import "TakeOutTimeListView.h"
#import "TDFTakeOutSettings.h"
#import "TDFTakeoutSettingsVo.h"
#import "TDFMediator+KabawModule.h"
#import "YYModel.h"
#import "TDFSettingService.h"
#import "TDFKabawService.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMapViewController.h"
#import "FormatUtil.h"
#import <UMSocialCore/UMSocialCore.h>


@interface TakeOutSetEditView ()

@property (strong, nonatomic) UMSocialMessageObject *messageObject;

@end


@implementation TakeOutSetEditView

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
    service=[ServiceFactory Instance].kabawService;
    self.changed=NO;
    UIView *bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadDatas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma set--get
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
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
        _container.backgroundColor = [UIColor clearColor];
        
        [_container addSubview:self.rdoIsSale];
        [_container addSubview:self.lsOutFeeMode];
        [_container addSubview:self.lsFee];
        [_container addSubview:self.txtArea];
        [_container  addSubview:self.txtNewArea];
        [_container  addSubview:self.whetherSupportCustomerAuto];
        [_container   addSubview:self.outStartAmount];
        [_container addSubview:self.txtMinute];
        [_container  addSubview:self.advanceAutoOrder];
        [_container addSubview:self.mlsTime];
        [_container   addSubview:self.whetherAppointment];
        [_container addSubview:self.mlsSender];
//        [_container addSubview:self.summaryInfoView];
//        [_container addSubview:self.sendInfoView];
//        [_container addSubview:self.lblHelp];
    }
    return _container;
}

- (EditItemRadio *) rdoIsSale
{
    if (!_rdoIsSale) {
        _rdoIsSale = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    }
    return _rdoIsSale;
}

- (EditItemList *) lsOutFeeMode
{
    if (!_lsOutFeeMode) {
        _lsOutFeeMode = [[EditItemList alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, 48)];
    }
    return _lsOutFeeMode;
}

- (EditItemList *) lsFee
{
    if (!_lsFee) {
        _lsFee = [[EditItemList alloc] initWithFrame:CGRectMake(0, 92, SCREEN_WIDTH, 48)];
    }
    return _lsFee;
}

- (EditItemList *) txtArea
{
    if (!_txtArea) {
        _txtArea = [[EditItemList alloc]initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, 48)];
    }
    return _txtArea;
}

- (EditItemText *)txtNewArea
{
    if (!_txtNewArea) {
        _txtNewArea = [[EditItemText alloc]initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, 48)];
    }
    return _txtNewArea;
}

- (EditItemList *)outStartAmount
{
    if (!_outStartAmount) {
        _outStartAmount = [[EditItemList alloc]initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 48)];
    }
    return _outStartAmount;
}

- (EditItemText *) txtMinute
{
    if (!_txtMinute) {
        _txtMinute = [[EditItemText alloc]initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 48)];
    }
    return _txtMinute;
}

- (EditItemText  *)advanceAutoOrder
{
    if (!_advanceAutoOrder) {
        _advanceAutoOrder = [[EditItemText alloc]initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 48)];
    }
    return _advanceAutoOrder;
}

- (EditMultiList *) mlsTime
{
    if (!_mlsTime) {
        _mlsTime = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 278, SCREEN_WIDTH, 47)];
    }
    return _mlsTime;
}

- (EditItemRadio  *)whetherAppointment;
{
    if (!_whetherAppointment) {
        _whetherAppointment   = [[ EditItemRadio  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    }
    return _whetherAppointment;
}

- (EditItemRadio *)whetherSupportCustomerAuto
{
    if (!_whetherSupportCustomerAuto) {
        _whetherSupportCustomerAuto  = [[EditItemRadio  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    }
    return _whetherSupportCustomerAuto;
}

- (EditMultiList *) mlsSender
{
    if (!_mlsSender) {
        _mlsSender = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 326, SCREEN_WIDTH, 47)];
    }
    return _mlsSender;
}

- (UIView *) summaryInfoView
{
    if (!_summaryInfoView) {
        _summaryInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, SCREEN_WIDTH, 320)];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, -4, SCREEN_WIDTH - 20, 35)];
        label1.text = NSLocalizedString(@"▪︎  店铺外卖二维码", nil);
        label1.textColor = [UIColor blackColor];
        label1.font = [UIFont systemFontOfSize:16];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.numberOfLines = 0;
        [_summaryInfoView addSubview:label1];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 350, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_summaryInfoView addSubview:line];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 255, SCREEN_WIDTH - 40, 122)];
        label2.text = NSLocalizedString(@"顾客可通过扫描店铺外卖二维码，进入外卖菜单，进行外卖点餐、下单操作。该二维码可用于店铺微信公众号内、外卖传单上、或进行网络传播等，辅助扩大店铺营业范围，完善餐厅业务。", nil);
        label2.textColor = [UIColor grayColor];
        label2.font = [UIFont systemFontOfSize:12];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.numberOfLines = 0;
        [_summaryInfoView addSubview:label2];
        
        [_summaryInfoView addSubview:self.setQRCodeImageView];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH - 20, 62)];
        label3.text = NSLocalizedString(@"提示：若当前店铺的收款方式支付宝或微信中至少开通一个大账户结算的，便可使用该外卖功能。即支付宝开通大账号，消费者用支付宝扫描外卖二维码便可下外卖订单。", nil);
        label3.lineBreakMode   =  UILineBreakModeCharacterWrap;
        label3.textColor = [UIColor redColor];
        label3.font = [UIFont systemFontOfSize:10];
        label3.textAlignment = NSTextAlignmentLeft;
        label3.numberOfLines = 0;
        [_summaryInfoView addSubview:label3];
    }
    return _summaryInfoView;
}

- (UIView *) sendInfoView
{
    if (!_sendInfoView) {
        _sendInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 770,SCREEN_WIDTH , 131)];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 122, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_sendInfoView addSubview:line];
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 31, 60, 77)];
        [btn1 addTarget:self action:@selector(shareToWeChatFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendInfoView addSubview:btn1];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(12 , 31, 52, 54)];
        imageView1.image = [UIImage imageNamed:@"icon_weixin.png"];
        [_sendInfoView addSubview:imageView1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(13, 89, 54, 21)];
        label1.text = NSLocalizedString(@"微信好友", nil);
        label1.textColor = [UIColor grayColor];
        label1.font = [UIFont systemFontOfSize:12];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.numberOfLines = 1;
        [_sendInfoView addSubview:label1];
        
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(70 + (SCREEN_WIDTH - 260)/3, 31, 60, 77)];
        [btn2 addTarget:self action:@selector(shareToWeChatMomentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendInfoView addSubview:btn2];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(73 + (SCREEN_WIDTH - 260)/3 , 31, 54, 54)];
        imageView2.image = [UIImage imageNamed:@"icon_pengyouquan.png"];
        [_sendInfoView addSubview:imageView2];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(58 + (SCREEN_WIDTH - 260)/3, 89, 84, 21)];
        label2.text = NSLocalizedString(@"微信朋友圈", nil);
        label2.textColor = [UIColor grayColor];
        label2.font = [UIFont systemFontOfSize:12];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.numberOfLines = 1;
        [_sendInfoView addSubview:label2];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(130 + (SCREEN_WIDTH - 260)/3*2, 31, 60, 77)];
        [btn3 addTarget:self action:@selector(downLoadQRCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendInfoView addSubview:btn3];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(135 + (SCREEN_WIDTH - 260)/3*2 , 31, 54, 54)];
        imageView3.image = [UIImage imageNamed:@"download.png"];
        [_sendInfoView addSubview:imageView3];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(130 + (SCREEN_WIDTH - 260)/3*2, 89, 65, 21)];
        label3.text = NSLocalizedString(@"下载二维码", nil);
        label3.textColor = [UIColor grayColor];
        label3.font = [UIFont systemFontOfSize:12];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.numberOfLines = 1;
        [_sendInfoView addSubview:label3];
        
        UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(190 + (SCREEN_WIDTH - 260)/3*3, 31, 60, 77)];
        [btn4 addTarget:self action:@selector(pasteLinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendInfoView addSubview:btn4];
        
        UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(188 + (SCREEN_WIDTH - 260)/3*3 , 31, 54, 54)];
        imageView4.image = [UIImage imageNamed:@"link.png"];
        [_sendInfoView addSubview:imageView4];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(188 + (SCREEN_WIDTH - 260)/3*3, 89, 54, 21)];
        label4.text = NSLocalizedString(@"链接", nil);
        label4.textColor = [UIColor grayColor];
        label4.font = [UIFont systemFontOfSize:12];
        label4.textAlignment = NSTextAlignmentCenter;
        label4.numberOfLines = 1;
        [_sendInfoView addSubview:label4];
    }
    return _sendInfoView;
}

- (UITextView *) lblHelp
{
    if (!_lblHelp) {
        _lblHelp = [[UITextView alloc] initWithFrame:CGRectMake(8, 890, SCREEN_WIDTH  - 16,46)];
        _lblHelp.textColor = [UIColor redColor];
        _lblHelp.font = [UIFont systemFontOfSize:12];
    }
    return _lblHelp;
}

- (UIImageView *) setQRCodeImageView
{
    if (!_setQRCodeImageView) {
        _setQRCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 180)/2, 100, 180, 180)];
    }
    return _setQRCodeImageView;
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"外卖设置", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = @"外卖";
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self save];
    }
}

-(void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    [self save];
}

- (void)initMainView
{
    [self.rdoIsSale initLabel:NSLocalizedString(@"开通顾客端外卖", nil) withHit:nil delegate:self];
    [self.lsOutFeeMode initLabel:NSLocalizedString(@"▪︎ 外送费收费模式", nil) withHit:nil delegate:self];
    [self.lsFee initLabel:NSLocalizedString(@"▪︎ 外送费(元)", nil) withHit:nil isrequest:YES delegate:self];

 //   [self.txtArea initLabel:NSLocalizedString(@"▪︎ 外送范围", nil) ];
    [self.txtArea  initLabel:NSLocalizedString(@"▪︎ 外送范围(公里内)", nil) withHit:NSLocalizedString(@"根据当前店铺定位及选择的直线距离所圈定区域为配送范围", nil) delegate:self];
    [self.txtNewArea initLabel:NSLocalizedString(@"▪︎ 外送范围", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
//    [self.txtbefore initLabel:NSLocalizedString(@"▪︎ 提前多长时间自动下单(分)", nil) withHit:NSLocalizedString(@"自动审核/手动审核通过的外卖订单，会根据此项的设置时间提前下单到厨房。若设置时间问为0，则表示审核后的外卖订单立即下单到厨房。", nil) isrequest:YES type:UIKeyboardTypeNumberPad];
//    [self.txtbefore.lblName setWidth:220];
    [self.whetherSupportCustomerAuto   initLabel:NSLocalizedString(@"▪︎ 是否支持客户到店自取", nil) withHit:@"打开此开关后，任意位置客户均可下外卖订单并根据提货时间到店取餐。" delegate:self];
    [self.whetherSupportCustomerAuto  initData: @"0"];
    
    [self.outStartAmount  initLabel:NSLocalizedString(@"▪︎ 外卖订单起送金额(元)", nil) withHit:NSLocalizedString(@"单笔外卖金额（除去外送费、餐盒费）达到该项设置的金额时，才能顺利下单。", nil)  isrequest:YES delegate:self];

    //    [self.txtbefore initLabel:NSLocalizedString(@"▪︎ 提前多长时间自动下单(分)", nil) withHit:NSLocalizedString(@"自动审核/手动审核通过的外卖订单，会根据此项的设置时间提前下单到厨房。若设置时间问为0，则表示审核后的外卖订单立即下单到厨房。", nil) isrequest:YES type:UIKeyboardTypeNumberPad];
    //    [self.txtbefore.lblName setWidth:220];

    [self.txtMinute initLabel:NSLocalizedString(@"▪︎ 预计接单多久后送达(分)", nil) withHit:NSLocalizedString(@"设置后顾客在小二端订单确认页面的送达时间栏会展示预计收货的时间点", nil) isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtMinute.lblName setWidth:220];
    
    [self.advanceAutoOrder  initLabel:NSLocalizedString(@"▪︎ 接单后提前多久下到厨房（分）", nil) withHit:NSLocalizedString(@"审核通过的外卖订单，会根据此项的设置时间提前下单到厨房。", nil)  isrequest:YES type:UIKeyboardTypeNumberPad];
    
    
    [self.mlsTime initRightLabel:NSLocalizedString(@"▪︎ 可点外卖时段", nil)  delegate:self];
    
    [self.whetherAppointment  initLabel:NSLocalizedString(@"▪︎ 是否可预约次日外卖", nil) withHit:nil delegate:self];
    [self.whetherAppointment  initData: @"0"];
    [self.mlsSender initRightLabel:NSLocalizedString(@"▪︎ 送货人", nil)  delegate:self];
    self.lblHelp.text=NSLocalizedString(@"注：商品是否外卖可见，外卖商品的打包数量及打包盒价格，均要在商品中分别单独设置.", nil);
    self.lblHelp.textColor = [UIColor redColor];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.rdoIsSale.tag=TO_IS_SALE;
    self.lsOutFeeMode.tag=TO_OUTFEE_MODE;
    self.lsFee.tag=TO_OUTFEE;
    self.mlsSender.tag=TO_OUTFEE_SENDER;
    self.mlsTime.tag=TO_OUTFEE_TIME;
    self.txtArea.tag  = TO_OUTFEE_AREA;
    self.outStartAmount.tag  = TO_OUTSTART_FEE;
    self.whetherSupportCustomerAuto.tag  =  TO_OUTFEE_CUSTOMER_AUOTO;
}
#pragma remote
- (void)loadDatas
{

     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[[TDFKabawService  alloc] init ]  getTakeOutSettingSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull  data) {
        [self .progressHud  hideAnimated: YES];
        [self  parseCurrentData:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull  error) {
        [self.progressHud  hideAnimated: YES];
        [AlertBox  show:error.localizedDescription];
    }];

}

#pragma 数据层处理
- (void)clearDo
{
    [self.rdoIsSale initShortData:0];
    [self subVisibal];
    [self.lsOutFeeMode initData:NSLocalizedString(@"不收费", nil) withVal:@"3"];
    [self.txtNewArea initLabel:NSLocalizedString(@"▪︎ 外送范围", nil) withVal:NSLocalizedString(@"五公里以内", nil)];
    [self.txtArea initData:@"3" withVal:@"3"];
    [self.lsFee initData:@"0" withVal:@"0"];
    self.lsFee.lblName.text=NSLocalizedString(@"▪︎ 外送费", nil);
    [self modelVisibal];

//    [self.txtbefore  initData:@"60" ];
    [self.outStartAmount  initData:@"15" withVal:@"15"];
    [self.advanceAutoOrder   initData:@"60"];

    //    [self.txtbefore  initData:@"60" ];
    [self.txtMinute  initData:@"60" ];
    [self.advanceAutoOrder  initData:@"60"];
    [self.mlsSender initData:nil];
     self.lblHelp.hidden = YES;
    [self reloadFlesh];

}

- (void)fillModel
{
    [self.rdoIsSale initShortData:self.takeOutSet.isOut];
    NSMutableArray* feeModes=[ReserveRender listMode];
    NSString* modeStr=[NSString stringWithFormat:@"%d",self.takeOutSet.outFeeMode];
    [self.lsOutFeeMode initData:[GlobalRender obtainItem:feeModes itemId:modeStr ] withVal:modeStr];
    if(self.takeOutSet.outFeeMode == FEE_MODE_FIX)
    {
        NSString* feeStr=[FormatUtil formatDouble4:self.takeOutSet.outFee/100];
        [self.lsFee initData:feeStr withVal:feeStr];
    }
    
    if(self.takeOutSet.outFeeMode == FEE_MODE_RATIO){
        NSString* percent=[FormatUtil formatDouble4:self.takeOutSet.outFee];
        [self.lsFee initData:percent withVal:percent];
    }
    NSString* outFeeStr=[FormatUtil formatDouble4:self.takeOutSet.startPrice/100];
    [self.outStartAmount initData:outFeeStr withVal:outFeeStr];
    [self.advanceAutoOrder   initData:[NSString stringWithFormat:@"%d",self.takeOutSet.orderAheadOfTime]];
    [self.whetherSupportCustomerAuto  initShortData:self.takeOutSet.pickupFlag];
    [self.whetherAppointment  initShortData:self.takeOutSet.reserveTomorrowFlag];
    
    if (self.takeOutSet.cashSupVer2Flag) {
         [self.txtArea  initData:[NSString stringWithFormat:@"%ld",self.takeOutSet.maxRange/1000] withVal:[NSString stringWithFormat:@"%ld",self.takeOutSet.maxRange/1000]];
    }
    else{
          [self.txtNewArea initData:self.takeOutSet.outRange];
    }

//    NSString* beforeMin=[NSString stringWithFormat:@"%d",self.takeOutSet.orderAheadOfTime];
//    [self.txtbefore initData:beforeMin ];
    NSString* minuteStr=[NSString stringWithFormat:@"%d",self.takeOutSet.deliveryTime];
    [self.txtMinute initData:minuteStr];
    [self.mlsSender initData:self.senders];
    [self modelVisibal];
    [self subVisibal];
    [self reloadFlesh];
 
}

- (void)changeMlsStatus
{
    if (self.times.count == 0) {
        [self.mlsTime initData:nil];
        self.mlsTime.lblVal.text=[NSString stringWithFormat:NSLocalizedString(@"必填", nil)];
        self.mlsTime.lblVal.textColor = [UIColor redColor];
    }else
    {
        [self.mlsTime initData:self.times];
        self.mlsTime.lblVal.textColor = RGBA(0, 122, 255, 1);
    }
}

-(void)changeMisSender
{
    if (self.senders.count == 0) {
        [self.mlsSender initData:nil];
        self.mlsSender.lblVal.text=[NSString stringWithFormat:NSLocalizedString(@"必填", nil)];
        self.mlsSender.lblVal.textColor = [UIColor redColor];
    }else
    {
        [self.mlsSender initData:self.senders];
        self.mlsSender.lblVal.textColor = RGBA(0, 122, 255, 1);
    }
    
}
#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_TakeOutEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_TakeOutEditView_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeRefresh:) name:REMOTE_TAKEOUTTIME_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(senderRefresh:) name:REMOTE_SENDER_REFRESH object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]]) {
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
    }
}

//可预订时段时间刷新.
- (void)timeRefresh:(NSNotification*) notification
{
    self.times= (NSMutableArray*)notification.object;
    [self changeMlsStatus];
    [self reloadFlesh];
}

//不接受预订日期刷新.
- (void)senderRefresh:(NSNotification*) notification
{
    self.senders= (NSMutableArray*)notification.object;
    [self changeMisSender];
    [self reloadFlesh];
}


- (void)parseCurrentData:(id)data
{

    NSDictionary * sourceDic  =  data [@"data"];
    TDFTakeoutSettingsVo *settingVo = [TDFTakeoutSettingsVo  yy_modelWithDictionary:sourceDic];
    _settingVo = settingVo;
    self.takeOutSet = settingVo.takeOutSettings;
    if (self.takeOutSet.isOut== 0) {
        [self clearDo];
    }else{
        [self fillModel];
    }
    self.times = self.takeOutSet.takeOutTimeList;
    self.senders = self.takeOutSet.deliveryMenList;
    [self changeMlsStatus];
    [self changeMisSender];
    [self.titleBox editTitle:NO act:self.action];
    UIImage *img = [QRCodeGenerator qrImageForString:settingVo.takeoutShortUrl  imageSize:360];
    self.qrImg = img;
    self.setQRCodeImageView.image = img;
    [self reloadFlesh];
}


- (void)remoteFinsh:(RemoteResult*) result
{

     [self.progressHud  hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self loadDatas];
//    [self.titleBox editTitle:NO act:self.action];
}

#pragma test event
#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    if(obj.tag==TO_OUTFEE_MODE){
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[ReserveRender listMode]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[ReserveRender listMode][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }else if(obj.tag==TO_OUTFEE){
        NSString* fixModel=[NSString stringWithFormat:@"%d",FEE_MODE_FIX];
        NSString* ratioModel=[NSString stringWithFormat:@"%d",FEE_MODE_RATIO ];
        if ([fixModel isEqualToString:[self.lsOutFeeMode getStrVal]]) {
            [self.lsFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
            [self.lsFee.lblVal becomeFirstResponder];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.lsFee.lblVal performSelector:NSSelectorFromString(@"removeGesture") withObject:nil];
#pragma clang diagnostic pop
        }else if([ratioModel isEqualToString:[self.lsOutFeeMode getStrVal]]){
            int ratio=100;
            if ([NSString isNotBlank:[obj getStrVal]] && ![@"0" isEqualToString:[obj getStrVal]]) {
                ratio=[obj getStrVal].intValue;
            }
            [RatioPickerBox initData:ratio];
            [RatioPickerBox show:obj.lblName.text client:self event:obj.tag];
        }
    }
    else if (obj.tag  == TO_OUTFEE_AREA){
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[ReserveRender listArea]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[ReserveRender listArea][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }
    
    else if (obj.tag ==  TO_OUTSTART_FEE)
    {
        [self.outStartAmount setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
        [self.outStartAmount becomeFirstResponder];
    }
}

//多选List控件变换.
- (void)onMultiItemListClick:(EditMultiList *)obj
{
    if (obj.tag==TO_OUTFEE_TIME) {
        UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_takeOutTimeListViewControllerWithData:self.times];
        [self.rootController pushViewController:viewController animated:YES];
        return;
    }else if(obj.tag==TO_OUTFEE_SENDER){
        UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_senderListViewControllerWithData:self.senders];
        [self.rootController pushViewController:viewController animated:YES];
    }
    [self reloadFlesh];
}

//Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio *)obj
{
    if (obj.tag==TO_IS_SALE) {
        [self subVisibal];
    }
    [self reloadFlesh];;
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==TO_OUTFEE_MODE) {
        NameItemVO* vo=(NameItemVO *)selectObj;
        [self.lsOutFeeMode changeData:vo.itemName withVal:vo.itemId];
        //        [self.lsFee changeData:nil withVal:nil];
        [self modelVisibal];
    }else if (event==TO_OUTFEE) {
        NSString* result=(NSString *)selectObj;
        [self.lsFee changeData:result withVal:result];
    }
    else  if (event == TO_OUTFEE_AREA){
        NameItemVO* vo=(NameItemVO *)selectObj;
        [self.txtArea  changeData:vo.itemName withVal:vo.itemId];
        self.takeOutSet.maxRange  =  vo.itemName.integerValue *1000;
    }
    return YES;
}

- (void)clientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==TO_OUTFEE) {
        [self.lsFee changeData:val withVal:val];
    }
}

#pragma save-data
-(BOOL)isValid
{
    if (![self.rdoIsSale getVal]) {
        return YES;
    }
    if ([NSString isBlank:[self.lsOutFeeMode getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择外送费收费模式!", nil)];
        return NO;
    }
    int mode=[self.lsOutFeeMode getStrVal].intValue;
    if (mode==FEE_MODE_RATIO || mode==FEE_MODE_FIX) {
        if ([NSString isBlank:[self.lsFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"外送费不能为空!", nil)];
            return NO;
        }
        if (![NSString isFloat:[self.lsFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"外送费不是数字!", nil)];
            return NO;
        }
    }
    if (self.takeOutSet.cashSupVer2Flag) {
        if ([NSString isBlank:[self.txtArea getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"外送范围不能为空!", nil)];
            return NO;
        }
    }else{
    if ([NSString isBlank:[self.txtNewArea getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"外送范围不能为空!", nil)];
        return NO;
     }
    }
    //    if ([NSString isBlank:[self.txtbefore getStrVal]]) {
    //        [AlertBox show:NSLocalizedString(@"提前多长时间自动下单(分)不能为空!", nil)];
    //        return NO;
    //    }
    if ([NSString isBlank:[self.txtMinute getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"预计接单多久后送达(分)不能为空!", nil)];
        return NO;
    }
    if([NSString  isBlank:[self.advanceAutoOrder  getStrVal]]){
        [AlertBox show:NSLocalizedString(@"接单后提前多久下到厨房(分)不能为空!", nil)];
        return NO;
      }
    if (![NSString isPositiveNum:[self.txtMinute getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"提前多长时间自动下单(分)不能是小于0的数字!", nil)];
        return NO;
    }
    if ([self.mlsTime.currentItems count] == 0) {
        [AlertBox show:NSLocalizedString(@"请至少添加一个可点外卖时段!", nil)];
        return NO;
    }
    if ([self.mlsSender.currentItems count] == 0) {
        [AlertBox show:NSLocalizedString(@"请至少添加一个送货人!", nil)];
        return NO;
    }

    if(self.takeOutSet.cashSupVer2Flag){
        if ([NSString  isBlank: [self.outStartAmount  getStrVal] ]){
            [AlertBox show:NSLocalizedString(@"外卖订单起送金额不能为空!", nil)];
            return   NO;
        }
    }


    return YES;
}


-(TDFTakeOutSettings *) transMode
{
    TDFTakeOutSettings* tempUpdate=[TDFTakeOutSettings new];
    if (self.takeOutSet!=nil) {
        tempUpdate=self.takeOutSet;
    }
    tempUpdate.isOut=[self.rdoIsSale getVal]?1:0;
    if ([self.rdoIsSale getVal]) {
        tempUpdate.outFeeMode=[self.lsOutFeeMode getStrVal].intValue;
        if (tempUpdate.outFeeMode == FEE_MODE_NO) {
            tempUpdate.outFee=0;
        }if(tempUpdate.outFeeMode == FEE_MODE_FIX){
            tempUpdate.outFee=[self.lsFee getStrVal].doubleValue*100;
        }else{
            tempUpdate.outFee=[self.lsFee getStrVal].doubleValue;
        }
        tempUpdate.outRange=[self.txtArea getStrVal];

        //        tempUpdate.orderAheadOfTime=[self.txtbefore getStrVal].intValue;

        tempUpdate.deliveryTime=[self.txtMinute getStrVal].intValue;
        tempUpdate.cashSupVer2Flag   =   self.takeOutSet.cashSupVer2Flag;
        if (self.takeOutSet.cashSupVer2Flag) {
             tempUpdate.maxRange  =  [self.txtArea  getStrVal].integerValue *1000;
        }else{
            tempUpdate.outRange  =  [self.txtNewArea getStrVal];
        }
      
        tempUpdate.pickupFlag   = [self.whetherSupportCustomerAuto  getVal] ;
        tempUpdate.reserveTomorrowFlag   = [self.whetherAppointment getVal];
//        NSString *startStr  = [FormatUtil  formatDouble3:[self.outStartAmount getStrVal].doubleValue*100];
        tempUpdate.startPrice   = [self.outStartAmount getStrVal].doubleValue *100;
        tempUpdate.mapAddress   = self.takeOutSet.mapAddress;
        tempUpdate.orderAheadOfTime  =  [self.advanceAutoOrder getStrVal].intValue;
    }
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    TDFTakeOutSettings* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@外卖设置", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    [service saveTakeOut:objTemp Target:self Callback:@selector(remoteFinsh:)];
}

-(void) subVisibal
{
    BOOL isOpen=[self.rdoIsSale getVal];
    [self.lsOutFeeMode visibal:isOpen];
    [self.lsFee visibal:isOpen];
    [self.outStartAmount  visibal:isOpen];
    [self.advanceAutoOrder  visibal:isOpen];
    [self.whetherAppointment  visibal:isOpen];
    [self.whetherSupportCustomerAuto  visibal:isOpen];

    if (isOpen) {
        int mode=[self.lsOutFeeMode getStrVal].intValue;
        [self.lsFee visibal:(mode!=FEE_MODE_NO)];
     [self.txtNewArea  visibal:isOpen];
    [self.txtArea visibal:isOpen];
//    [self.txtbefore visibal:isOpen];
    [self.txtMinute visibal:isOpen];
    [self.mlsTime visibal:isOpen];
    [self.mlsSender visibal:isOpen];
    [self.whetherSupportCustomerAuto  visibal:isOpen];
    self.summaryInfoView.hidden = NO;
    self.sendInfoView.hidden = NO;
    self.lblHelp.hidden = NO;
    }else{
        self.txtArea.hidden = YES;
        self.txtNewArea.hidden = YES;
//        self.txtbefore.hidden = YES;
        self.txtMinute.hidden = YES;
        self.mlsTime.hidden = YES;
        self.mlsSender.hidden = YES;
        self.summaryInfoView.hidden = YES;
        self.sendInfoView.hidden = YES;
        self.lblHelp.hidden = YES;
    }
}


#pragma mark  version control
-(void)versionControlIteam:(BOOL)isShow
{
     BOOL isOpen=[self.rdoIsSale getVal];
    if (isOpen) {
        [self.whetherSupportCustomerAuto visibal:  isShow];
        [self.outStartAmount  visibal:isShow];
        [self.advanceAutoOrder  visibal:isShow];
        [self.whetherAppointment  visibal: isShow];
    }
    
}

-(void) modelVisibal
{
    int mode=[self.lsOutFeeMode getStrVal].intValue;
    [self.lsFee visibal:(mode!=FEE_MODE_NO)];
    NSString* unit=[NSString stringWithFormat:NSLocalizedString(@"▪︎ 外送费%@", nil),[ReserveRender obtainReserveFeeUnit:mode]];
    self.lsFee.lblName.text=unit;

   [self reloadFlesh];;

}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"outsale"];
}

//分享给微信好友
- (void)shareToWeChatFriendBtnClick:(UIButton *)sender
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"takeout" forKey:@"biz"];
    [param setObject:@"10" forKey:@"type"];
    [param  setObject:@"ios" forKey:@"platform"];
    [param setObject:@"shareClick1" forKey:@"eventName"];
    [[[TDFSettingService alloc]init] sendHistoryWithParam:param sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        currentBtnIndex = WEIXIN_FRIEND;
        //        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.settingVo.takeoutShortUrl;
        //        [UMSocialData defaultData].extConfig.wechatSessionData.title = [[Platform Instance]getkey:SHOP_NAME];
        //        self.messageObject.title = [[Platform Instance]getkey:SHOP_NAME];
        [self loadShareImage];
    } else {
        [AlertBox show:NSLocalizedString(@"您还未安装微信！！", nil)];
        return;
    }
    
    
}


- (void)shareToWeChatFriendBodyWithText:(NSString *)text Image:(UIImage *)img
{
    
    self.messageObject.text = text;
    UMShareWebpageObject *obj = [UMShareWebpageObject shareObjectWithTitle:[[Platform Instance]getkey:SHOP_NAME]
                                                                     descr:text
                                                                 thumImage:img];
    obj.webpageUrl = self.settingVo.takeoutShortUrl;
    self.messageObject.shareObject = obj;
    [self shareWithPlatformType:UMSocialPlatformType_WechatSession];
    //    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMANALYTICS_KEY
    //                                      shareText:text shareImage:img shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,nil]
    //                                       delegate:nil];
}

- (void)shareToWeChatMomentBtnClick:(UIButton *)sender
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"takeout" forKey:@"biz"];
    [param setObject:@"10" forKey:@"type"];
    [param  setObject:@"ios" forKey:@"platform"];
    [param setObject:@"shareClick2" forKey:@"eventName"];
    [[[TDFSettingService alloc]init] sendHistoryWithParam:param sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        currentBtnIndex = WEIXIN_MOMENT;
        
        //        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.settingVo.takeoutShortUrl;
        //        [UMSocialWechatHandler setWXAppId:WEIXIN_AppId appSecret: WEIXIN_AppSecret url: self.settingVo.takeoutShortUrl];
        [self loadShareImage];
    } else {
        [AlertBox show:NSLocalizedString(@"您还未安装微信！！", nil)];
        return;
    }
}



- (void)shareToWeChatMomentBodyWithImage:(UIImage *)img
{
    //    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMANALYTICS_KEY
    //                                      shareText:[NSString stringWithFormat:NSLocalizedString(@"%@,把美食与爱随身携带!", nil),[[Platform Instance]getkey:SHOP_NAME]] shareImage:self.settingVo.takeoutShortUrl shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,nil]
    //                                       delegate:nil];
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"%@,把美食与爱随身携带!", nil),[[Platform Instance]getkey:SHOP_NAME]];
    self.messageObject.text = text;
    UMShareWebpageObject *obj = [UMShareWebpageObject shareObjectWithTitle:text
                                                                     descr:@""
                                                                 thumImage:img];
    obj.webpageUrl = self.settingVo.takeoutShortUrl;
    self.messageObject.shareObject = obj;
    [self shareWithPlatformType:UMSocialPlatformType_WechatTimeLine];
}



- (void)shareWithPlatformType:(UMSocialPlatformType)platformType {
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:self.messageObject currentViewController:self completion:^(id data, NSError *error) {
        self.messageObject = nil;
        if (error) {
            [AlertBox show:NSLocalizedString(@"分享失败", nil)];
        }else{
            [AlertBox show:NSLocalizedString(@"分享成功", nil)];
        }
    }];
}

//- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
////    if (response.responseCode == UMSResponseCodeSuccess) {
////        ////        return;
////    } else if(response.responseCode != UMSResponseCodeCancel) {
////        if (response.responseCode == UMSResponseCodeSuccess) {
////
////            return;
////        }
////    }
//}

- (void)loadShareImage
{
    [[TDFKabawService new] findShopImageNotificationSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self remoteLoadShareImageData:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
    // [service findShopImageNotificationTarget:self callback:@selector(loadShareImageFinish:)];
}

- (void)loadShareImageFinish:(RemoteResult*) result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadShareImageData:result.content];
}

- (void)remoteLoadShareImageData:(id) data
{
    if (currentBtnIndex==WEIXIN_FRIEND) {
        // NSDictionary *map = [JsonHelper transMap:responseStr];//
        NSDictionary *map =data;
        if ([ObjectUtil isEmpty:[map objectForKey:@"shopImg"]]&&[ObjectUtil isEmpty:[map objectForKey:@"notification"]]) {
            [self shareToWeChatFriendBodyWithText:NSLocalizedString(@"查看店铺优惠，领取超大红包，预先点菜，快来体验吧", nil) Image:[UIImage imageNamed:@"ico_weixin_share"]];
        } else if ([ObjectUtil isEmpty:[map objectForKey:@"shopImg"]] && [ObjectUtil isNotEmpty:[map objectForKey:@"notification"]]) {
            [self shareToWeChatFriendBodyWithText:[[map objectForKey:@"notification"] objectForKey:@"name"] Image:[UIImage imageNamed:@"ico_weixin_share"]];
        } else if ([ObjectUtil isEmpty:[map objectForKey:@"notification"]] && [ObjectUtil isNotEmpty:[map objectForKey:@"shopImg"]]){
            NSString *filePath = [[map objectForKey:@"shopImg"] objectForKey:@"filePath"];
            NSURL *imageUrl = [NSURL URLWithString:filePath];
            NSData *shareData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *shareImag = [UIImage imageWithData:shareData];
            [self shareToWeChatFriendBodyWithText:NSLocalizedString(@"查看店铺优惠，领取超大红包，预先点菜，快来体验吧", nil) Image:shareImag];
        } else {
            [self shareToWeChatFriendBodyWithText:[[map objectForKey:@"notification"] objectForKey:@"name"] Image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[map objectForKey:@"shopImg"] objectForKey:@"filePath"]]]]];
        }
    } else if (currentBtnIndex==WEIXIN_MOMENT) {
        //        NSDictionary *map = [JsonHelper transMap:responseStr];
        NSDictionary *map =data;
        if ([ObjectUtil isEmpty:[map objectForKey:@"shopImg"]]) {
            [self shareToWeChatMomentBodyWithImage:[UIImage imageNamed:@"ico_weixin_share"]];
        } else {
            NSString *filePath = [[map objectForKey:@"shopImg"] objectForKey:@"filePath"];
            NSURL *imageUrl = [NSURL URLWithString:filePath];
            NSData *shareData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *shareImag = [UIImage imageWithData:shareData];
            [self shareToWeChatMomentBodyWithImage:shareImag];
        }
    }
    [self reloadFlesh];
}

//下载二维码
- (void)downLoadQRCodeBtnClick:(UIButton *)sender
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"takeout" forKey:@"biz"];
    [param setObject:@"10" forKey:@"type"];
    [param  setObject:@"ios" forKey:@"platform"];
    [param setObject:@"shareClick3" forKey:@"eventName"];
    [[[TDFSettingService alloc]init] sendHistoryWithParam:param sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    UIImageWriteToSavedPhotosAlbum(self.qrImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}



- (void)loadQRFinish:(RemoteResult*)result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

- (void)remoteLoadData:(NSString *) responseStr
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Platform Instance].serverPath, self.settingVo.takeoutShortUrl ]];
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *img=[UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [self reloadFlesh];
}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if (error != NULL) {
        msg = NSLocalizedString(@"保存图片失败", nil) ;
    } else {
        msg = NSLocalizedString(@"保存图片成功", nil) ;
    }
    [AlertBox show:msg];
}

//复制链接
- (void)pasteLinkBtnClick:(UIButton *)sender
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"takeout" forKey:@"biz"];
    [param setObject:@"10" forKey:@"type"];
    [param  setObject:@"ios" forKey:@"platform"];
    [param setObject:@"shareClick4" forKey:@"eventName"];
    [[[TDFSettingService alloc]init] sendHistoryWithParam:param sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.settingVo.takeoutShortUrl;
    [AlertBox show:NSLocalizedString(@"二维码链接已经复制到剪贴版了哦！", nil)];
    
}



#pragma mark--delegate
- (void)reloadFlesh
{
    [self versionControlIteam: self.takeOutSet.cashSupVer2Flag];
//    if (self.takeOutSet.cashSupVer2Flag) {
//        [self addControl];
//    }
    [self wetherHideOldeList];
    [self addControl];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma Mark initControl

- (void)wetherHideOldeList
{
     BOOL isOpen=[self.rdoIsSale getVal];
     if (isOpen) {
    if (!self.takeOutSet.cashSupVer2Flag) {
        [self.txtArea visibal: NO];
        [self.txtNewArea  visibal: YES];
    }
    else{
        [self.txtNewArea  visibal: NO];
        [self.txtArea  visibal: YES];
    }
  }
}

-  (void) addControl
{
     if (self.contol) {
        [self.contol removeFromSuperview];
     }
    self.contol.backgroundColor  = [UIColor clearColor];
    self.contol.frame   =  self.txtArea.lblDetail.bounds;
    [self.contol  setOrigin:self.txtArea.lblDetail.origin];
    [self.txtArea addSubview:self.contol];
    [self.contol addTarget:self action:@selector(bnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (UIControl *)contol
{
    if (!_contol) {
        _contol  = [[UIControl alloc] init ];
    }
    return _contol;
}

- (void)bnClick
{
    TDFMapViewController  *mapView  = [[TDFMapViewController  alloc]  init];
    [mapView  configIteam:self.takeOutSet];
    mapView.fileBlock  =  ^(id  data){
        
    };
    [self.navigationController  pushViewController:mapView animated:YES];
}

- (UMSocialMessageObject *)messageObject {
    
    if (!_messageObject) {
        
        _messageObject = [UMSocialMessageObject messageObject];
    }
    
    return _messageObject;

}
@end
