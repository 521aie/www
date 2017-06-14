 //
//  PaymentTypeView.m
//  RestApp
//
//  Created by xueyu on 16/4/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "Platform.h"
#import "TDFMediator.h"
#import "UIView+Sizes.h"
#import "ActionConstants.h"
#import "PayBillSummaryOfMonthVO.h"
#import "PaymentTypeView.h"
#import <YYModel/YYModel.h>
#import "NSString+Estimate.h"
#import "TDFMediator+PaymentModule.h"
#import "UMMobClick/MobClick.h"
#import "TDFSettleAccountInfo.h"
#import "SystemUtil.h"
#import "TDFPaymentModule.h"

@interface PaymentTypeView()
@property(nonatomic,strong)TDFSettleAccountInfo *settleAccountInfo;
@end
@implementation PaymentTypeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
    }
    return self;
}

- (UIView *)sumPanel {
    if(!_sumPanel) {
        _sumPanel = [[UIView alloc] init];
        _sumPanel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 380);
        [_sumPanel addSubview:self.sumBackView];
        [_sumPanel addSubview:self.feePanel];
        [_sumPanel addSubview:self.unbindingView];
        [_sumPanel addSubview:self.bindingView];
    }
    return _sumPanel;
}

- (UIView *)sumBackView {
    if(!_sumBackView) {
        _sumBackView = [[UIView alloc] init];
        _sumBackView.backgroundColor = [UIColor whiteColor];
        _sumBackView.alpha = 0.1;
        _sumBackView.frame = CGRectMake(5, 5, SCREEN_WIDTH-10, 375);
    }
    return _sumBackView;
}

- (UIView *)feePanel {
    if(!_feePanel) {
        _feePanel = [[UIView alloc] init];
        _feePanel.frame = CGRectMake(0, 5, SCREEN_WIDTH, 170);
        [_feePanel addSubview:self.totalUnCountMoneyLabel];
        [_feePanel addSubview:self.unAcount];
        [_feePanel addSubview:self.dayIncomeTitle];
        [_feePanel addSubview:self.dayIncome];
        [_feePanel addSubview:self.dayAcountTitle];
        [_feePanel addSubview:self.dayAcount];
        [_feePanel addSubview:self.rate];
        [_feePanel addSubview:self.monthIncomeMonryLabel];
        [_feePanel addSubview:self.monthIncome];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.75;
        label.text = NSLocalizedString(@"本月累计已到账金额(元)", nil);
        label.font = [UIFont systemFontOfSize:12];
        label.frame = CGRectMake(self.monthIncomeMonryLabel.width+20, 122, (SCREEN_WIDTH-20)/2.0f, 20);
        [_feePanel addSubview:label];
        [_feePanel addSubview:self.monthAcount];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.alpha = 0.4;
        lineView.frame = CGRectMake(SCREEN_WIDTH/2.0f, 73, 1, 33);
        [_feePanel addSubview:lineView];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.alpha = 0.4;
        lineView.frame = CGRectMake(SCREEN_WIDTH/2.0f, 125, 1, 33);
        [_feePanel addSubview:lineView];
    }
    return _feePanel;
}

- (UILabel *)totalUnCountMoneyLabel {
    if(!_totalUnCountMoneyLabel) {
        _totalUnCountMoneyLabel = [[UILabel alloc] init];
        _totalUnCountMoneyLabel.textColor = [UIColor whiteColor];
        _totalUnCountMoneyLabel.alpha = 0.75;
        _totalUnCountMoneyLabel.font = [UIFont systemFontOfSize:14];
        _totalUnCountMoneyLabel.frame = CGRectMake(0, 15, SCREEN_WIDTH, 21);
        _totalUnCountMoneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalUnCountMoneyLabel;
}
- (UILabel *)unAcount {
    if(!_unAcount) {
        _unAcount = [[UILabel alloc] init];
        _unAcount.textColor = [UIColor whiteColor];
        _unAcount.font = [UIFont boldSystemFontOfSize:19];
        _unAcount.frame = CGRectMake(0, 36, SCREEN_WIDTH, 30);
        _unAcount.textAlignment = NSTextAlignmentCenter;
    }
    return _unAcount;
}
- (UILabel *)dayIncomeTitle {
    if(!_dayIncomeTitle) {
        _dayIncomeTitle = [[UILabel alloc] init];
        _dayIncomeTitle.textColor = [UIColor whiteColor];
        _dayIncomeTitle.alpha = 0.75;
        _dayIncomeTitle.font = [UIFont systemFontOfSize:12];
        _dayIncomeTitle.frame = CGRectMake(10, 70, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dayIncomeTitle;
}
- (UILabel *)dayIncome {
    if(!_dayIncome) {
        _dayIncome = [[UILabel alloc] init];
        _dayIncome.textColor = [UIColor whiteColor];
        _dayIncome.font = [UIFont systemFontOfSize:14];
        _dayIncome.frame = CGRectMake(10, 90, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dayIncome;
}
- (UILabel *)dayAcountTitle {
    if(!_dayAcountTitle) {
        _dayAcountTitle = [[UILabel alloc] init];
        _dayAcountTitle.textColor = [UIColor whiteColor];
        _dayAcountTitle.alpha = 0.75;
        _dayAcountTitle.font = [UIFont systemFontOfSize:12];
        _dayAcountTitle.frame = CGRectMake(self.dayIncomeTitle.width+20, 70, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dayAcountTitle;
}
- (UILabel *)dayAcount {
    if(!_dayAcount) {
        _dayAcount = [[UILabel alloc] init];
        _dayAcount.textColor = [UIColor whiteColor];
        _dayAcount.font = [UIFont systemFontOfSize:14];
        _dayAcount.frame = CGRectMake(self.dayIncome.width+20, 90, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _dayAcount;
}

- (UILabel *)rate {
    if(!_rate) {
        _rate = [[UILabel alloc] init];
        _rate.textColor = [UIColor whiteColor];
        _rate.alpha = 0.8;
        _rate.font = [UIFont systemFontOfSize:8];
        _rate.frame = CGRectMake(self.dayIncome.width+20, 106, 150, 16);

    }
    return _rate;
}

- (UILabel *)monthIncomeMonryLabel {
    if(!_monthIncomeMonryLabel) {
        _monthIncomeMonryLabel = [[UILabel alloc] init];
        _monthIncomeMonryLabel.textColor = [UIColor whiteColor];
        _monthIncomeMonryLabel.alpha = 0.75;
        _monthIncomeMonryLabel.font = [UIFont systemFontOfSize:12];
        _monthIncomeMonryLabel.frame = CGRectMake(10, 122, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _monthIncomeMonryLabel;
}
- (UILabel *)monthIncome {
    if(!_monthIncome) {
        _monthIncome = [[UILabel alloc] init];
        _monthIncome.textColor = [UIColor whiteColor];
        _monthIncome.font = [UIFont systemFontOfSize:14];
        _monthIncome.frame = CGRectMake(10, 145, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _monthIncome;
}
- (UILabel *)monthAcount {
    if(!_monthAcount) {
        _monthAcount = [[UILabel alloc] init];
        _monthAcount.textColor = [UIColor whiteColor];
        _monthAcount.font = [UIFont systemFontOfSize:14];
        _monthAcount.frame = CGRectMake(self.monthIncome.width+20, 145, (SCREEN_WIDTH-20)/2.0f, 20);
    }
    return _monthAcount;
}

- (UIView *)unbindingView {
    if(!_unbindingView) {
        _unbindingView = [[UIView alloc] init];
        _unbindingView.frame = CGRectMake(0, 185, SCREEN_WIDTH, 200);
        [_unbindingView addSubview:self.tipView];
        [_unbindingView addSubview:self.unBindTipTextView];
        [_unbindingView addSubview:self.buttonBank];
    }
    return _unbindingView;
}

- (UIView *)tipView {
    if(!_tipView) {
        _tipView = [[UIView alloc] init];
        _tipView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 25);
        [_tipView addSubview:self.tipLabel];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"ico_warning_r"];
        icon.frame = CGRectMake((SCREEN_WIDTH/2.0f)-75, 0, 25, 25);
        [_tipView addSubview:icon];
        
        self.tipLabel.frame = CGRectMake(icon.frame.origin.x + 25 + 10, 0, 200, 25);
    }
    return _tipView;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.text = NSLocalizedString(@"未绑定收款账户", nil);
    }
    return _tipLabel;
}

- (UITextView *)unBindTipTextView {
    if(!_unBindTipTextView) {
        _unBindTipTextView = [[UITextView alloc] init];
        _unBindTipTextView.text = NSLocalizedString(@"本店以下支付已自动开通，顾客扫码点餐后可使用。顾客支付成功的钱会打入您指定的账户，以下收款方式使用同一个指定的收款账户。第三方支付官方会收取一定服务费。请尽快绑定您的收款账户，才能收到顾客支付的付款！", nil);
        _unBindTipTextView.textColor = [UIColor whiteColor];
        _unBindTipTextView.alpha = 0.6;
        _unBindTipTextView.backgroundColor = [UIColor clearColor];
        _unBindTipTextView.font = [UIFont systemFontOfSize:12];
        _unBindTipTextView.frame = CGRectMake(8, 40, SCREEN_WIDTH-16, 95);
        _unBindTipTextView.userInteractionEnabled = NO;
    }
    return _unBindTipTextView;
}

- (UIButton *)buttonBank {
    if(!_buttonBank) {
        _buttonBank = [[UIButton alloc] init];
        [_buttonBank setTitle:NSLocalizedString(@"立即绑定收款账户", nil) forState:UIControlStateNormal];
        [_buttonBank setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonBank.titleLabel.font = [UIFont systemFontOfSize:16];
        [_buttonBank setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
        _buttonBank.frame = CGRectMake(8, 150, SCREEN_WIDTH-16, 40);
        [_buttonBank addTarget:self action:@selector(bindingBankAccountClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonBank;
}

- (UITextView *)bindingView {
    if(!_bindingView) {
        _bindingView = [[UITextView alloc] init];
        _bindingView.text = NSLocalizedString(@"注：电子收款明细账单信息汇总包括以下收款方式，是以下收款信息的综合。", nil);
        _bindingView.font = [UIFont systemFontOfSize:12];
        _bindingView.textColor = [UIColor whiteColor];
        _bindingView.frame = CGRectMake(8, 185, SCREEN_WIDTH-16, 60);
        _bindingView.alpha = 0.6;
        _bindingView.userInteractionEnabled = NO;
        _bindingView.backgroundColor = [UIColor clearColor];
    }
    return _bindingView;
}

- (UIView *)buttonsPanel {
    if(!_buttonsPanel) {
        _buttonsPanel = [[UIView alloc] init];
        _buttonsPanel.frame = CGRectMake(0, 380, SCREEN_WIDTH, 120);
    }
    return _buttonsPanel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.container addSubview:self.sumPanel];
    [self.container addSubview:self.buttonsPanel];
    
    [self loadData];
    [self initNavigate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self loadData];
     [self initNavigate];
}

- (void)initNavigate
{
    [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    self.title = NSLocalizedString(@"电子收款账户", nil);
    self.scrollView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"PAYMENT_TYPE_VIEW_CHANGE_NOTIFCATION" object:nil];
}

- (void) initMainView
{
    if ([self isChain]) {
        self.reChargeLabel = NSLocalizedString(@"充值", nil);
        self.unBindTipTextView.text = NSLocalizedString(@"绑定收款账户后，将为您开通电子支付，顾客可以使用微信或支付宝支付进行充值。顾客支付成功的钱将会打入您绑定的账户，两种充值方式使用同一个收款账户，微信和支付宝官方会收取一定的服务费。请尽快绑定您的收款账户！", nil);
    }else{
        self.reChargeLabel = NSLocalizedString(@"收款", nil);
    }
    
#pragma mark 如果是未绑定的
    if (self.settleAccountInfo.authStatus == 0) {
        self.tipLabel.text = NSLocalizedString(@"未绑定收款账户！", nil);
        self.tipLabel.font = [UIFont systemFontOfSize:13];
        self.tipLabel.textColor = [UIColor redColor];
        if ([self isChain]) {
            self.reChargeLabel = NSLocalizedString(@"充值", nil);
            self.unBindTipTextView.text = NSLocalizedString(@"绑定收款账户后，将为您开通电子支付，顾客可以使用微信、QQ钱包或支付宝支付进行充值。顾客支付成功的钱将会打入您绑定的账户，三种充值方式使用同一个收款账户，微信、QQ钱包和支付宝官方会收取一定的服务费。请尽快绑定您的收款账户！", nil);
            self.bindingView.text = NSLocalizedString(@"注：电子收款包括微信充值和支付宝充值两种充值方式的账单汇总信息。", nil);
        }else{
        self.unBindTipTextView.text = NSLocalizedString(@"绑定收款账户后，将为您开通电子支付，顾客可以使用以下方式进行付款，支付的款项将会打入您绑定的账户，微信、QQ钱包和支付宝官方会收取一定的服务费。请尽快绑定您的收款账户！", nil);
        self.unBindTipTextView.font = [UIFont systemFontOfSize:13];
        }
        [self.buttonBank setTitle:NSLocalizedString(@"立即绑定收款账户", nil) forState:UIControlStateNormal];
        }else if(self.settleAccountInfo.authStatus == 2){
#pragma mark 如果是进件失败
        self.tipLabel.text = NSLocalizedString(@"收款账户有误，请修改！", nil);
        self.tipLabel.font = [UIFont systemFontOfSize:13];
        self.tipLabel.textColor = [UIColor redColor];
         self.unBindTipTextView.text = NSLocalizedString(@"您的收款账户有误，请尽快修改，否则将不能收到顾客电子支付的钱。另外，根据央行政策，如未绑定正确的收款账户，电子支付将不能使用。请尽快修改，以免影响使用！", nil);
         self.unBindTipTextView.font= [UIFont systemFontOfSize:13];
        [self.buttonBank setTitle:NSLocalizedString(@"立即修改收款账户", nil) forState:UIControlStateNormal];
        }else if (self.settleAccountInfo.authStatus == 1){
             [self configRightNavigationBar:@"ico_bangWXcount.png" rightButtonName:NSLocalizedString(@"收款账户", nil)];
        }
        self.bindingView.text = NSLocalizedString(@"注：电子收款账单信息汇总包括以下收款方式，是以下收款信息的综合。", nil);
    
    self.totalUnCountMoneyLabel.text = [NSString stringWithFormat:NSLocalizedString(@"电子%@未到账总额（元）", nil),self.reChargeLabel];
    self.monthIncomeMonryLabel.text = [NSString stringWithFormat:NSLocalizedString(@"本月累计电子%@收入(元)", nil),self.reChargeLabel];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
    self.homeView.warningViewBox.hidden = YES;
}

-(void)loadData{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.shopInfo = [ShopInfoVO yy_modelWithDictionary:data[@"data"]];
        self.settleAccountInfo  = [TDFSettleAccountInfo yy_modelWithDictionary:data[@"data"][@"settleAccountInfo"]];
         [self initData:self.shopInfo menu:[TDFPaymentModule menuActionsWithShopVo:self.shopInfo]];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
}

-(void)initData:(ShopInfoVO *)shopInfo menu:(NSArray *)menus{
    [self initMainView];
    self.rate.text = NSLocalizedString(@"(已扣除服务费)", nil);
    self.shopInfo = shopInfo;
    self.menus = menus;
    [self initButtonPanel];
    [self updateViewSize:shopInfo];
    NSString *dayStr = [DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeChineseWithoutYear];
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    self.date = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)year,(long)month,(long)day];
    self.dayAcountTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@已到账金额(元)", nil),dayStr];
    self.dayIncomeTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@电子%@收入(元)", nil),dayStr,self.reChargeLabel];
    NSString *dateStr = [DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeYearWithMonth];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"year_month"] = dateStr;
    param[@"pay_type"] = @"-1";
    
    @weakify(self);
    [[TDFPaymentService new] getTotalBillsMoneyWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSDictionary *dict = [data objectForKey:@"data"];
        self.unAcount.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"noShareTotalFee"]];
        self.monthAcount.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthShareIncome"]];//monthShareIncome
        self.monthIncome.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthTotalFee"]];
        NSArray *array = [dict objectForKey:@"everyDays"];
        NSArray *datas = [NSArray yy_modelArrayWithClass:[PayBillSummaryOfMonthVO class] json:array];
        
        PayBillSummaryOfMonthVO *payVo = [PayBillSummaryOfMonthVO new];
        for (PayBillSummaryOfMonthVO *vo in datas) {
            
            if ([self.date isEqualToString:vo.date]) {
                payVo = vo;
            }
        }
        self.dayIncome.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:payVo.totalFee]];
        self.dayAcount.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:payVo.shareIncome]];
         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void)updateViewSize:(ShopInfoVO *)shopInfo{
    self.scrollView.hidden = NO;
    NSString *isSuper =[[Platform Instance]getkey:USER_IS_SUPER];
    BOOL isAccount = self.settleAccountInfo.authStatus == 1;
    CGFloat bindingH = isAccount?self.bindingView.height:self.unbindingView.height;
    self.rate.hidden = !isAccount;
    
    CGFloat feepanelH = 0;
    if ([self isChain]) {
        feepanelH =  [isSuper intValue] == 1 ? ( 170 + bindingH):(![self.codeArray containsObject:PHONE_BRAND_THIRD_PAY_SUM]?0:(170 + bindingH));
    }else{
        feepanelH =  [isSuper intValue] == 1 ? ( 170 + bindingH):(![self.codeArray containsObject:PAD_WEIXIN_SUM]?0:(170 + bindingH));
    }
    self.bindingView.hidden = !isAccount;
    
    self.unbindingView.hidden = isAccount;
    
    self.bindingAccountBtn.hidden = !isAccount;

    [self.sumBackView setHeight:feepanelH + 10];

    [self.sumPanel setHeight:self.sumBackView.height+self.sumBackView.top ];
    
    [self.sumPanel setHidden:feepanelH == 0 ?YES:NO];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    [self.buttonsPanel setTop: feepanelH == 0 ? (self.view.bounds.size.height/6): (feepanelH + 25)];
    
    NSLog(@"%.2lf",self.buttonsPanel.frame.origin.y);
}

#pragma mark 支付模块明细
-(void)initButtonPanel{
    
    for (UIView *view in self.buttonsPanel.subviews) {
        [view removeFromSuperview];
    }
    CGFloat space = (self.view.bounds.size.width - 84*self.menus.count)/(self.menus.count+1);
    for (int i =0 ; i < self.menus.count; i++) {
        NavButton1 *button = [NavButton1 buttonWithType:UIButtonTypeCustom];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.titleLabel.contentMode = UIViewContentModeBottom;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.frame = CGRectMake(space+84*i+space*i,15, 84, 95);
        button.action = self.menus[i];
        [button setTitle:button.action.detail forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:button.action.image] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsPanel addSubview:button];
    }
}

-(void)btnAction:(NavButton1 *)button{
#pragma mark 进件才可进入明细
    if(self.settleAccountInfo.authStatus == 1)
    {
          [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_orderPayListViewControllerWithShopInfo:self.shopInfo action:button.action isAccount:NO withCodeArray:self.codeArray] animated:YES];
    }else if(self.settleAccountInfo.authStatus == 0){
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"本店未绑定收款账户，不能查看此收款明细，请立即绑定收款账户", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"立即绑定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imChange];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    }else if(self.settleAccountInfo.authStatus == 2){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"本店未绑定正确的收款账户，不能查看此收款明细，请立即修改收款账户", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"立即修改", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self imChange];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }

}

- (void)imChange{
    NSString *isSuper =[[Platform Instance]getkey:USER_IS_SUPER];
    if ([isSuper isEqualToString:@"1"]){
    [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
    }] animated:YES];
    }else
    {
        [AlertBox show:NSLocalizedString(@"您没有[收款账户]的权限", nil)];
    }
}


#pragma mark 设置埋点
-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}

- (IBAction)bindingBankAccountClick:(id)sender {
    [self BtnClick];
}

- (void)rightNavigationButtonAction:(id)sender{
     [self BtnClick];
}

- (void)BtnClick{
    NSString *isSuper =[[Platform Instance]getkey:USER_IS_SUPER];
    if ([isSuper isEqualToString:@"1"]){
        //未进件或进件失败
        if(self.settleAccountInfo.authStatus == 0){
            [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
            }] animated:YES];
            }
       if (self.settleAccountInfo.authStatus == 2){
            [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
            }] animated:YES];
        }
       if (self.settleAccountInfo.authStatus == 1){
            //已进件
            [self setRightBarButtonHidden:NO];
            //已进件未审核
            if (self.settleAccountInfo.auditStatus == 0) {
                [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
                }] animated:YES];
            }else{
                //进件后跳转到变更状态页面
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                NSString  *failStr   = [defaults objectForKey:[NSString stringWithFormat:@"%@-failure",self.settleAccountInfo.entityId]];
                NSString  *sucStr = [defaults objectForKey:[NSString stringWithFormat:@"%@-success",self.settleAccountInfo.entityId]];
                
                if ([sucStr isEqualToString:[NSString stringWithFormat:@"%ld",self.settleAccountInfo.auditTime]]  || [failStr isEqualToString:[NSString stringWithFormat:@"%ld",self.settleAccountInfo.auditTime]] ) {
                    [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
                    }] animated:YES];
                }else{
                    NSInteger auditStatus =self.settleAccountInfo.auditStatus;
                    [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentStatusViewControllerWithStatus:auditStatus]animated:YES];
                }
            }
        }
    }else
    {
        [AlertBox show:NSLocalizedString(@"您没有[收款账户]的权限", nil)];
    }
    [self umengEvent:@"click_bank_account" attributes:nil number:@(1)];
}

- (BOOL) isChain
{
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
