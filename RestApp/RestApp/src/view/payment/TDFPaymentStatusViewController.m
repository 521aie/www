//
//  TDFPaymentStatusViewController.m
//  RestApp
//
//  Created by 栀子花 on 2016/11/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPaymentStatusViewController.h"
#import <Masonry.h>
#import "ColorHelper.h"
#import "TDFMediator+PaymentModule.h"
#import "TDFPaymentService.h"
#import "TDFSettleAccountInfo.h"
#import "AlertBox.h"
#import "YYModel.h"
#import "ShopInfoVO.h"
#import "TDFPaymentModule.h"
#import "PaymentTypeView.h"

@interface TDFPaymentStatusViewController ()
@property(nonatomic,strong)TDFSettleAccountInfo *settleAccountInfo;
@end

@implementation TDFPaymentStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    self.title = NSLocalizedString(@"收款账户", nil);
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
    [self loadData];
    if (self.status == 1) {
                [self wait];
    }else if (self.status == 2){
                [self success];
    }else if(self.status == 3){
                [self failure];
    }
}

- (void) loadData{
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.settleAccountInfo  = [TDFSettleAccountInfo yy_modelWithDictionary:data[@"data"][@"settleAccountInfo"]];

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)wait
{
    __weak typeof (self) weakSelf = self;

    //图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shalou@2x.png"]];
    [self.view addSubview:image];
    
    //文字1
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = [UIColor orangeColor];
    tipLabel.font = [UIFont systemFontOfSize:18];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = NSLocalizedString(@"收款账户变更已提交，请耐心等待审核", nil);
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    
    //文字2
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = [UIFont systemFontOfSize:11];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = NSLocalizedString(@"注：1.五个工作日内会返回审核结果，请耐心等待。\n2.审核期间，顾客电子支付的钱，由兴业银行转入原账户，审核通过后转入新账户。", nil);
     detailLabel.numberOfLines = 0;
    [self.view addSubview:detailLabel];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.view.mas_top).with.offset(100);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(@28);
        make.height.equalTo(@30);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(image.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(260, 80));
    }];
}

- (void)success
{
    __weak typeof (self) weakSelf = self;
    //图片
    UIImageView *faceView    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_smile_face@2x.png"]];
    [self.view addSubview:faceView];
    
    //label
    UILabel *tipsLabel           = [[UILabel alloc]init];
    tipsLabel.textColor          = [ColorHelper getGreenColor];
    tipsLabel.font               = [UIFont systemFontOfSize:18];
    tipsLabel.textAlignment      = NSTextAlignmentCenter;
    tipsLabel.text               =NSLocalizedString(@"恭喜您，收款账户变更审核通过", nil);
     tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
    
    //按钮
    UIButton *loginBtn           = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(successClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font     = [UIFont systemFontOfSize:15];
    loginBtn.backgroundColor     = [ColorHelper getGreenColor];
    [loginBtn setTitle:NSLocalizedString(@"查看收款账户", nil)  forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius  = 5;
    [self.view addSubview:loginBtn];

    [faceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.view.mas_top).with.offset(100);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(faceView.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(300, 40));
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipsLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 44));
    }];
}

-(void)failure
{
    __weak typeof (self) weakSelf = self;
    
    //图片
    UIImageView *faceView    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_tanhao.png"]];
    [self.view addSubview:faceView];
    
    UILabel *tipsLabel           = [[UILabel alloc]init];
    tipsLabel.textColor          = [ColorHelper getRedColor];
    tipsLabel.font               = [UIFont systemFontOfSize:18];
    tipsLabel.textAlignment      = NSTextAlignmentCenter;
    tipsLabel.text               =NSLocalizedString(@"抱歉，收款账户变更审核未通过", nil);
    tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
    
    //按钮
    UIButton *loginBtn           = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(failureClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font     = [UIFont systemFontOfSize:15];
    loginBtn.backgroundColor     =[ColorHelper getRedColor];
    [loginBtn setTitle:NSLocalizedString(@"修改收款账户", nil)  forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius  = 5;
    [self.view addSubview:loginBtn];
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.settleAccountInfo  = [TDFSettleAccountInfo yy_modelWithDictionary:data[@"data"][@"settleAccountInfo"]];
        if (self.settleAccountInfo.auditMessage.length >0 ) {
            //reason
            UILabel   *reasonTip =    [[UILabel alloc]init];
            reasonTip.textColor   = [UIColor grayColor];
            reasonTip.font  = [UIFont systemFontOfSize:11];
            reasonTip.textAlignment  = NSTextAlignmentCenter;
            reasonTip.text      =[NSString stringWithFormat: NSLocalizedString(@"注：审核未通过原因是%@", nil),self.settleAccountInfo.auditMessage];
            reasonTip.numberOfLines = 0;
            [self.view addSubview: reasonTip];
            
            [reasonTip mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(tipsLabel.mas_bottom).with.offset(5);
                make.centerX.equalTo(weakSelf.view);
                make.size.mas_equalTo(CGSizeMake(300, 30));
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

       [faceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.view.mas_top).with.offset(100);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];

    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(faceView.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(300, 25));
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipsLabel.mas_bottom).with.offset(35);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 40));
    }];
}

#pragma mark -- 导航左边按钮以及取消按钮点击事件
-(void)leftNavigationButtonAction:(id)sender
{
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[PaymentTypeView class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
}

#pragma mark - 点击查看收款账户
-(void)successClick
{
    [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_paymentEditViewControllerWithCallBack:^{
    }] animated:YES];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *saveValue = [NSString stringWithFormat:@"%@-success",self.settleAccountInfo.entityId];
    [defaults setObject:[NSString stringWithFormat:@"%ld",self.settleAccountInfo.auditTime] forKey:saveValue];
    //把数据写到硬盘
    [defaults synchronize];
}

#pragma mark - 点击修改收款账户
- (void)failureClick{
    [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
    }] animated:YES];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *saveValue = [NSString stringWithFormat:@"%@-failure",self.settleAccountInfo.entityId];
    [defaults setObject:[NSString stringWithFormat:@"%ld",self.settleAccountInfo.auditTime] forKey:saveValue];
    //把数据写到硬盘
    [defaults synchronize];
    
}
@end
