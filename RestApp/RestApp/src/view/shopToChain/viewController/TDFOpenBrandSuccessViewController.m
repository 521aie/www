//
//  TDFOpenBrandSuccessViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2017/3/2.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOpenBrandSuccessViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFMediator+StoresModule.h"
#import "TDFShopBusinessService.h"
#import "RestConstants.h"
#import "ColorHelper.h"
#import "UIColor+Hex.h"
#import "StoresView.h"
#import "Platform.h"
#import "TDFLoginService.h"
#import "AccountCenter.h"
#import "TDFCompositeLoginResultVo.h"
#import "TDFCompositeLoginParam.h"

@interface TDFOpenBrandSuccessViewController ()
@property (nonatomic, strong) UIImageView *igvIcon;
@property (nonatomic, strong) UILabel *lblOpenSuccess;
@property (nonatomic, strong) UILabel *lblShopName;
@property (nonatomic, strong) UILabel *lblShopNameDescription;
@property (nonatomic, strong) UILabel *lblShopCode;

@property (nonatomic, strong) UILabel *lblUserName;

@property (nonatomic, strong) UILabel *lblLoginPassword;

@property (nonatomic, strong) UILabel *lblCashPassword;

@property (nonatomic, strong) UILabel *lblDescription;

@property (nonatomic, strong) UIButton *btnLogin;
@end

@implementation TDFOpenBrandSuccessViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
    if ([self.event isEqualToString:FROMINVITESHOPTOJOINCHAIN]) {
        self.title = @"成功加入连锁";
        [self joinBrandView];
    }else{
        self.title = @"已开通连锁";
        [self configView];
    }
}

- (void) joinBrandView
{
    [self initBaseView];
    self.lblShopNameDescription.text = [NSString stringWithFormat:@"%@已加入%@",self.shopName,[[Platform Instance] getkey:SHOP_NAME]];
    [self.view addSubview:self.lblShopNameDescription];
    [self.lblShopNameDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblOpenSuccess.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(13));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [self.view addSubview:self.lblDescription];
    self.lblDescription.text = @"提示：门店加入连锁后，若要使用连锁相关功能，如门店卡升级成连锁卡，连锁商品下发等。请到连锁相关功能模块去设置。";
    [self.lblDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblShopNameDescription.mas_bottom).with.offset(50);
        make.leading.equalTo(self.view.mas_leading).with.offset(10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
        make.height.equalTo(@(40));
    }];
    
    [self.view addSubview:self.btnLogin];
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblDescription.mas_bottom).with.offset(20);
        make.leading.equalTo(self.view.mas_leading).with.offset(10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
        make.height.equalTo(@(40));
    }];
}

- (void)configView
{
    [self initBaseView];
    self.lblShopName.text = self.model.brandName;
    [self.view addSubview:self.lblShopName];
    [self.lblShopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblOpenSuccess.mas_bottom).with.offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(18));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
      self.lblShopNameDescription.text = [NSString stringWithFormat:@"%@已加入%@",self.model.shopName,self.model.brandName];
    [self.view addSubview:self.lblShopNameDescription];
    [self.lblShopNameDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblShopName.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(13));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblShopNameDescription.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(55));
        make.width.equalTo(@(160));
    }];
    
    self.lblShopCode.text = [NSString stringWithFormat:@"连锁编码：%@",self.model.brandCode];
    [bgView addSubview:self.lblShopCode];
    [self.lblShopCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).with.offset(0);
        make.left.equalTo(bgView.mas_left).with.offset(0);
        make.height.equalTo(@(13));
        make.width.equalTo(@(160));
    }];
    
    self.lblUserName.text = [NSString stringWithFormat:@"管理员用户名：%@",self.model.name];
    [bgView addSubview:self.lblUserName];
    [self.lblUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblShopCode.mas_bottom).with.offset(8);
        make.left.equalTo(bgView.mas_left).with.offset(0);
        make.height.equalTo(@(13));
        make.width.equalTo(@(160));
    }];
    
    self.lblLoginPassword.text = [NSString stringWithFormat:@"管理员密码：%@",self.model.password];
    [bgView addSubview:self.lblLoginPassword];
    [self.lblLoginPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblUserName.mas_bottom).with.offset(8);
        make.left.equalTo(bgView.mas_left).with.offset(0);
        make.height.equalTo(@(13));
        make.width.equalTo(@(160));
    }];

    [self.view addSubview:self.lblDescription];
    self.lblDescription.text = [NSString stringWithFormat:@"提示：以上账号信息已经发送到手机：%@,请妥善保管好您的账号。同时，建议用手机截屏功能，将此页面截图做个备份。",self.model.mobile];
    [self.lblDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).with.offset(20);
        make.leading.equalTo(self.view.mas_leading).with.offset(10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
        make.height.equalTo(@(40));
    }];
    
    [self.view addSubview:self.btnLogin];
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblDescription.mas_bottom).with.offset(20);
        make.leading.equalTo(self.view.mas_leading).with.offset(10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
        make.height.equalTo(@(40));
    }];
}

-  (void) initBaseView
{
    [self.view addSubview:self.igvIcon];
    [self.igvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(30));
        make.width.equalTo(@(30));
    }];
    
    if ([self.event isEqualToString:FROMINVITESHOPTOJOINCHAIN]) {
        self.lblOpenSuccess.text = @"邀请成功";
    }else{
        self.lblOpenSuccess.text = @"创建成功";
    }
    [self.view addSubview:self.lblOpenSuccess];
    [self.lblOpenSuccess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.igvIcon.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(20));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
}

#pragma mark -- Actions --

- (void)btnLoginClicked
{
    if ([self.event isEqualToString:FROMINVITESHOPTOJOINCHAIN]) {
        TDFMediator *mediator = [[TDFMediator alloc] init];
        @weakify(self);
        UIViewController *viewontroller = [mediator TDFMediator_editStoresViewControllerWithShopId:self.shopId editStoresCallBack:^(BOOL orFresh) {
            @strongify(self);
            __block StoresView *indexView;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[StoresView class]]) {
                    indexView = (StoresView *)obj;
                    [indexView loadData];
                    *stop = YES;
                }
            }];
            [self.navigationController popToViewController:indexView animated:YES];
        }];
        [self.navigationController pushViewController:viewontroller animated:YES];
    }else{
        @weakify(self);
        [[TDFShopBusinessService sharedInstance] loginWithShopCode:self.model.brandCode userName:self.model.name password:self.model.password completeBlock:^(BOOL isSuccess, NSString *errorMessage) {
            @strongify(self);
            if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_ShopToChain" object:nil];
                    [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                NSString *message = [errorMessage isEqualToString:@""] ? @"登录失败，请重新点击“进入连锁总部”" : errorMessage;
                [self showMessageWithTitle:@"提示" message:message cancelTitle:@"我知道了"];
            }
        }];
    }
}


- (void)leftNavigationButtonAction:(id)sender
{
    if ([self.event isEqualToString:FROMINVITESHOPTOJOINCHAIN]) {
        __block StoresView *indexView;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[StoresView class]]) {
                indexView = obj;
                [indexView loadData];
                *stop = YES;
            }
        }];
        [self.navigationController popToViewController:indexView animated:YES];
    }else{
        [self compositeLogin];
    }
}

#pragma mark -- Private Methods --

- (UILabel *)leftTitleLabel
{
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblLeft setFont:[UIFont systemFontOfSize:13]];
    lblLeft.textColor = [ColorHelper getTipColor3];
    lblLeft.textAlignment = NSTextAlignmentLeft;
    
    return lblLeft;
}

#pragma mark -- Getters && Setters --

- (UIImageView *)igvIcon
{
    if (!_igvIcon) {
        _igvIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_check.png"]];
    }
    
    return _igvIcon;
}

- (UILabel *)lblOpenSuccess
{
    if (!_lblOpenSuccess) {
        _lblOpenSuccess = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lblOpenSuccess setFont:[UIFont systemFontOfSize:20]];
        _lblOpenSuccess.textColor = [UIColor colorWithHeX:0x07AD1F];
        _lblOpenSuccess.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblOpenSuccess;
}

- (UILabel *)lblShopName
{
    if (!_lblShopName) {
        _lblShopName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lblShopName setFont:[UIFont systemFontOfSize:18]];
        _lblShopName.textColor = [ColorHelper getTipColor3];
        _lblShopName.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblShopName;
}

- (UILabel *)lblShopNameDescription
{
    if (!_lblShopNameDescription) {
        _lblShopNameDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lblShopNameDescription setFont:[UIFont systemFontOfSize:13]];
        _lblShopNameDescription.textColor = [ColorHelper getTipColor3];
        _lblShopNameDescription.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblShopNameDescription;
}

- (UILabel *)lblShopCode
{
    if (!_lblShopCode) {
        _lblShopCode = [self leftTitleLabel];
    }
    
    return _lblShopCode;
}


- (UILabel *)lblUserName
{
    if (!_lblUserName) {
        _lblUserName = [self leftTitleLabel];
    }
    
    return _lblUserName;
}

- (UILabel *)lblLoginPassword
{
    if (!_lblLoginPassword) {
        _lblLoginPassword = [self leftTitleLabel];
    }
    
    return _lblLoginPassword;
}

- (UILabel *)lblCashPassword
{
    if (!_lblCashPassword) {
        _lblCashPassword = [self leftTitleLabel];
    }
    
    return _lblCashPassword;
}

- (UILabel *)lblDescription
{
    if (!_lblDescription) {
        _lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lblDescription setFont:[UIFont systemFontOfSize:11]];
        _lblDescription.textColor = [ColorHelper getTipColor6];
        _lblDescription.numberOfLines = 0;
        _lblDescription.lineBreakMode = UILineBreakModeCharacterWrap;
    }
    
    return _lblDescription;
}

- (UIButton *)btnLogin
{
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] initWithFrame:CGRectZero];
        if ([self.event isEqualToString:FROMINVITESHOPTOJOINCHAIN]) {
            [_btnLogin setTitle:@"完善门店信息" forState:UIControlStateNormal];
        }else{
            [_btnLogin setTitle:@"进入连锁总部" forState:UIControlStateNormal];
        }
        [_btnLogin setBackgroundColor:[ColorHelper getRedColor]];
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.layer.cornerRadius = 5;
        [_btnLogin.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnLogin addTarget:self action:@selector(btnLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}

- (void)compositeLogin {
    
    TDFCompositeLoginParam *compositeLoginVO = [[TDFCompositeLoginParam alloc] init];
    compositeLoginVO.loginType = 3;
    compositeLoginVO.code = [[Platform Instance] getkey:SHOP_CODE];
    compositeLoginVO.memberUserId =  [Platform Instance].memberUserId;
    compositeLoginVO.userId = [[Platform Instance] getkey:USER_ID];
    compositeLoginVO.entityId = [[Platform Instance] getkey:ENTITY_ID];
    
    @weakify(self);
    [[[TDFLoginService alloc] init] compositeLogin:@{@"param_str":[compositeLoginVO getJsonStr]} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        
        TDFCompositeLoginResultVo *compositeLoginResultVo = [TDFCompositeLoginResultVo yy_modelWithJSON:data[@"data"]];
        compositeLoginResultVo.memberUserShopVo = [[ShopLoginVo alloc] init];
        compositeLoginResultVo.memberUserShopVo.entityType = 2;
        
        @weakify(self);
        [[AccountCenter sharedInstance] shopLoginWithCompositeLoginResultVo:compositeLoginResultVo loginSuccessCallBack:^{
            @strongify(self);
            [AccountCenter setUserChangeShopType:@"0"];
            [self performSelectorOnMainThread:@selector(successSwitchShop) withObject:nil waitUntilDone:YES];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self performSelectorOnMainThread:@selector(failureSwitchShop:) withObject:error.localizedDescription waitUntilDone:YES];
    }];
}

- (void)successSwitchShop
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShopWorkStatus_Change object:@{@"hasWorkShop":@(YES)}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_MAIN_SHOW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Permission_Change object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

