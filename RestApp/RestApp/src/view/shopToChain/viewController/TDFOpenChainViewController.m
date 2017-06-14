//
//  TDFOpenChainViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2017/3/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOpenChainViewController.h"
#import "TDFShopToChainService.h"
#import "DHTTableViewManager.h"
#import "TDFShopInfoService.h"
#import "TDFEditViewHelper.h"
#import "TDFResponseModel.h"
#import "TDFTextfieldItem.h"
#import "ColorHelper.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "TDFOpenBrandSuccessViewController.h"

@interface TDFOpenChainViewController ()
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) TDFTextfieldItem *shopName;
@property (nonatomic, strong) TDFTextfieldItem *phoneNumeber;
@property (nonatomic,strong) UIView *sectionFooterView;
@end

@implementation TDFOpenChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通连锁";
    [self initTableView];
    [self configureManager];
    [self addSection];
}

- (void)addSection
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    [self.manager addSection:section];
    self.shopName = [[TDFTextfieldItem alloc] init];
    self.shopName.keyboardType = UIKeyboardTypeDefault;
    self.shopName.title = @"总部名称";
    self.shopName.detail = @"如：旺火餐饮集团";
    self.shopName.requestKey = @"brand_name";
    self.shopName.preValue = @"";
    self.shopName.textValue = @"";
    [section addItem:self.shopName];
    
    self.phoneNumeber = [[TDFTextfieldItem alloc] init];
    self.phoneNumeber.title = @"手机号码";
    self.phoneNumeber.detail = @"开连锁成功后，账号信息将以短信形式发送到您的手机上。";
    self.phoneNumeber.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumeber.requestKey = @"mobile";
    self.phoneNumeber.preValue = @"";
    self.phoneNumeber.textValue = @"";
    [section addItem:self.phoneNumeber];
 
    DHTTableViewSection *footerSection = [DHTTableViewSection section];
    footerSection.footerView = self.sectionFooterView;
    footerSection.footerHeight = 38;
    [self.manager addSection:footerSection];
}

#pragma mark --configure
- (void)configureManager
{
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
}

#pragma mark -- init

- (void)initTableView {
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.tableView.tableFooterView = self.tableFooterView;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:self.tableView];
}

- (void)hideAllKeyboard
{
    [self.view endEditing:YES];
}

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

- (void)initWithFooterView
{
    _tableFooterView .frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 20, SCREEN_WIDTH - 20, 40);
    [button addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundColor:[ColorHelper getRedColor]];
    [_tableFooterView addSubview:button];
}

- (UIView *)sectionFooterView {
    if(!_sectionFooterView) {
        _sectionFooterView = [[UIView alloc] init];
        _sectionFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [ColorHelper getRedColor];
        label.font = [UIFont systemFontOfSize:11];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 28);
        label.text = NSLocalizedString(@"此功能为新开通一个连锁。如果门店需要加入已有的连锁，请联系总部向门店发出邀请。", nil);
        [_sectionFooterView addSubview:label];
    }
    return _sectionFooterView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return _tableView;
}

#pragma mark -- buttonClick
- (void)saveButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    if (![self isValue]) {
        return;
    }
    [self creatBrand];
}

- (BOOL) isValue
{
    if (self.shopName.textValue.length < 3 || [NSString isBlank:self.shopName.textValue]) {
        [AlertBox show:@"总部名称不能少于3个字符"];
        return NO;
    }
    if (self.shopName.textValue.length >20) {
        [AlertBox show:@"总部名称不能超过20个字符"];
        return NO;
    }
    if (self.phoneNumeber.textValue.length == 0) {
        [AlertBox show:@"手机号码不能为空"];
        return NO;
    }
    return YES;
}

- (void) creatBrand
{
    [self showProgressHudWithText:@"正在加载"];
    NSMutableDictionary *dic = [TDFEditViewHelper formatSectionsData:self.manager.sections toDictionary:nil];
    @weakify(self);
    [[TDFShopToChainService alloc]createBrandWithParam:dic sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        TDFShopUpgradeBrandModel *model = [TDFShopUpgradeBrandModel yy_modelWithJSON:data[@"data"]];
        TDFOpenBrandSuccessViewController *viewController = [[TDFOpenBrandSuccessViewController alloc] init];
        viewController.model = model;
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

@end
