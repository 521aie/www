//
//  TDFInviteShopToJoinViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2017/3/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFInviteShopToJoinViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFIntroductionHeaderView.h"
#import "DHTTableViewManager.h"
#import "TDFTextfieldItem.h"
#import "ColorHelper.h"
#import "TDFShopToChainService.h"
#import "TDFVerificationCodeItem.h"
#import "NSString+Estimate.h"
#import "TDFOpenBrandSuccessViewController.h"
#import "TDFInternationalRender.h"

@interface TDFInviteShopToJoinViewController ()
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) TDFTextfieldItem *shopCode;
@property (nonatomic, strong) TDFTextfieldItem *phoneNumeber;
@property (nonatomic, strong) TDFTextfieldItem *verificationCode;
@property (nonatomic, strong) TDFVerificationCodeItem *getVerificationCode;
@property (nonatomic, strong) UIButton *button;
@end

@implementation TDFInviteShopToJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请门店加入";
    [self configDefaultManager];
    self.tbvBase.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.tbvBase.tableFooterView = self.tableFooterView;
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc]
                                    initWithImageIcon:[UIImage imageNamed:@"inviteShopJoin"] description:@"连锁可邀请已有门店加入连锁总部。通过输入门店绑定的手机号码来发出邀请。手机会收到验证码，连锁需要输入验证码才能邀请成功。"];
    [(TDFIntroductionHeaderView *)self.tbvBase.tableHeaderView changeBackAlpha:0];
    
    [self configureManager];
    [self addSection];
}

- (void)addSection
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    DHTTableViewSection *headSetion = [DHTTableViewSection section];
    headSetion.headerView = line;
    headSetion.headerHeight = 1;
    [self.manager addSection:headSetion];
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    [self.manager addSection:section];
    
    self.shopCode = [[TDFTextfieldItem alloc] init];
    self.shopCode.keyboardType = UIKeyboardTypeDefault;
    self.shopCode.title = @" 店家编码";
    self.shopCode.preValue = @"";
    self.shopCode.textValue = @"";
    [section addItem:self.shopCode];
    
    self.phoneNumeber = [[TDFTextfieldItem alloc] init];
    self.phoneNumeber.title = @"手机号码";
    self.phoneNumeber.detail = @"注意此处需输入跟门店绑定的手机号码";
    self.phoneNumeber.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumeber.preValue = @"";
    self.phoneNumeber.textValue = @"";
    [section addItem:self.phoneNumeber];
    
    self.getVerificationCode = [[TDFVerificationCodeItem alloc]init];
    self.getVerificationCode.title = @"获得验证码";
    @weakify(self);
    self.getVerificationCode.filterBlock = ^(){
        @strongify(self);
        if (![self isValue]) {
            return ;
        }
        if ([self isValue]) {
            [self sendInviteShopVerCode];
        }
    };
    
    [section addItem:self.getVerificationCode];
    
    self.verificationCode = [[TDFTextfieldItem alloc] init];
    self.verificationCode.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCode.title = @"输入验证码";
    self.verificationCode.preValue = @"";
    self.verificationCode.textValue = @"";
    self.verificationCode.filterBlock = ^(NSString *textValue)
    {
        @strongify(self);
        if (textValue.length == 0) {
            [self.button setBackgroundColor:[ColorHelper getTipColor9]];
            self.button.userInteractionEnabled = NO;
        }else{
            [self.button setBackgroundColor:[ColorHelper getRedColor]];
            self.button.userInteractionEnabled = YES;
        }
        if (textValue.length > 4) {
            return NO;
        }
        return YES;
    };
    [section addItem:self.verificationCode];
}


#pragma mark --configure
- (void)configureManager
{
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFVerificationCodeCell" withItem:@"TDFVerificationCodeItem"];
}

#pragma mark -- init

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [UIView new];
        [self initWithFooterView];
    }
    return _tableFooterView;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}

- (UIButton *) button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 40);
        [_button addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"邀请加入" forState:UIControlStateNormal];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 5;
        [_button setBackgroundColor:[ColorHelper getTipColor9]];
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

- (void)initWithFooterView
{
    _tableFooterView .frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH - 20, 30)];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:11];
    label.text = @"提示：门店加入连锁后，如果之前使用过二维火供应链，原数据将不能继续使用。";
    [_tableFooterView addSubview:self.button];
    [_tableFooterView addSubview:label];
}

- (void)saveButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    if (![self isValue]) {
        return;
    }
    //确认邀请
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"加入连锁后，如果该门店之前使用过二维火供应链，原数据(原料,供应商,商品配比,各单据,各报表等)将无法查看和使用！建议先导出需要的数据信息再加入连锁。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定邀请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self inviteShop];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancleAction];
    [ac addAction:sureAction];
    [self presentViewController:ac animated:YES completion:nil];
    
}

- (BOOL) isValue
{
    if ([NSString isBlank:self.shopCode.textValue]) {
        [AlertBox show:@"店家编码不能为空"];
        return NO;
    }
    if (self.phoneNumeber.textValue.length == 0) {
        [AlertBox show:@"手机号码不能为空"];
        return NO;
    }
    return YES;
}

- (void)sendInviteShopVerCode
{
    [self showProgressHudWithText:@"正在加载"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"shop_code"] = self.shopCode.textValue;
    dic[@"mobile"] = self.phoneNumeber.textValue;
    dic[@"brand_name"] = [[Platform Instance] getkey:SHOP_NAME];
    @weakify(self);
    [[TDFShopToChainService alloc]sendInviteShopVerCodeWithParam:dic sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        NSString *countryCode = data[@"data"];
        self.getVerificationCode.detail = [NSString stringWithFormat:@"店铺绑定的手机：%@ %@，会收到一条邀请加入的短信和验证码。需联系对方获得验证码才能邀请成功。",countryCode,self.phoneNumeber.textValue];
        self.getVerificationCode.OrResetTimer = YES;
        [self.manager reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)inviteShop
{
    [self showProgressHudWithText:@"正在加载"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"shop_code"] = self.shopCode.textValue;
    dic[@"mobile"] = self.phoneNumeber.textValue;
    dic[@"auth_code"] = self.verificationCode.textValue;
    @weakify(self);
    [[TDFShopToChainService alloc]inviteShopWithParam:dic sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        TDFOpenBrandSuccessViewController *viewController = [[TDFOpenBrandSuccessViewController alloc] init];
        viewController.event = FROMINVITESHOPTOJOINCHAIN;
        viewController.shopId = data[@"data"][@"id"];
        viewController.shopName = data[@"data"][@"shopName"];
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

@end
