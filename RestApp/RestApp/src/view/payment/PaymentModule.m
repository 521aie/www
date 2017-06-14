////
//  PaymentModule.m
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "YYModel.h"
#import "SystemUtil.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "PaymentModule.h"
#import "NSString+Estimate.h"
#import "TDFPaymentTypeVo.h"
#import "TDFMediator.h"
#import "TDFMediator+PaymentModule.h"

@implementation PaymentModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent
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
    
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"电子收款账户", nil) backImg:Head_ICON_BACK moreImg:nil];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [self backMenu];
    }
}

-(void)initPaymentType{
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        ShopInfoVO *shopInfo = [ShopInfoVO yy_modelWithDictionary:data[@"data"]];
        [self initOrderPayData:shopInfo];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)initOrderPayData:(ShopInfoVO *)shopInfo
{
    if ([self menuActions:shopInfo].count > 1) {
//      [self.rootController pushViewController:[[TDFMediator sharedInstance] TDFMediator_paymentTypeViewControllerWithShopInfo:shopInfo menus:[self menuActions:shopInfo]] animated:YES];
    } else{
        
        TDFPaymentTypeVo *action = [self menuActions:shopInfo].lastObject;
        if (action) {
//            [self.rootController pushViewController:[[TDFMediator sharedInstance] TDFMediator_orderPayListViewControllerWithShopInfo:shopInfo action:action isAccount:YES] animated:YES];
        }
    }
}

#pragma mark 判断模块
-(NSMutableArray *)menuActions:(ShopInfoVO *)shopInfo
{
    NSMutableArray *menus = [[NSMutableArray alloc]init];
    
    TDFPaymentTypeVo *action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"微信", nil) detail:NSLocalizedString(@"微信收款明细", nil)img:@"ico_epay_weixin.png" typeCode:@"1" paymentType:Weixin code:ORDER_PAY_LIST_VIEW];
    
    if (shopInfo.displayWxPay) {
        [menus addObject:action];
    }
    
    if (shopInfo.displayAlipay&&shopInfo.alipayStatus) {
        action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"支付宝", nil) detail:NSLocalizedString(@"支付宝收款明细", nil)img:@"ico_epay_alipay.png" typeCode:@"2" paymentType:Alipay code:ORDER_PAY_LIST_VIEW];
        [menus addObject:action];
    }
    
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"0"]) {
        if (shopInfo.displayFund) {
            action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"二维火", nil) detail:NSLocalizedString(@"二维火收款明细", nil)img:@"ico_epay_tdf@2x.png" typeCode:@"4" paymentType:Packet code:ORDER_PAY_LIST_VIEW];
            [menus addObject:action];
        }
    }
    
    if (shopInfo.displayQQ) {
        action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"QQ钱包", nil) detail:NSLocalizedString(@"QQ钱包收款明细", nil)img:@"ico_epay_QQ@2x.png" typeCode:@"5" paymentType:QQ code:ORDER_PAY_LIST_VIEW];
        [menus addObject:action];
    }
    return menus;
}

- (void)hideView
{
    for (UIView *view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

- (void)backMenu
{
    [mainModule backMenu:self];
}

- (void)showView:(NSInteger)viewTag
{
    
    [self hideView];
    if (ORDER_PAY_LIST_VIEW==viewTag) {
        [self loadOrderPayListView];
    }  else if (PAYMENT_NOTE_VIEW==viewTag) {
        [self loadPayNoteView];
    } else if (ORDER_PAY_DETAIL_VIEW==viewTag) {
        [self loadOrderPayDetailView];
    } else if (ORDER_PAY_DETAIL_LIST_VIEW == viewTag) {
        [self loadOrderPayDetailListView];
    }else if (PAYMENT_ORDER_LIST_VIEW == viewTag){
        [self loadPayOrderListView];
    }else if (PAYMENT_TYPE_VIEW == viewTag){
        [self loadPaymentTypeView];
    }
}
//加载 支付宝/微信 账单统计及流水
-(void)loadOrderPayListView{
  
    if (self.orderPayListView) {
        self.orderPayListView.view.hidden = NO;
    } else{
        self.orderPayListView = [[OrderPayListView alloc] initWithNibName:@"OrderPayListView" bundle:nil parent:self];
         [self.view addSubview:self.orderPayListView.view];
    }
}

//加载协议界面
- (void)loadPayNoteView
{
    if (self.paymentNoteView) {
        self.paymentNoteView.view.hidden = NO;
    } else {
        self.paymentNoteView = [[PaymentNoteView alloc] initWithNibName:@"PaymentNoteView" bundle:nil parent:self];
        [self.view addSubview:self.paymentNoteView.view];
    }
    
    self.paymentNoteView.showType = self.shopType;
}


//加载支付账单详细界面
- (void)loadOrderPayDetailView
{
    if (self.orderPayDetailView) {
        self.orderPayDetailView.view.hidden=NO;
    } else {
        self.orderPayDetailView = [[OrderPayDetailView alloc] initWithNibName:@"OrderPayDetailView" bundle:nil parent:self];
        [self.view addSubview:self.orderPayDetailView.view];
    }
}


//加载会员消费记录界面
- (void)loadPayOrderListView
{
    if (self.payOrderListView) {
        self.payOrderListView.view.hidden=NO;
    } else {
        self.payOrderListView = [[PayOrderListView alloc] initWithNibName:@"PayOrderListView"bundle:nil parent:self];
        [self.view addSubview:self.payOrderListView.view];
    }
}
//加载电子支付方式界面
- (void)loadPaymentTypeView
{
    if (self.paymentTypeView) {
        self.paymentTypeView.view.hidden=NO;
    } else {
        self.paymentTypeView = [[PaymentTypeView alloc] init];
        [self.view addSubview:self.paymentTypeView.view];
    }
}

#pragma mark
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
@end
