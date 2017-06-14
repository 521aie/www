//
//  MarketModule.m
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ActionConstants.h"
#import "MarketModule.h"
#import "MainModule.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "SystemUtil.h"
#import "SmsReChargeView.h"
#import "SmsListView.h"
#import "SmsService.h"
#import "XHAnimalUtil.h"
#import "SmsEditView.h"
#import "NavigateTitle2.h"
#import "SecondMenuView.h"
#import "EventConstants.h"
#import "SmsReciverListView.h"
#import "SmsOrderConfirmView.h"
#import "SecondMenuView.h"
#import "BaseSetingView.h"
#import "NavigateTitle2.h"
#import "KabawModule.h"
@implementation MarketModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)backMenu
{
    [mainModule backMenuBySelf:self];
}

- (void)hideView
{
    for (UIView* view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

-(void)backToPreviousView
{
    
//    mainModule.marketModule.view.hidden = YES;
//    mainModule.memberModule.view.hidden = NO;
//    if (mainModule.memberModule.memberSwitchView)
//    {
//    [mainModule.memberModule.memberSwitchView loadSMSDatas];
//    }
//    if (mainModule.memberModule.memberPublishView)
//    {
//        [mainModule.memberModule.memberPublishView loadSMSDatas];        
//    }
    
}

-(void)backToMemberViewView
{
    UIMenuAction *action = [UIMenuAction new];
    action.code = PAD_MEMBER;
    [mainModule onMenuSelectHandle:action];
//    [mainModule.memberModule showView:MEMBER_VIEW];
     [XHAnimalUtil animal:mainModule type:kCATransitionPush direct:kCATransitionFromLeft];
}

-(void)backLastView:(NSString *)modlue viewTag:(int)viewTag{
   
    UIMenuAction *action = [UIMenuAction new];
    action.code = modlue;
    
    if ([action.code isEqualToString:PAD_KABAW]) {
        [mainModule onMenuSelectHandle:action];
        [mainModule.kabawModule showView:viewTag];
        if (self.envelopeListView.isClick) {
//            [mainModule.kabawModule.baseSetingView backData:self.envelopeListView.coupon];
        }
       
    }
  [XHAnimalUtil animal:mainModule type:kCATransitionPush direct:kCATransitionFromLeft];
}

- (void)backToMain
{
    [mainModule backMenuBySelf:self];
}

-(void)backNavigateMenuView
{
    [mainModule backMenuBySelf:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}

- (void)showView:(int)viewTag
{
    [self hideView];
    if (viewTag==SMS_LIST_VIEW) {
        [self loadSmsListview];
    } else if (viewTag==SMS_EDIT_VIEW) {
        [self loadSmsEditView];
    } else if (viewTag==SMS_RECHARGE_VIEW) {
        [self loadSmsReChargeView];
    } else if (viewTag==SMS_ORDER_CONFIRM_VIEW) {
        [self loadSmsOrderConfirmView];
    } else if (viewTag==SMS_RECIEVER_LIST_VIEW) {
        [self loadSmsRecieverListView];
    } else if (viewTag==MENUTIME_LIST_VIEW) {
        [self loadMenuTimeListView];
    } else if (viewTag==MULTI_CHECK_VIEW) {
        [self loadMultiCheckView];
    } else if (viewTag==MENUTIME_EDIT_VIEW) {
        [self loadMenuTimeEditView];
    } else if (viewTag==MENUTIMEPRICE_EDIT_VIEW) {
        [self loadMenuTimePriceEditView];
    } else if (viewTag==MENUTIME_SELECT_MENU) {
        [self loadSelectMenuListView];
    } else if (viewTag==MENUTIME_SELECT_MUTILI_LIST_VIEW) {
        [self loadSelectMultiMenuListView];
    } else if (viewTag==ENVELOPE_LIST_VIEW) {
        [self loadEnvelopeListView];
    } else if (viewTag==ENVELOPE_EDIT_VIEW) {
        [self loadEnvelopeEditView];
    } else if (viewTag==ENVELOPE_DETAIL_VIEW) {
        [self loadEnvelopeDetailView];
    } else if (viewTag==LIFE_INFO_LIST_VIEW) {
        [self loadLifeInfoListView];
    } else if (viewTag==LIFE_INFO_EDIT_VIEW) {
        [self loadLifeInfoEditView];
    } else if (viewTag==SMS_TEMPLATE_VIEW){
        [self loadSmsTemplateView];
    }
}

- (void)showActionCode:(NSString *)actCode
{
    if ([actCode isEqualToString:PAD_SMS_MARKET]) {
        [self showView:SMS_LIST_VIEW];
        [self.smsListView loadDatas];
    } else if ([actCode isEqualToString:PAD_MENU_TIME]) {
//        [self showView:MENUTIME_LIST_VIEW];
//        [self.menuTimeListView loadDatas];
    } else if ([actCode isEqualToString:PAD_RED_PACKETS]) {
        [self showView:ENVELOPE_LIST_VIEW];
        [self.envelopeListView loadDatas];
    } else if ([actCode isEqualToString:PAD_ISSUE_INFO]) {
        [self showView:LIFE_INFO_LIST_VIEW];
        [self.lifeInfoListView loadDatas];
    }
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
}

//会员生活圈页面
-(void)showLifeInfoListActionCode:(NSString *)code action:(NSInteger)action
{
    [self showActionCode:code];
    [self.lifeInfoListView loadEvent:action];
}

//会员短信营销
-(void)showsmsListActionCode:(NSString *)code action:(NSInteger)action
{
    [self showActionCode:code];
    [self.smsListView loadEvent:action];
}
//会员红包页面
-(void)showenvelopeActionCode:(NSString *)code action:(NSInteger)action
{
    [self showActionCode:code];
    [self.envelopeListView loadEvent:action];
}

//会员短信充值页面
-(void)showSMSRehargeViewActionCode:(int)remainNum action:(int)action
{
    [self showView:SMS_RECHARGE_VIEW];
    [self.smsReChargeView loadData:remainNum action:action];
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];


}
//会员商品促销模块
-(void)showmenuTimeListViewActionCode:(NSString*)code action:(int)action
{
   
    [self showActionCode:code];
//    [self.menuTimeListView loadevent:action];
    
    
}

//加载短信接收人页面
- (void)loadSmsRecieverListView
{
    if (self.smsReciverListView) {
        self.smsReciverListView.view.hidden=NO;
    } else {
        self.smsReciverListView=[[SmsReciverListView alloc] initWithNibName:@"SmsReciverListView"bundle:nil];
        [self.view addSubview:self.smsReciverListView.view];
    }
    [self.smsReciverListView loadData];
}

//加载短信列表页.
- (void)loadSmsListview
{
    if (self.smsListView) {
         self.smsListView.view.hidden=NO;
    } else {
        self.smsListView=[[SmsListView alloc] init];
        [self.view addSubview:self.smsListView.view];
    }
}

//加载短信发送页.
- (void)loadSmsEditView
{
    if (self.smsEditView) {
        self.smsEditView.view.hidden=NO;
    } else {
        self.smsEditView=[[SmsEditView alloc] initWithNibName:@"SmsEditView" bundle:nil];
        [self.view addSubview:self.smsEditView.view];
    }
}
//加载短信发送页.
- (void)loadSmsTemplateView
{
    if (self.smsTemplateView) {
        self.smsTemplateView.view.hidden=NO;
    } else {
        self.smsTemplateView=[[SmsTemplateView alloc] initWithNibName:@"SmsTemplateView"bundle:nil];
        [self.view addSubview:self.smsTemplateView.view];
    }
}
//加载短信充值页.
- (void)loadSmsReChargeView
{
    if (self.smsReChargeView) {
        self.smsReChargeView.view.hidden=NO;
    } else {
        self.smsReChargeView=[[SmsReChargeView alloc] init];
//        self.smsReChargeView.parent = self;
        [self.view addSubview:self.smsReChargeView.view];
    }
}

//加载短信充值页.
- (void)loadSmsOrderConfirmView
{
    if (self.smsOrderConfirmView) {
        self.smsOrderConfirmView.view.hidden=NO;
    } else {
        self.smsOrderConfirmView=[[SmsOrderConfirmView alloc] initWithNibName:@"SmsOrderConfirmView"bundle:nil];
        [self.view addSubview:self.smsOrderConfirmView.view];
    }
    [self.smsOrderConfirmView loadData];
}

//加载多选商品页 .
- (void)loadSelectMultiMenuListView
{
    if (self.selectMultiMenuListView) {
        self.selectMultiMenuListView.view.hidden=NO;
    } else {
        self.selectMultiMenuListView=[[SelectMultiMenuListView alloc] initWithNibName:@"SelectMultiMenuListView" bundle:nil];
        [self.view addSubview:self.selectMultiMenuListView.view];
    }
}

- (void)loadMenuTimeListView
{
//    if (self.menuTimeListView) {
//        self.menuTimeListView.view.hidden=NO;
//    } else {
//        self.menuTimeListView=[[MenuTimeListView alloc]initWithNibName:@"MenuTimeListView"bundle:nil parent:self];
//        [self.view addSubview:self.menuTimeListView.view];
//    }
}

//加载多选页.
- (void)loadMultiCheckView
{
    if (self.multiCheckView) {
        self.multiCheckView.view.hidden=NO;
    } else {
        self.multiCheckView=[[MultiCheckView alloc] init];
        [self.view addSubview:self.multiCheckView.view];
    }
}

//加载编辑促销方案编辑页
- (void)loadMenuTimeEditView
{
//    if (self.menuTimeEditView) {
//        self.menuTimeEditView.view.hidden=NO;
//    } else {
////        self.menuTimeEditView=[[MenuTimeEditView alloc] initWithNibName:@"MenuTimeEditView"bundle:nil parent:self];
//        self.menuTimeEditView=[[MenuTimeEditView alloc] initWithNibName:@"MenuTimeEditView5" bundle:nil parent:self];
//
//        [self.view addSubview:self.menuTimeEditView.view];
//    }
}

//加载促销价格编辑页
- (void)loadMenuTimePriceEditView
{
    if (self.menuTimePriceEditView) {
        self.menuTimePriceEditView.view.hidden=NO;
    } else {
        self.menuTimePriceEditView=[[MenuTimePriceEditView alloc] initWithNibName:@"MenuTimePriceEditView" bundle:nil];
        [self.view addSubview:self.menuTimePriceEditView.view];
    }
}

//加载选择商品列表.
- (void)loadSelectMenuListView
{
    if (self.selectMenuListView) {
        self.selectMenuListView.view.hidden=NO;
    } else {
        self.selectMenuListView=[[SelectMenuListView alloc] initWithNibName:@"SelectMenuListView" bundle:nil];;
        [self.view addSubview:self.selectMenuListView.view];
    }
}

//加载红包列表
- (void)loadEnvelopeListView
{
    if (self.envelopeListView) {
        self.envelopeListView.view.hidden=NO;
    } else {
        self.envelopeListView=[[EnvelopeListView alloc] initWithNibName:@"EnvelopeListView"bundle:nil parent:self];
        [self.view addSubview:self.envelopeListView.view];
    }
}

//加载添加红包
- (void)loadEnvelopeEditView
{
    if (self.envelopeEditView) {
        self.envelopeEditView.view.hidden=NO;
    } else {
        self.envelopeEditView=[[EnvelopeEditView alloc] initWithNibName:@"EnvelopeEditView"bundle:nil parent:self];
        [self.view addSubview:self.envelopeEditView.view];
    }
}

//加载生活圈列表
- (void)loadLifeInfoListView
{
    if (self.lifeInfoListView) {
        self.lifeInfoListView.view.hidden=NO;
    } else {
        self.lifeInfoListView=[[LifeInfoListView alloc] initWithNibName:@"LifeInfoListView"bundle:nil parent:self];
        [self.view addSubview:self.lifeInfoListView.view];
    }
    [self.lifeInfoListView loadDatas];
}

//加载添加生活圈信息
- (void)loadLifeInfoEditView
{
    if (self.lifeInfoEditView) {
        self.lifeInfoEditView.view.hidden=NO;
    } else {
        self.lifeInfoEditView=[[LifeInfoEditView alloc] initWithNibName:@"LifeInfoEditView"bundle:nil parent:self];
        [self.view addSubview:self.lifeInfoEditView.view];
    }
}

//加载红包详情
- (void)loadEnvelopeDetailView
{
    if (self.envelopeDetailView) {
        self.envelopeDetailView.view.hidden=NO;
    } else {
        self.envelopeDetailView=[[EnvelopeDetailView alloc] initWithNibName:@"EnvelopeDetailView"bundle:nil parent:self];
        [self.view addSubview:self.envelopeDetailView.view];
    }
}
-(void)moduleClass:(id)className{

    className = (MarketModule *)className;
    
}

@end
