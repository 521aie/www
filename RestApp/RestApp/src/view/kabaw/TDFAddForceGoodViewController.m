//
//  TDFAddForceGoodViewController.m
//  RestApp
//
//  Created by hulatang on 16/8/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAddForceGoodViewController.h"
#import "TDFAddForceGoodView.h"
#import "TDFSettingService.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "YYModel.h"
@interface TDFAddForceGoodViewController()<TDFAddForceGoodViewDelegate>
{
    MBProgressHUD *_hud;
    BOOL _changeStatus;
}
@property (nonatomic, strong)TDFAddForceGoodView *forceView;
@property (nonatomic, strong)TDFSettingService *service;
@end

@implementation TDFAddForceGoodViewController

#pragma mark --init
- (TDFSettingService *)service
{
    if (!_service) {
        _service = [[TDFSettingService alloc] init];
    }
    return _service;
}

- (TDFAddForceGoodView *)forceView
{
    if (!_forceView) {
        _forceView = [[TDFAddForceGoodView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:self.forceView];
    }
    return _forceView;
}

- (void)setForceMenuVo:(TDFForceMenuVo *)forceMenuVo
{
    _forceMenuVo = forceMenuVo;
    self.forceView.forceMenuVo = forceMenuVo;
}

- (void)setStatus:(TDFStatus)status
{
    _status = status;
    self.forceView.isEdit = status ==0 ?NO:YES;
    if (status == 0) {
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设定必选商品", nil);
    self.forceView.delegate = self;
}

#pragma mark --click
- (void)rightNavigationButtonAction:(UIButton *)button
{
    [super rightNavigationButtonAction:button];
    if (!self.forceView.forceConfig.menuId) {
        self.forceView.forceConfig.menuId = self.forceMenuVo.menuId;
    }
    self.forceView.forceConfig.menuType = self.forceMenuVo.menuType;
    if (self.forceMenuVo.makeList.count > 0) {
        if (!self.forceView.forceConfig.make.makeId) {
            [AlertBox show:NSLocalizedString(@"做法不能为空！", nil)];
            return;
        }
    }
    if (self.forceMenuVo.specList.count) {
        if (!self.forceView.forceConfig.spec.specId) {
            [AlertBox show:NSLocalizedString(@"规格不能为空！", nil)];
            return;
        }
    }
    
    NSString *infoString = [self.forceView.forceConfig yy_modelToJSONString];
    NSDictionary *dictionary = @{@"force_config":infoString};
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:mainWindow];
    }
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:mainWindow andHUD:_hud];
    @weakify(self);
    [self.service saveForceMenuWith:dictionary and:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [_hud hide:YES];
        self.forceMenuVo.forceConfigVo = self.forceView.forceConfig;
        self.callBack(self.forceMenuVo);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [_hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:_changeStatus];
}
- (void)confirmChangedMessage {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --TDFAddForceGoodViewDelegate
- (void)changeEditStatus:(BOOL)status
{
    _changeStatus = status;
    if (self.status) {
        [self configNavigationBar:status];
    }
}

- (void)deleteForceMenuWithData:(id)data
{
    if ([data isKindOfClass:[TDFForceConfigVo class]]) {
        TDFForceConfigVo *configVo = (TDFForceConfigVo *)data;
        NSDictionary *dictionary = @{@"config_id":configVo.configId};
        if (!self.forceView.forceConfig.menuId) {
            self.forceView.forceConfig.menuId = self.forceMenuVo.menuId;
        }
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        if (!_hud) {
            _hud = [[MBProgressHUD alloc] initWithView:mainWindow];
        }
        [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:mainWindow andHUD:_hud];
        @weakify(self);
        [self.service deleteForceMenuWith:dictionary and:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [_hud hide:YES];
            self.callBack(self.forceMenuVo);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [_hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

@end
