//
//  OrderPayListView.m
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Platform.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "JsonHelper.h"
#import "RemoteEvent.h"
#import "ViewFactory.h"
#import "UIView+Sizes.h"
#import "RemoteResult.h"
#import "MBProgressHUD.h"
#import "PaymentModule.h"
#import "OrderPayListView.h"
#import "OrderPayListCell.h"
#import "TDFMediator+PaymentModule.h"
#import "NSString+Estimate.h"
#import "ActionConstants.h"
#import "RestConstants.h"
#import "DatePickerView.h"
#import "TDFBarChartView.h"
#import "TDFBarChartVo.h"
#import "YYModel.h"
#import "UIImage+TDFColor.h"

@interface OrderPayListView ()<DatePickerViewEvent,TDFBarChartViewEvent>
@property (nonatomic, strong)TDFBarChartView *barChartView;
@property (nonatomic, strong)DatePickerView *datePickerView;
@end
@implementation OrderPayListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
    }
    return self;
}

- (UIScrollView *)scrollerView {
    if(!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] init];
        _scrollerView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
        [_scrollerView addSubview:self.container];
    }
    return _scrollerView;
}

- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _container;
}

#pragma mark - accountContainer
- (UIView *)accountContainer {
    if(!_accountContainer) {
        _accountContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
        [_accountContainer addSubview:self.backgroundView];
        
        UIView *feePanel = [[UIView alloc] init];
        feePanel.frame = CGRectMake(0, 10, SCREEN_WIDTH, 170);
        [_accountContainer addSubview:feePanel];
        
        [feePanel addSubview:self.unAccount];
        [feePanel addSubview:self.unAccountFeeLbl];
        [feePanel addSubview:self.dailyReceiveLbl];
        [feePanel addSubview:self.dailyAccountLbl];
        [feePanel addSubview:self.dailyAccountFeeLbl];
        [feePanel addSubview:self.dailyReceiveFeeLbl];
        [feePanel addSubview:self.dailyAccountInfoLbl];
        [feePanel addSubview:self.totalIncome];
        [feePanel addSubview:self.monthReceiveFeeLbl];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.75;
        label.text = NSLocalizedString(@"本月累计已到账金额(元)", nil);
        label.font = [UIFont systemFontOfSize:12];
        label.frame = CGRectMake(self.totalIncome.width+20, 117, (SCREEN_WIDTH-20)/2.0f, 20);
        [feePanel addSubview:label];
        [feePanel addSubview:self.monthAccountFeeLbl];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.alpha = 0.4;
        lineView.frame = CGRectMake(SCREEN_WIDTH/2.0f, 67, 1, 33);
        [feePanel addSubview:lineView];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.alpha = 0.4;
        lineView.frame = CGRectMake(SCREEN_WIDTH/2.0f, 119, 1, 33);
        [feePanel addSubview:lineView];
        
        [_accountContainer addSubview:self.unBindView];
        [_accountContainer addSubview:self.bindView];
        
    }
    return _accountContainer;
}

- (UIView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.alpha = 0.1;
        _backgroundView.frame = CGRectMake(5, 10, SCREEN_WIDTH-10, 340);
    }
    return _backgroundView;
}

- (UILabel *)unAccount {
    if(!_unAccount) {
        _unAccount = [[UILabel alloc] init];
        _unAccount.textColor = [UIColor whiteColor];
        _unAccount.alpha = 0.75;
        _unAccount.font = [UIFont boldSystemFontOfSize:14];
        _unAccount.frame = CGRectMake(0, 10, SCREEN_WIDTH, 25);
        _unAccount.textAlignment = NSTextAlignmentCenter;
    }
    return _unAccount;
}

- (UILabel *)unAccountFeeLbl {
    if(!_unAccountFeeLbl) {
        _unAccountFeeLbl = [[UILabel alloc] init];
        _unAccountFeeLbl.textColor = [UIColor whiteColor];
        _unAccountFeeLbl.font = [UIFont boldSystemFontOfSize:19];
        _unAccountFeeLbl.frame = CGRectMake(0, 35, SCREEN_WIDTH, 30);
        _unAccountFeeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _unAccountFeeLbl;
}

- (UILabel *)dailyReceiveLbl {
    if(!_dailyReceiveLbl) {
        _dailyReceiveLbl = [[UILabel alloc] init];
        _dailyReceiveLbl.textColor = [UIColor whiteColor];
        _dailyReceiveLbl.alpha = 0.75;
        _dailyReceiveLbl.font = [UIFont systemFontOfSize:12];
        _dailyReceiveLbl.frame = CGRectMake(10, 65, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dailyReceiveLbl;
}

- (UILabel *)dailyReceiveFeeLbl {
    if(!_dailyReceiveFeeLbl) {
        _dailyReceiveFeeLbl = [[UILabel alloc] init];
        _dailyReceiveFeeLbl.textColor = [UIColor whiteColor];
        _dailyReceiveFeeLbl.font = [UIFont systemFontOfSize:14];
        _dailyReceiveFeeLbl.frame = CGRectMake(10, 85, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dailyReceiveFeeLbl;
}

- (UILabel *)dailyAccountLbl {
    if(!_dailyAccountLbl) {
        _dailyAccountLbl = [[UILabel alloc] init];
        _dailyAccountLbl.textColor = [UIColor whiteColor];
        _dailyAccountLbl.alpha = 0.75;
        _dailyAccountLbl.font = [UIFont systemFontOfSize:12];
        _dailyAccountLbl.frame = CGRectMake(self.dailyReceiveLbl.width+20, 65, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dailyAccountLbl;
}

- (UILabel *)dailyAccountFeeLbl {
    if(!_dailyAccountFeeLbl) {
        _dailyAccountFeeLbl = [[UILabel alloc] init];
        _dailyAccountFeeLbl.textColor = [UIColor whiteColor];
        _dailyAccountFeeLbl.font = [UIFont systemFontOfSize:14];
        _dailyAccountFeeLbl.frame = CGRectMake(self.dailyReceiveFeeLbl.width+20, 85, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dailyAccountFeeLbl;
}

- (UILabel *)dailyAccountInfoLbl {
    if(!_dailyAccountInfoLbl) {
        _dailyAccountInfoLbl = [[UILabel alloc] init];
        _dailyAccountInfoLbl.textColor = [UIColor whiteColor];
        _dailyAccountInfoLbl.alpha = 0.8;
        _dailyAccountInfoLbl.font = [UIFont systemFontOfSize:8];
        _dailyAccountInfoLbl.frame = CGRectMake(self.dailyReceiveFeeLbl.width+20, 101, 150, 16);
    }
    return _dailyAccountInfoLbl;
}

- (UILabel *)totalIncome {
    if(!_totalIncome) {
        _totalIncome = [[UILabel alloc] init];
        _totalIncome.textColor = [UIColor whiteColor];
        _totalIncome.alpha = 0.75;
        _totalIncome.font = [UIFont systemFontOfSize:12];
        _totalIncome.frame = CGRectMake(10, 117, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _totalIncome;
}

- (UILabel *)monthReceiveFeeLbl {
    if(!_monthReceiveFeeLbl) {
        _monthReceiveFeeLbl = [[UILabel alloc] init];
        _monthReceiveFeeLbl.textColor = [UIColor whiteColor];
        _monthReceiveFeeLbl.font = [UIFont systemFontOfSize:14];
        _monthReceiveFeeLbl.frame = CGRectMake(10, 140, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _monthReceiveFeeLbl;
}

- (UILabel *)monthAccountFeeLbl {
    if(!_monthAccountFeeLbl) {
        _monthAccountFeeLbl = [[UILabel alloc] init];
        _monthAccountFeeLbl.textColor = [UIColor whiteColor];
        _monthAccountFeeLbl.font = [UIFont systemFontOfSize:14];
        _monthAccountFeeLbl.frame = CGRectMake(self.monthReceiveFeeLbl.width+20, 140, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _monthAccountFeeLbl;
}

- (UIView *)unBindView {
    if(!_unBindView) {
        _unBindView = [[UIView alloc] init];
        _unBindView.frame = CGRectMake(0, 180, SCREEN_WIDTH, 170);
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"ico_warning_r"];
        icon.frame = CGRectMake((SCREEN_WIDTH/2.0f)-75, 0, 25, 25);
        [_unBindView addSubview:icon];
        
        [_unBindView addSubview:self.warningTip];
        self.warningTip.frame = CGRectMake(icon.frame.origin.x + 25 + 10, 0, 200, 25);

        [_unBindView addSubview:self.lblHint];
        
        [_unBindView addSubview:self.bindBtn];
    }
    return _unBindView;
}

- (UILabel *)warningTip {
    if(!_warningTip) {
        _warningTip = [[UILabel alloc] init];
        _warningTip.textAlignment = NSTextAlignmentLeft;
        _warningTip.textColor = [UIColor redColor];
        _warningTip.font = [UIFont systemFontOfSize:13];
        _warningTip.text = NSLocalizedString(@"未绑定收款账户", nil);
    }
    return _warningTip;
}

- (UITextView *)lblHint {
    if(!_lblHint) {
        _lblHint = [[UITextView alloc] init];
        _lblHint.textColor = [UIColor whiteColor];
        _lblHint.alpha = 0.6;
        _lblHint.backgroundColor = [UIColor clearColor];
        _lblHint.font = [UIFont systemFontOfSize:12];
        _lblHint.frame = CGRectMake(0, 30, SCREEN_WIDTH-16, 90);
        _lblHint.userInteractionEnabled = NO;
    }
    return _lblHint;
}

- (UIButton *)bindBtn {
    if(!_bindBtn) {
        _bindBtn = [[UIButton alloc] init];
        [_bindBtn setTitle:NSLocalizedString(@"立即绑定收款账户，开始收款", nil) forState:UIControlStateNormal];
        [_bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bindBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_bindBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
        _bindBtn.frame = CGRectMake(8, 120, SCREEN_WIDTH-16, 37);
        [_bindBtn addTarget:self action:@selector(bangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindBtn;
}

- (UITextView *)bindView {
    if(!_bindView) {
        _bindView = [[UITextView alloc] init];
        _bindView.font = [UIFont systemFontOfSize:12];
        _bindView.textColor = [UIColor whiteColor];
        _bindView.frame = CGRectMake(0, 180, SCREEN_WIDTH, 80);
        _bindView.alpha = 0.6;
        _bindView.userInteractionEnabled = NO;
        _bindView.backgroundColor = [UIColor clearColor];
    }
    return _bindView;
}

#pragma mark - chartContainer

- (UIView *)chartContainer {
    if(!_chartContainer) {
        _chartContainer = [[UIView alloc] init];
        _chartContainer.backgroundColor = [UIColor blackColor];
        _chartContainer.frame = CGRectMake(0, 350, SCREEN_WIDTH, 260);
        
        [_chartContainer addSubview:self.chartView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:85/255.0f green:85/255.0f blue:85/255.0f alpha:1];
        lineView.frame = CGRectMake(5, 50, SCREEN_WIDTH-10, 1);
        [_chartContainer addSubview:lineView];
        
        [_chartContainer addSubview:self.dateBtn];
        [_chartContainer addSubview:self.paymentMethodLabel];
        
    }
    return _chartContainer;
}

- (UIView *)chartView {
    if(!_chartView) {
        _chartView = [[UIView alloc] init];
        _chartView.frame = CGRectMake(5, 60, SCREEN_WIDTH-10, 160);
    }
    return _chartView;
}

- (NavButton3 *)dateBtn {
    if(!_dateBtn) {
        _dateBtn = [[NavButton3 alloc] init];
        [_dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_dateBtn setImage:[UIImage imageNamed:@"ico_next_down_w"] forState:UIControlStateNormal];
        _dateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -75, 0, 0);
        _dateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
        _dateBtn.frame = CGRectMake((SCREEN_WIDTH-121)/2, 20, 121, 28);
        [_dateBtn addTarget:self action:@selector(chooseDateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateBtn;
}

- (UIView *)paymentMethodLabel {
    if(!_paymentMethodLabel) {
        _paymentMethodLabel = [[UIView alloc] init];
        _paymentMethodLabel.frame = CGRectMake(5, 220, SCREEN_WIDTH-10, 20);
        
        [_paymentMethodLabel addSubview:self.consumeTxt];

        [_paymentMethodLabel addSubview:self.rechargeTxt];
        
    }
    return _paymentMethodLabel;
}

- (UIButton *)consumeTxt {
    if(!_consumeTxt) {
        _consumeTxt = [[UIButton alloc] init];
        [_consumeTxt setTitle:NSLocalizedString(@"消费收入0.00元", nil) forState:UIControlStateNormal];
        _consumeTxt.titleLabel.font = [UIFont systemFontOfSize:12];
        [_consumeTxt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _consumeTxt.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0, 20);
        
        UIImage *icon = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(8, 8)];
        
        [_consumeTxt setImage:icon forState:UIControlStateNormal];
        
        _consumeTxt.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        _consumeTxt.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    }
    return _consumeTxt;
}

- (UIButton *)rechargeTxt {
    if(!_rechargeTxt) {
        _rechargeTxt = [[UIButton alloc] init];
        [_rechargeTxt setTitle:NSLocalizedString(@"充值收入0.00元", nil) forState:UIControlStateNormal];
        _rechargeTxt.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rechargeTxt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rechargeTxt.frame = CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 20);
        
        UIImage *icon = [UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(8, 8)];
        [_rechargeTxt setImage:icon forState:UIControlStateNormal];
        
        _rechargeTxt.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _rechargeTxt.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    }
    return _rechargeTxt;
}

#pragma mark - orderContainer

- (UIView *)orderContainer {
    if(!_orderContainer) {
        _orderContainer = [[UIView alloc] init];
        _orderContainer.frame = CGRectMake(0, 610, SCREEN_WIDTH, 40);
        
        [_orderContainer addSubview:self.backView];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = self.backView.frame;
        [btn addTarget:self action:@selector(btnMonthShowClick:) forControlEvents:UIControlEventTouchUpInside];
        [_orderContainer addSubview:btn];
    }
    return _orderContainer;
}

- (UIView *)backView {
    if(!_backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, 40);
    
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"当日账户明细", nil);
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(8, 9, 219, 21);
        [_backView addSubview:label];
        
        [_backView addSubview:self.imgMonthShow];
        [_backView addSubview:self.lblDayRight];
        self.lblDayRight.frame = CGRectMake(self.imgMonthShow.frame.origin.x-33, 9, 33, 21);
    }
    return _backView;
}

- (UILabel *)lblDayRight {
    if(!_lblDayRight) {
        _lblDayRight = [[UILabel alloc] init];
        _lblDayRight.text = NSLocalizedString(@"详情", nil);
        _lblDayRight.font = [UIFont systemFontOfSize:14];
        _lblDayRight.textColor = [UIColor whiteColor];
    }
    return _lblDayRight;
}

- (UIImageView *)imgMonthShow {
    if(!_imgMonthShow) {
        _imgMonthShow = [[UIImageView alloc] init];
        _imgMonthShow.image = [UIImage imageNamed:@"ico_next_down_w"];
        _imgMonthShow.frame = CGRectMake(SCREEN_WIDTH-5-3-22-5, 10, 22, 22);
    }
    return _imgMonthShow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollerView];
    
    [self.container addSubview:self.accountContainer];
    [self.container addSubview:self.chartContainer];
    [self.container addSubview:self.orderContainer];
    
    [self initMainView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShopInfo) name:@"PAYMENT_TYPE_VIEW_CHANGE_NOTIFCATION" object:nil];
    [self loadData];
}

- (void)initMainView
{
    self.lblDayRight.text=NSLocalizedString(@"展开", nil);
    self.imgMonthShow.image=[UIImage imageNamed:@"ico_next_down_w.png"];
    self.backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.backView.layer.cornerRadius = 4;
    self.backgroundView.layer.cornerRadius = 4;
    self.orderContainer.layer.cornerRadius = 5;
    self.orderContainer.layer.masksToBounds = YES;
    self.dayDic = [[NSMutableDictionary alloc]init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.bankAccoutBtn];
     self.datePickerView = [[DatePickerView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height+64) title:NSLocalizedString(@"请选择日期", nil) client:self];
    self.barChartView = [[TDFBarChartView alloc]initWithFrame:CGRectMake(0, 0, self.chartView.bounds.size.width, self.chartView.bounds.size.height) itemSize:CGSizeMake(10,self.chartView.bounds.size.height*5/6 ) itemSpace:10 delegate:self];
    self.barChartView.dateFomatter = MonthToDaySample;
    [self.chartView addSubview:self.barChartView];
    self.scrollerView.hidden = YES;
    [UIHelper refreshPos:self.container scrollview:self.scrollerView];
    [UIHelper clearColor:self.container];
    self.dateBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark 店家信息
- (void)loadData
{

    self.title = self.payment.detail;
    [self.titleBox initWithName:self.payment.detail backImg:Head_ICON_BACK moreImg:nil];
    if ([self isChain]) {
        self.reChargeLabel = NSLocalizedString(@"充值", nil);
    }else{
        self.reChargeLabel = NSLocalizedString(@"收款", nil);
    }
    self.warningTip.text =NSLocalizedString(@"未绑定收款账户", nil);
    [self loadShopInfo];
    self.title = self.payment.detail;
    _bankAccoutBtn.hidden = YES;
}

-(void)loadShopInfo{
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.scrollerView.hidden = NO;
        self.shopInfoVO = [ShopInfoVO yy_modelWithDictionary:data[@"data"]];
        [self updateView];
        NSCalendar* calendar=[NSCalendar currentCalendar];
        NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
        self.currYear=[comps year];
        self.currMonth=[comps month];
        self.currDay=[comps day];
        [self loadChartData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark update UI
-(void)updateView{
    if ([self isChain]) {
        [self.paymentMethodLabel setHidden:YES];
        [self.chartContainer setHeight:240];
    }else{
        [self.paymentMethodLabel setHidden:NO];
        [self.chartContainer setHeight:260];
    }
    NSString *isSuper =[[Platform Instance]getkey:USER_IS_SUPER];
    NSInteger realDay =  self.shopInfoVO.fundBillHoldDay + 1;
    BOOL isAccount = [NSString isNotBlank:self.shopInfoVO.bankAccount];
    BOOL isShow =  (self.isBackMenu &&![NSString isBlank:self.shopInfoVO.bankAccount]) ? YES : NO;
    _bankAccoutBtn.hidden = !isShow;

    self.dailyAccountInfoLbl.text = isAccount? (self.payment.payType == Packet?@"":[NSString stringWithFormat: NSLocalizedString(@"(%@官方已收取0.6%%的服务费)", nil),self.payment.typeName]):@"";
    self.totalIncome.text = [NSString stringWithFormat:NSLocalizedString(@"本月累计%@%@收入(元)", nil),self.payment.typeName,self.reChargeLabel];
    self.lblHint.text = [self tip:realDay];
    NSString *str;
    if ([self isChain]) {
        str = NSLocalizedString(@"充值", nil);
    }else{
        str = NSLocalizedString(@"支付", nil);
    }
    if(self.payment.payType == Packet){
        self.bindView.text =[NSString stringWithFormat:NSLocalizedString(@" 顾客使用支付宝/微信扫码点餐后可直接用二维火道具（棒棒糖、巧克力、玫瑰花）支付，将由二维火折成等额现金分账给商家。顾客支付的钱暂时由杭州迪火科技有限公司代收，并在支付成功的第二天打入您指定的账户，二维火道具不收取任何服务费。若遇系统故障，延迟一天转账，敬请谅解。", nil)];
    }  if (self.payment.payType == QQ) {
        self.bindView.text = [NSString stringWithFormat:NSLocalizedString(@"顾客使用QQ钱包支付收款成功后，此笔钱款会在第二日自动转账到您的收款账户，QQ钱包官方以0.6%%的费率收取手续费（“未到账金额”、“QQ钱包支付收入”皆为扣除手续费之前的金额）。若遇系统故障，延迟一天转账，敬请谅解。", nil)];
    }
    if (self.payment.payType == Weixin || self.payment.payType == Alipay){
    self.bindView.text = [NSString stringWithFormat:NSLocalizedString(@" 顾客使用%@支付付款成功后，此笔钱款会在第%ld日中午12：00后自动转账到您绑定的收款账户，%@官方以0.6%%的费率收取服务费（“未到账金额”、“%@%@收入”皆为扣除服务费之前的金额）。若遇系统故障，延迟一天转账，敬请谅解。", nil),self.payment.typeName,realDay,self.payment.typeName,self.payment.typeName,str];
    }
  
    
    [self.bindView sizeToFit];
    [self.lblHint sizeToFit];
    [self.unBindView setHidden:isAccount];
    [self.bindView setHidden:!isAccount];
    [self.bindBtn setTop:self.lblHint.top + self.lblHint.height+30 ];
    [self.unBindView setHeight:self.bindBtn.top + self.bindBtn.height +10];
    [self.backgroundView setHeight:isAccount?(self.bindView.height+10 +self.bindView.top):self.unBindView.height+self.unBindView.top];
    if ([self isChain]) {
        [self.accountContainer setHeight: [isSuper integerValue]==1? (self.backgroundView.top + self.backgroundView.height):(![self.codeArray containsObject:PHONE_BRAND_THIRD_PAY_SUM]?0:(self.backgroundView.top + self.backgroundView.height))];
        [self.accountContainer setHidden:[isSuper integerValue]==1?NO:(![self.codeArray containsObject:PHONE_BRAND_THIRD_PAY_SUM]?YES:NO)];
        
        [self.chartContainer setTop:[isSuper integerValue]==1 ? (self.accountContainer.top+self.accountContainer.height):(![self.codeArray containsObject:PHONE_BRAND_THIRD_PAY_SUM]?50:(self.accountContainer.top+self.accountContainer.height))];
        [self.orderContainer setHidden:[isSuper intValue]? NO:(![self.codeArray containsObject:PHONE_BRAND_THIRD_PAY_DETAL]?YES:NO)];
    }else{
        [self.accountContainer setHeight: [isSuper integerValue]==1? (self.backgroundView.top + self.backgroundView.height):(![self.codeArray containsObject:PAD_WEIXIN_SUM]?0:(self.backgroundView.top + self.backgroundView.height))];
        [self.accountContainer setHidden:[isSuper integerValue]==1?NO:(![self.codeArray containsObject:PAD_WEIXIN_SUM]?YES:NO)];
        
        [self.chartContainer setTop:[isSuper integerValue]==1 ? (self.accountContainer.top+self.accountContainer.height):(![self.codeArray containsObject:PAD_WEIXIN_SUM]?50:(self.accountContainer.top+self.accountContainer.height))];
        [self.orderContainer setHidden:[isSuper intValue]? NO:(![self.codeArray containsObject:PAD_WEIXIN_DETAL]?YES:NO)];
    }
    
    [self.orderContainer setTop:self.chartContainer.top + self.chartContainer.height];
    [UIHelper refreshUI:self.container scrollview:self.scrollerView];

}
#pragma mark 请求数据
-(void)loadChartData{
    [self.dateBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%ld年%02ld月", nil),self.currYear,self.currMonth] forState:UIControlStateNormal];
    [self.barChartView loadData:[NSMutableDictionary new]];
    [self.barChartView initChartView:self.currYear month:self.currMonth day:self.currDay];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"year_month"] = [NSString stringWithFormat:@"%ld-%02ld",self.currYear,self.currMonth];
    param[@"pay_type"] = self.payment.typeCode;
    
    @weakify(self);
    [[TDFPaymentService new] getTotalBillsMoneyWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableDictionary *dict = [data objectForKey:@"data"];
        self.unAccountFeeLbl.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"noShareTotalFee"]];
        self.monthReceiveFeeLbl.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthTotalFee"]];
        self.monthAccountFeeLbl.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthShareIncome"]];
        
        NSMutableArray *everyDays = [dict objectForKey:@"everyDays"];
        NSArray *dayDatas = [NSArray yy_modelArrayWithClass:[PayBillSummaryOfMonthVO class] json:everyDays];
        NSMutableDictionary *chartDict = [NSMutableDictionary dictionaryWithCapacity:31];
        [self.dayDic removeAllObjects];
        for (PayBillSummaryOfMonthVO *vo in dayDatas) {
            TDFBarChartVo *chartVo = [TDFBarChartVo new];
            chartVo.value = vo.totalFee;
            chartVo.value2 = vo.payTagTotalFee;
            chartVo.isSelected = NO;
            chartVo.key = vo.date;
            [chartDict setObject:chartVo forKey:vo.date];
            [self.dayDic setObject:vo forKey:vo.date];
        }
        [self.barChartView loadData:chartDict];
        [self.barChartView initChartView:self.currYear month:self.currMonth day:self.currDay];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark 日期选择
- (void)chooseDateClick {
    [self.datePickerView removeFromSuperview];
     self.datePickerView = [[DatePickerView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height+64) title:NSLocalizedString(@"请选择日期", nil) client:self];
    self.datePickerView.years = [self years];
    self.datePickerView.monthes = [self monthes];
    [self.datePickerView initDate:self.currYear  month:self.currMonth];
}

-(void)pickerOption:(DatePickerView *)obj eventType:(NSInteger)evenType{
    self.currYear = obj.year;
    self.currMonth = obj.month;
    [self.dateBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%ld年%02ld月", nil),self.currYear,self.currMonth] forState:UIControlStateNormal];
    [self.barChartView loadData:[NSMutableDictionary new]];
    [self.barChartView initChartView:self.currYear month:self.currMonth day:self.currDay];
    [self loadChartData];
}

#pragma mark  柱状图
-(void)barChartViewdidScroll:(TDFBarChartView *)barChartView chartVo:(TDFBarChartVo *)chartVo
{
    self.currDay = barChartView.currentDay;
    NSString *selectDate = [NSString stringWithFormat:NSLocalizedString(@"%02ld月%02ld日", nil), (long)self.currMonth, (long)self.currDay];
    self.dailyReceiveLbl.text = [NSString stringWithFormat:NSLocalizedString(@"%@%@%@收入(元)", nil),selectDate,self.payment.typeName,self.reChargeLabel];
    self.unAccount.text = [NSString stringWithFormat:NSLocalizedString(@"%@%@未到账总额(元)", nil),self.payment.typeName,self.reChargeLabel];
    self.dailyAccountLbl.text = [selectDate stringByAppendingString:NSLocalizedString(@"已到账金额(元)", nil)];
    self.dailyReceiveFeeLbl.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:chartVo.value]];
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"消费收入%.2f元", nil),chartVo.value-chartVo.value2];
    [self.consumeTxt setTitle:text forState:UIControlStateNormal];
    text = [NSString stringWithFormat:NSLocalizedString(@"充值收入%.2f元", nil),chartVo.value2];
    [self.rechargeTxt setTitle:text forState:UIControlStateNormal];
    if ([self isChain]) {
        barChartView.tip.text = [NSString stringWithFormat:NSLocalizedString(@"%02ld月%02ld日 %@  充值收入%.2f元", nil),barChartView.currentMonth,barChartView.currentDay,barChartView.week,chartVo.value2];
    }else{
        barChartView.tip.text = [NSString stringWithFormat:NSLocalizedString(@"%02ld月%02ld日 %@", nil),barChartView.currentMonth,barChartView.currentDay,barChartView.week];
    }
    PayBillSummaryOfMonthVO *vo = [self.dayDic objectForKey:chartVo.key];
    if (!vo) {
        vo = [PayBillSummaryOfMonthVO  new];
    }
    self.dailyAccountFeeLbl.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:vo.shareIncome]];
}

#pragma mark forward
- (IBAction)btnMonthShowClick:(UIButton *)sender
{
    NSString* dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
    BOOL isShow =  (self.isBackMenu && ![NSString isBlank:self.shopInfoVO.bankAccount]) ? YES : NO;
    UIViewController *orderListVc = [[TDFMediator sharedInstance] TDFMediator_orderDetailListViewControllerWithDate:dateStr action:self.payment isAccount:isShow];
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:orderListVc] animated:YES completion:nil];
}

- (IBAction)bangBtnClick:(UIButton *)sender
{
    NSString *isSuper =[[Platform Instance]getkey:USER_IS_SUPER];
    if ([isSuper isEqualToString:@"1"]) {
        [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
        }] animated:YES];
        
    }else{
        [AlertBox show:NSLocalizedString(@"您没有[收款账户]的权限", nil)];
        return;
    }
}
-(NSString *)tip:(NSInteger)day{
    
    NSString *string;
    switch (self.payment.payType) {
        case Weixin:
            string= NSLocalizedString(@" 绑定收款账户后，将为您开通电子支付，顾客使用微信扫码点餐后可以使用微信支付进行付款。在顾客支付成功的第2日中午12：00后此笔钱款将自动打入您绑定的账户，微信官方以0.6%的费率收取服务费。请尽快绑定您的收款账户!", nil);
            break;
        case Alipay:
            string= NSLocalizedString(@" 绑定收款账户后，将为您开通电子支付，顾客使用支付宝扫码点餐后可以使用支付宝支付进行付款。在顾客支付成功的第2日中午12：00后此笔钱款将自动打入您绑定的账户，支付宝官方以0.6%的费率收取服务费。请尽快绑定您的收款账户！", nil);
            break;
        case Packet:
            string =NSLocalizedString(@" 顾客使用支付宝/微信扫码点餐后可直接用二维火道具（棒棒糖、巧克力、玫瑰花）支付，将由二维火折成等额现金分账给商家。顾客支付的钱暂时由杭州迪火科技有限公司代收，并在支付成功的第二天打入您指定的账户，二维火道具不收取任何服务费。请尽快绑定您的收款账户，才能收到顾客二维火支付的付款！", nil);
            break;
        case QQ:
            string = NSLocalizedString(@"绑定收款账户后，将为您开通电子支付，顾客使用QQ扫码点餐后可以使用QQ钱包支付进行付款。在顾客支付成功的第2日中午12：00后此笔钱款将自动打入您绑定的账户，QQ官方以0.6%的费率收取服务费。请尽快绑定您的收款账户！", nil);
            default:
            break;
       }
    return string;
}

- (BOOL) isChain
{
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

#pragma mark  数据源
-(NSMutableArray *)monthes{
    NSMutableArray *monthes = [[NSMutableArray alloc] init];
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger maxMonth=[comps month];
    if ([self isChain]) {
        if (self.currYear >2016) {
            for (int i =1; i <= maxMonth; i++) {
                [monthes addObject:[NSNumber numberWithInt:i]];
            }
        }else{
            for (int i =9; i <= 12; i++) {
                [monthes addObject:[NSNumber numberWithInt:i]];
            }
        }
    }else{
           monthes = [[NSMutableArray alloc] initWithObjects:@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,nil];
    }
    return monthes;
}

-(NSMutableArray *)years
{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger maxYear=[comps year];
    NSMutableArray *years = [NSMutableArray array];
    if ([self isChain]) {
        for (int i = 2016; i <= maxYear; i++) {
            [years addObject:[NSNumber numberWithInt:i]];
        }
    }else{
        for (int i = 2015; i <= maxYear; i++) {
            [years addObject:[NSNumber numberWithInt:i]];
        }
    }
    return years;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



