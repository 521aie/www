//
//  SeatEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "ZMTable.h"
#import "AlertBox.h"
#import "Platform.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "ItemTitle.h"
#import "DateUtils.h"
#import "HelpDialog.h"
#import "SystemUtil.h"
#import "CouponShop.h"
#import "NumberUtil.h"
#import "CouponRule.h"
#import "MessageBox.h"
#import "ZmTableCell.h"
#import "RemoteEvent.h"
#import "ColorHelper.h"
#import "CalendarBox.h"
#import "SystemEvent.h"
#import "UIView+Sizes.h"
#import "MemoInputBox.h"
#import "EditItemMemo.h"
#import "EditItemView.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "MarketModule.h"
#import "RemoteResult.h"
#import "EditItemRadio.h"
#import "RestConstants.h"
#import "EventConstants.h"
#import "ServiceFactory.h"
#import "EnvelopeEditView.h"
#import "NSString+Estimate.h"
#import "EnvelopeModuleEvent.h"
#import "UIViewController+Picker.h"

@interface EnvelopeEditView ()<EditItemListDelegate>

@end

@implementation EnvelopeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].envelopeService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainView];
    [self initNotifaction];
    [self initNavigate];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"添加优惠券", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        [parent showView:ENVELOPE_LIST_VIEW];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    } else {
        [self save];
    }
}

- (void)initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.lsPublishFee initLabel:NSLocalizedString(@"优惠券面额", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsPublishNum initLabel:NSLocalizedString(@"发行数量", nil) withHit:nil isrequest:YES delegate:self];
    [self.lblShopName initLabel:NSLocalizedString(@"适用店铺", nil) withHit:nil];
    [self.lsConsumeFee initLabel:NSLocalizedString(@"消费满多少元时方可使用", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsPeriod initLabel:NSLocalizedString(@"有效期至", nil) withHit:nil isrequest:YES delegate:self];
    self.upgradeTitle.lblName.text=NSLocalizedString(@"优惠券增值", nil);
    [self.rdoExpand initLabel:NSLocalizedString(@"用户分享优惠券后可增值", nil) withHit:NSLocalizedString(@"注：用户领取优惠券后，可分享到微信朋友圈，并邀请好友点击支持。收集到足够数量点赞支持后，优惠券数额可增值到指定金额。", nil) delegate:nil];
    [self.lsExpandNum initLabel:NSLocalizedString(@"点击几次后增值", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsExpandFee initLabel:NSLocalizedString(@"增值后面额", nil) withHit:nil isrequest:YES delegate:self];
    
    self.lsPublishFee.tag = ENVELOPE_PUBLISH_FEE;
    self.lsPublishNum.tag = ENVELOPE_PUBLISH_NUM;
    self.lsConsumeFee.tag = ENVELOPE_CONSUME_FEE;
    self.lsPeriod.tag = ENVELOPE_PERIOD;
    self.rdoExpand.tag = ENVELOPE_EXPAND;
    self.lsExpandNum.tag = ENVELOPE_EXPAND_NUM;
    self.lsExpandFee.tag = ENVELOPE_EXPAND_FEE;
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    
    [self configKeyboard];
}

- (void)configKeyboard {

    [self.lsPublishFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
    [self.lsPublishNum setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
    [self.lsConsumeFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
    [self.lsExpandNum setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
    [self.lsExpandFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
    
    self.lsPublishFee.tdf_delegate = self;
    self.lsPublishNum.tdf_delegate = self;
    self.lsConsumeFee.tdf_delegate = self;
    self.lsExpandNum.tdf_delegate = self;
    self.lsExpandFee.tdf_delegate = self;
}

- (void)editItemListDidFinishEditing:(EditItemList *)obj {

    if (obj == self.lsPublishFee) {
        
        [self refreshEnvelopeInfo];
    } else if (obj == self.lsPublishNum) {
        
        [self refreshTotalInfo];
    } else if (obj == self.lsConsumeFee) {
        
        [self.lsConsumeFee changeData:obj.lblVal.text withVal:obj.lblVal.text];
    } else if (obj == self.lsExpandNum) {
        
        [self refreshTotalInfo];
    } else if (obj == self.lsExpandFee) {
        
        [self refreshTotalInfo];
    }
}

- (void)loadDataAction:(int)action isContinue:(BOOL)isContinue
{
    self.action = action;
    [self clearDo];
    [self initDefault];

    [self.titleBox editTitle:NO act:self.action];
    [self.scrollView setContentOffset:CGPointMake(0,0)];
}

#pragma 数据层处理
- (void)clearDo
{
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    [self.lblShopName initData:shopName withVal:shopName];
    
    self.lblShop.text = shopName;
    self.lblPrice.text = @"";
    self.lblPeriod.text = @"";
    
    [self.lsPublishFee initData:@"" withVal:@""];
    [self.lsPublishNum initData:@"" withVal:@""];
    
    [self.lsConsumeFee initData:@"" withVal:@""];
    [self.lsPeriod initData:@"" withVal:@""];
    
    [self.rdoExpand initShortData:BASE_FALSE];
    [self.lsExpandNum initData:@"" withVal:@""];
    [self.lsExpandFee initData:@"" withVal:@""];
    
    [self.rdoExpand visibal:NO];
    [self.lsExpandNum visibal:NO];
    [self.lsExpandFee visibal:NO];
    self.lblTotalInfo.hidden = YES;
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)initDefault
{
    [self.lsPublishFee changeData:@"10" withVal:@"10"];
    [self.lsConsumeFee changeData:@"100" withVal:@"100"];
    [self.lsPublishNum changeData:@"1000" withVal:@"1000"];
    [self refreshEnvelopeInfo];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)refreshTotalInfo
{
    self.lblTotalInfo.text = @"";
    if ([NSString isBlank:[self.lsPublishNum getStrVal]]) {
        return;
    }
    
    if ([NSString isBlank:[self.lsExpandNum getStrVal]]) {
        return;
    }
    
    if ([NSString isBlank:[self.lsExpandFee getStrVal]]) {
        return;
    }
    
    NSInteger publishNum = [self.lsPublishNum getStrVal].integerValue;
    NSInteger expandNum = [self.lsExpandNum getStrVal].integerValue;
    NSInteger expandFee = [self.lsExpandFee getStrVal].integerValue;
    
    NSString *totalInfo = [NSString stringWithFormat:NSLocalizedString(@"参与活动的最大人数:%ld人，所有优惠券都增值后的总金额:%ld元", nil), publishNum*expandNum+publishNum, publishNum*expandFee];
    
    self.lblTotalInfo.text = totalInfo;
}

- (void)refreshEnvelopeInfo
{
    if ([NSString isNotBlank:[self.lsPublishFee getStrVal]]) {
        self.lblPrice.text = [self.lsPublishFee getStrVal];
        [self.lblPrice sizeToFit];
        CGRect unitFrame = self.lblUnit.frame;
        unitFrame.origin.x = self.lblPrice.frame.origin.x + self.lblPrice.frame.size.width;
        self.lblUnit.frame = unitFrame;
        self.lblPrice.hidden = NO;
        self.lblUnit.hidden = NO;
    } else {
        self.lblPrice.hidden = YES;
        self.lblUnit.hidden = YES;
    }
    
    if ([NSString isNotBlank:[self.lsPeriod getStrVal]]) {
        self.lblPeriod.text = [NSString stringWithFormat:NSLocalizedString(@"有效期至：%@", nil), [self.lsPeriod getDataLabel]];
    } else {
        self.lblPeriod.text = @"";
    }
    self.lblTotalInfo.hidden = YES;
    [self.lblTotalInfo setHeight:0];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_EnvelopeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_EnvelopeEditView_Change object:nil];

}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification
{
   [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

#pragma 做好界面变动的支持.
- (void)remoteFinsih:(RemoteResult*) result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [parent.envelopeListView loadDatas];
    [parent showView:ENVELOPE_LIST_VIEW];
}

#pragma save-data
- (BOOL)isValid
{
    if ([NSString isBlank:[self.lsPublishFee getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"优惠券面额不能为空!", nil)];
        return NO;
    }
    
    if ([NumberUtil isZero:[self.lsPublishFee getStrVal].doubleValue]) {
        [AlertBox show:NSLocalizedString(@"优惠券面额不能为零!", nil)];
        return NO;
    }
    
    if ([self.lsPublishFee getStrVal].doubleValue>9999) {
        [AlertBox show:NSLocalizedString(@"优惠券面额不能超过9999元!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsPublishNum getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"发行数量不能为空!", nil)];
        return NO;
    }
    
    if ([NumberUtil isZero:[self.lsPublishNum getStrVal].doubleValue]) {
        [AlertBox show:NSLocalizedString(@"发行数量不能为零!", nil)];
        return NO;
    }
    
    if ([self.lsPublishNum getStrVal].doubleValue>1000000.0) {
        [AlertBox show:NSLocalizedString(@"发行数量不能超过1000000哦!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsConsumeFee getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"发行满多少元方可使用不能为空!", nil)];
        return NO;
    }
    
    if ([self.lsConsumeFee getStrVal].doubleValue>9999) {
        [AlertBox show:NSLocalizedString(@"发行满多少元方可使用不能超过9999元!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsPeriod getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"有效期不能为空!", nil)];
        return NO;
    }
    
    NSDate *period = [DateUtils DateWithString:[self.lsPeriod getStrVal] type:TDFFormatTimeTypeAllTimeString];
    if (period.timeIntervalSinceNow<0) {
        [AlertBox show:NSLocalizedString(@"有效期不能早于当前时间!", nil)];
        return NO;
    }
    
//    if ([self.rdoExpand getVal]) {
//        if ([NSString isBlank:[self.lsExpandNum getStrVal]]) {
//            [AlertBox show:NSLocalizedString(@"分享次数不能为空!", nil)];
//            return NO;
//        }
//        
//        if ([NSString isBlank:[self.lsExpandFee getStrVal]]) {
//            [AlertBox show:NSLocalizedString(@"增值后面额不能为空!", nil)];
//            return NO;
//        }
//        
//        if ([NumberUtil isZero:[self.lsExpandNum getStrVal].doubleValue]) {
//            [AlertBox show:NSLocalizedString(@"分享次数不能为零!", nil)];
//            return NO;
//        }
    
//        double expandNum = [self.lsExpandFee getStrVal].doubleValue;
//        double publishNum = [self.lsPublishFee getStrVal].doubleValue;
//        
//        if (publishNum>expandNum) {
//            [AlertBox show:NSLocalizedString(@"增值后面额必须大于优惠券面额!", nil)];
//            return NO;
//        }
//        
//        if (expandNum>9999) {
//            [AlertBox show:NSLocalizedString(@"分享次数不能超过9999!", nil)];
//            return NO;
//        }
//        
//        if (publishNum>9999) {
//            [AlertBox show:NSLocalizedString(@"增值后面额不能超过9999!", nil)];
//            return NO;
//        }
//    }
    
    return YES;
}

- (Coupon *)transMode
{
    NSString *entityId = [[Platform Instance]getkey:ENTITY_ID];
    NSString *shopName = [[Platform Instance]getkey:SHOP_NAME];
    NSString *shopId = [[Platform Instance]getkey:SHOP_ID];
    
    Coupon* obj=[Coupon new];
    
    obj.entityId = entityId;
    obj.shopId = shopId;
    obj.type = TYPE_ENVELOPE;
    obj.name = [NSString stringWithFormat:NSLocalizedString(@"%@元优惠券", nil), [self.lsPublishFee getStrVal]];
    obj.price = [[self.lsPublishFee getStrVal] doubleValue];
    obj.totalQuantity = [[self.lsPublishNum getStrVal] intValue];
    obj.consumeMoney = [[self.lsConsumeFee getStrVal] doubleValue];
    NSString *startDateStr = [DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeYearMonthDay];
    NSString *periodStr = [self.lsPeriod getStrVal];
    NSDate *startDate = [DateUtils DateWithString:startDateStr type:TDFFormatTimeTypeYearMonthDayString];
    NSDate *endDate = [DateUtils DateWithString:periodStr type:TDFFormatTimeTypeAllTimeString];
    obj.startTime = [startDate timeIntervalSince1970];
    obj.endTime = [endDate timeIntervalSince1970];
    obj.memo = NSLocalizedString(@"无", nil);
    
    
    obj.shopList = [[NSMutableArray alloc]init];
    CouponShop *couponShop = [CouponShop new];
    couponShop.shopName = shopName;
    couponShop.entityId = entityId;
    couponShop.shopId = shopId;
    [obj.shopList addObject:[couponShop dictionaryData]];
    
    obj.ruleList = [[NSMutableArray alloc]init];
    if ([self.rdoExpand getVal]) {
        CouponRule *couponRule = [CouponRule new];
        obj.enableRule = 1;
        couponRule.type = TYPE_RULE_ENVELOPE;
        couponRule.rule = [self.lsExpandNum getStrVal];
        couponRule.value = [self.lsExpandFee getStrVal];
        couponRule.quantity = [self.lsExpandFee getStrVal].intValue;
        [obj.ruleList addObject:[couponRule dictionaryData]];
    } else {
        obj.enableRule = 0;
    }
    
    return obj;
}

- (void)save
{
    if ([self isValid]) {
        coupon = [self transMode];
         NSString *publishTip = [NSString stringWithFormat:NSLocalizedString(@"确定要发布红包吗？红包面额:%0.0f元，发行数量:%ld，有效期至：%@", nil), coupon.price, (long)coupon.totalQuantity, [DateUtils formatTimeWithTimestamp:coupon.endTime * 1000.0f type:TDFFormatTimeTypeChineseWithWeek]];
        [MessageBox show:publishTip client:self];
    }
}

- (void)onItemListClick:(EditItemList *)obj
{
    [SystemUtil hideKeyboard];
    if (obj == self.lsPeriod) {

        __typeof(self) __weak wself = self;
        [self showDatePickerWithTitle:NSLocalizedString(@"有效期至", nil) mode:(UIDatePickerModeDate) editItem:obj mininumDate:nil maxinumDate:nil completionBlock:^(NSDate *date) {
            
            NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
            NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
            [obj changeData:dateStr withVal:datsFullStr];
            [wself refreshEnvelopeInfo];
        }];
    }
}

- (void)onItemRadioClick:(EditItemRadio*)obj
{
    if (obj.tag==ENVELOPE_EXPAND) {
        [self.lsExpandFee visibal:[obj getVal]];
        [self.lsExpandNum visibal:[obj getVal]];
        self.lblTotalInfo.hidden = ![obj getVal];
        [self.lblTotalInfo setHeight:([obj getVal]?40:0)];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)clientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType == ENVELOPE_PUBLISH_FEE) {
        [self.lsPublishFee changeData:val withVal:val];
        [self refreshEnvelopeInfo];
    }
//        else if (eventType == ENVELOPE_PUBLISH_NUM) {
//        [self.lsPublishNum changeData:val withVal:val];
//        [self refreshTotalInfo];
//    } else if (eventType == ENVELOPE_EXPAND_FEE) {
//        [self.lsExpandFee changeData:val withVal:val];
//        [self refreshTotalInfo];
//    } else if (eventType == ENVELOPE_EXPAND_NUM) {
//        [self.lsExpandNum changeData:val withVal:val];
//        [self refreshTotalInfo];
//    }
        else if (eventType == ENVELOPE_CONSUME_FEE) {
        [self.lsConsumeFee changeData:val withVal:val];
    }
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
    if (event == ENVELOPE_PERIOD) {
        [self.lsPeriod changeData:dateStr withVal:datsFullStr];
        [self refreshEnvelopeInfo];
    }
    return YES;
}

- (void)confirm
{
    [UIHelper showHUD:NSLocalizedString(@"正在发布", nil) andView:self.view andHUD:hud];
    [service saveEnvelopeData:coupon target:self callback:@selector(remoteFinsih:)];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"coupon"];
}

@end
